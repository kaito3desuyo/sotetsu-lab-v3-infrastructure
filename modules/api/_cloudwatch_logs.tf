resource "aws_cloudwatch_log_group" "for_ecs" {
  name = local.cloudwatch_log_group_name

  tags = merge(
    local.module_tags,
    {
      "Name" = local.cloudwatch_log_group_tag_name
    }
  )
}
