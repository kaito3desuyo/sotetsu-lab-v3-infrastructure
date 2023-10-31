locals {
  secrets_manager_name = "${local.prefix}-rds-secrets"
}

resource "aws_secretsmanager_secret" "main" {
  name        = local.secrets_manager_name
  description = "Secrets for Database RDS"

  tags = merge(
    local.module_tags,
    {
      "Name" = local.secrets_manager_name
    }
  )
}

resource "aws_secretsmanager_secret_version" "main" {
  secret_id = aws_secretsmanager_secret.main.id
  secret_string = jsonencode(
    {
      engine   = aws_db_instance.main.engine
      host     = aws_db_instance.main.address
      port     = aws_db_instance.main.port
      username = aws_db_instance.main.username
      password = aws_db_instance.main.password
    }
  )

  lifecycle {
    ignore_changes = [secret_string, version_stages]
  }
}
