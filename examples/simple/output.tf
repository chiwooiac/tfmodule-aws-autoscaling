output "autoscaling_group_id" {
  value = module.my_asg.autoscaling_group_id
}

output "autoscaling_group_name" {
  value = module.my_asg.autoscaling_group_name
}

output "autoscaling_group_arn" {
  value = module.my_asg.autoscaling_group_arn
}

output "autoscaling_group_min_size" {
  value = module.my_asg.autoscaling_group_min_size
}

output "autoscaling_group_max_size" {
  value = module.my_asg.autoscaling_group_max_size
}

output "autoscaling_group_desired_capacity" {
  value = module.my_asg.autoscaling_group_desired_capacity
}

output "service_linked_role_arn" {
  value = module.my_asg.service_linked_role_arn
}

output "autoscaling_group_default_cooldown" {
  value = module.my_asg.autoscaling_group_default_cooldown
}

output "autoscaling_group_health_check_grace_period" {
  value = module.my_asg.autoscaling_group_health_check_grace_period
}

output "autoscaling_group_health_check_type" {
  value = module.my_asg.autoscaling_group_health_check_type
}

output "autoscaling_group_availability_zones" {
  value = module.my_asg.autoscaling_group_availability_zones
}

output "autoscaling_group_vpc_zone_identifier" {
  value = module.my_asg.autoscaling_group_vpc_zone_identifier
}

output "autoscaling_group_load_balancers" {
  value = module.my_asg.autoscaling_group_load_balancers
}

output "autoscaling_group_target_group_arns" {
  value = module.my_asg.autoscaling_group_target_group_arns
}

output "autoscaling_schedule_arns" {
  value = module.my_asg.autoscaling_schedule_arns
}

