locals {
  rds_param_group_name = "${local.prefix}-rds-param-group"
  rds_proxy_name       = "${local.prefix}-rds-proxy"
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    "Name" = "${var.name}-db-subnet-group"
  }
}

resource "aws_db_parameter_group" "main" {
  name   = local.rds_param_group_name
  family = "postgres12"

  parameter {
    name         = "max_connections"
    value        = "LEAST({DBInstanceClassMemory*2/9531392},5000)"
    apply_method = "pending-reboot"
  }

  tags = merge(
    local.module_tags,
    {
      "Name" = local.rds_param_group_name
    }
  )
}

resource "aws_db_instance" "main" {
  engine                          = "postgres"
  engine_version                  = "12.5"
  identifier                      = var.name
  username                        = var.main_db_username
  password                        = var.main_db_password
  instance_class                  = "db.t4g.small"
  storage_type                    = "gp3"
  allocated_storage               = 20
  max_allocated_storage           = 1000
  storage_encrypted               = false
  multi_az                        = false
  availability_zone               = "ap-northeast-1a"
  db_subnet_group_name            = aws_db_subnet_group.main.name
  vpc_security_group_ids          = [aws_security_group.for_rds.id]
  parameter_group_name            = aws_db_parameter_group.main.name
  backup_retention_period         = 7
  backup_window                   = "17:00-18:00"
  copy_tags_to_snapshot           = true
  maintenance_window              = "sun:18:00-sun:19:00"
  auto_minor_version_upgrade      = true
  monitoring_interval             = 60
  performance_insights_enabled    = true
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  deletion_protection             = true
  skip_final_snapshot             = false
  final_snapshot_identifier       = "${var.name}-main-rds-final-snapshot"
  apply_immediately               = true

  tags = {
    "Name" = "${var.name}-main-rds"
  }

  lifecycle {
    ignore_changes = [
      engine_version
    ]
  }
}

resource "aws_db_proxy" "main" {
  name                   = local.rds_proxy_name
  engine_family          = "POSTGRESQL"
  role_arn               = aws_iam_role.rds_proxy_role.arn
  vpc_subnet_ids         = var.subnet_ids
  vpc_security_group_ids = [aws_security_group.for_rds_proxy.id]
  idle_client_timeout    = 60

  auth {
    auth_scheme = "SECRETS"
    secret_arn  = aws_secretsmanager_secret.main.arn
    iam_auth    = "DISABLED"
  }
}

resource "aws_db_proxy_default_target_group" "main" {
  db_proxy_name = aws_db_proxy.main.name

  connection_pool_config {
    max_connections_percent      = 100
    max_idle_connections_percent = 20
    connection_borrow_timeout    = 20
  }
}

resource "aws_db_proxy_target" "main" {
  db_proxy_name          = aws_db_proxy.main.name
  target_group_name      = aws_db_proxy_default_target_group.main.name
  db_instance_identifier = aws_db_instance.main.identifier
}
