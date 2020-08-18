variable "name" {
  description = "Name of your ECS service"
}

variable "memory" {
  default     = "512"
  description = "Hard memory of the container"
}

variable "cpu" {
  default     = "0"
  description = "Hard limit for CPU for the container"
}

variable "cluster_name" {
  default = "Name of existing ECS Cluster to deploy this app to"
}

variable "service_role_arn" {
  description = "Existing service role ARN created by ECS cluster module"
}

variable "task_role_arn" {
  description = "Existing task role ARN created by ECS cluster module"
}

variable "image" {
  description = "Docker image to deploy (can be a placeholder)"
  default     = "dnxsolutions/nginx-hello:latest"
}

variable "vpc_id" {
  description = "VPC ID to deploy this app to"
}

variable "alarm_sns_topics" {
  default     = []
  description = "Alarm topics to create and alert on ECS service metrics"
}
variable "nlb_arn" {
  description = "Networking LoadBalance ARN"
}
variable "port" {
  default     = "80"
  description = "Port for target group to listen"
}
variable "container_port" {
  default     = "8080"
  description = "Port your container listens (used in the placeholder task definition)"
}
variable "hostname_create" {
  default     = "true"
  description = "Optional parameter to create or not a Route53 record"
}
variable "hosted_zone" {
  default     = ""
  description = "Hosted Zone to create DNS record for this app"
}
variable "hostname" {
  default     = ""
  description = "Hostname to create DNS record for this app"
}
variable "autoscaling_cpu" {
  default     = false
  description = "Enables autoscaling based on average CPU tracking"
}

variable "autoscaling_max" {
  default     = 4
  description = "Max number of containers to scale with autoscaling"
}

variable "autoscaling_min" {
  default     = 1
  description = "Min number of containers to scale with autoscaling"
}

variable "autoscaling_target_cpu" {
  default     = 50
  description = "Target average CPU percentage to track for autoscaling"
}

variable "autoscaling_scale_in_cooldown" {
  default     = 300
  description = "Cooldown in seconds to wait between scale in events"
}

variable "autoscaling_scale_out_cooldown" {
  default     = 300
  description = "Cooldown in seconds to wait between scale out events"
}
variable "service_health_check_grace_period_seconds" {
  default     = 0
  description = "Time until your container starts serving requests"
}