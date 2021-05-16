output "api_ec2_asg_arn" {
  value = aws_autoscaling_group.for_api_ec2.arn
}

output "api_ec2_security_group_id" {
  value = aws_security_group.for_api_ec2.id
}

output "api_alb_tg_arn" {
  value = aws_lb_target_group.for_api_green.arn
}
