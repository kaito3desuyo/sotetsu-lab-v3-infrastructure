# resource "aws_lb" "for_api" {
#   name               = "${var.name}-api"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.for_api_alb.id]
#   subnets            = var.public_subnet_ids

#   tags = {
#     Name = "${var.name}-api"
#   }
# }

# resource "aws_lb_listener" "for_api_production" {
#   load_balancer_arn = aws_lb.for_api.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   certificate_arn   = var.acm_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.for_api_blue.arn
#   }

#   lifecycle {
#     ignore_changes = [default_action]
#   }
# }


# resource "aws_lb_listener" "for_api_test" {
#   load_balancer_arn = aws_lb.for_api.arn
#   port              = "8080"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.for_api_green.arn
#   }

#   lifecycle {
#     ignore_changes = [default_action]
#   }
# }

# resource "aws_lb_target_group" "for_api_blue" {
#   name        = "${var.name}-api-alb-tg-blue"
#   port        = 3000
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "ip"

#   health_check {
#     path = "/health-check"
#   }

#   tags = {
#     Name = "${var.name}-api-alb-tg-blue"
#   }
# }

# resource "aws_lb_target_group" "for_api_green" {
#   name        = "${var.name}-api-alb-tg-green"
#   port        = 3000
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "ip"

#   health_check {
#     path = "/health-check"
#   }

#   tags = {
#     Name = "${var.name}-api-alb-tg-green"
#   }
# }
