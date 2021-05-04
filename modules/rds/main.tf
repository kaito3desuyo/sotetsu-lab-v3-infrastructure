resource "aws_db_subnet_group" "for_main_rds" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    "Name" = "${var.name}-db-subnet-group"
  }
}

resource "aws_security_group" "for_main_rds" {
  name   = "${var.name}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.ingress_sg_ids
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-rds-sg"
  }
}

resource "aws_db_instance" "for_main" {
  engine                          = "postgres"
  engine_version                  = "12.5"
  identifier                      = var.name
  username                        = var.main_db_username
  password                        = var.main_db_password
  instance_class                  = "db.t2.micro"
  storage_type                    = "gp2"
  storage_encrypted               = false
  allocated_storage               = 20
  max_allocated_storage           = 1000
  availability_zone               = "ap-northeast-1a"
  multi_az                        = false
  db_subnet_group_name            = aws_db_subnet_group.for_main_rds.name
  vpc_security_group_ids          = [aws_security_group.for_main_rds.id]
  apply_immediately               = true
  auto_minor_version_upgrade      = true
  deletion_protection             = true
  monitoring_interval             = 60
  performance_insights_enabled    = true
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  backup_retention_period         = 7
  backup_window                   = "17:00-18:00"
  copy_tags_to_snapshot           = true
  skip_final_snapshot             = false
  final_snapshot_identifier       = "${var.name}-main-rds-final-snapshot"

  tags = {
    "Name" = "${var.name}-main-rds"
  }
}
