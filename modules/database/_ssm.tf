locals {
  rds_proxy_host_param_name = "${local.prefix}-rds-proxy-host-param"
}

resource "aws_ssm_parameter" "rds_proxy_host" {
  name  = local.rds_proxy_host_param_name
  type  = "String"
  value = aws_db_proxy.main.endpoint

  tags = merge(
    local.module_tags,
    {
      "Name" = local.rds_proxy_host_param_name
    }
  )
}
