resource "aws_key_pair" "keypair" {
  key_name   = "${var.name}-key"
  public_key = file("${path.root}/ssh/${var.name}.pub")
}

resource "aws_launch_template" "for_api_ec2" {
  name                   = "${var.name}-api-ec2-launch-setting"
  update_default_version = true
  image_id               = "ami-0f4146903324aaa5b"
  instance_type          = "t3.nano"
  key_name               = aws_key_pair.keypair.id
  ebs_optimized          = true
  user_data = base64encode(
    templatefile("${path.module}/assets/launch-template-user-data.tpl.sh", {
      cluster_name = "${var.name}-api-ecs-cluster"
    })
  )

  iam_instance_profile {
    name = "ecsInstanceRole"
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.for_api_ec2.id]
  }

  monitoring {
    enabled = true
  }
}

resource "aws_autoscaling_group" "for_api_ec2" {
  name                  = "${var.name}-api-asg"
  min_size              = 1
  max_size              = 100
  desired_capacity      = 1
  vpc_zone_identifier   = var.subnet_ids
  protect_from_scale_in = true

  launch_template {
    id      = aws_launch_template.for_api_ec2.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-api"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}
