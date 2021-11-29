data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["melonops*"]
  }
}

# ASG VPC Subnet ids 참조
data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  filter {
    name   = "tag:Name"
    values = ["melonops-an2p-web*"]
  }
}

# Launch Template 참조
data "aws_launch_template" "my_web" {
  name = "banana-an2d-my_web"
}

data "aws_alb" "this" {
  name = "melonops-an2p-ingress-alb"
}

module "my_asg" {
  source = "../../"

  context                    = var.context
  name                       = "my-web"
  launch_template_name       = data.aws_launch_template.my_web.name
  launch_template_version    = var.lt_version == null ? data.aws_launch_template.my_web.default_version : var.lt_version
  vpc_zone_identifier        = toset(data.aws_subnets.this.ids)
  desired_capacity           = 0
  min_size                   = 1
  max_size                   = 4
  create_service_linked_role = true
  target_group_arns          = [
    "arn:aws:elasticloadbalancing:ap-northeast-2:827519537363:targetgroup/k8s-istiosys-istioing-789ed6fb63/f0d2f1f56bc21011"
  ]

  instance_refresh = {
    strategy    = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
  }

  create_schedule = true
  schedules       = {
    night = {
      min_size         = 0
      max_size         = 0
      desired_capacity = 0
      recurrence       = "0 18 * * 1-5" # Mon-Fri in the evening
      time_zone        = "Asia/Seoul"
    }

    morning = {
      min_size         = 0
      max_size         = 1
      desired_capacity = 1
      recurrence       = "0 7 * * 1-5" # Mon-Fri in the morning
    }

    future = {
      min_size         = 0
      max_size         = 0
      desired_capacity = 0
      start_time       = "2031-12-31T10:00:00Z" # Should be in the future
      end_time         = "2032-01-01T16:00:00Z"
    }
  }
}