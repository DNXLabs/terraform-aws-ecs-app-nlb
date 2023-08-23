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

variable "alarm_prefix" {
  type        = string
  description = "String prefix for cloudwatch alarms. (Optional, leave blank to use iam_account_alias)"
  default     = ""
}

variable "nlb_arn" {
  default     = ""
  description = "Networking LoadBalance ARN - Required if nlb=false or nlb_internal=false"
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

variable "ordered_placement_strategy" {
  # This variable may not be used with Fargate!
  description = "Service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. The maximum number of ordered_placement_strategy blocks is 5."
  type = list(object({
    field      = string
    expression = string
  }))
  default = []
}

variable "placement_constraints" {
  # This variables may not be used with Fargate!
  description = "Rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10."
  type = list(object({
    type       = string
    expression = string
  }))
  default = []
}

variable "launch_type" {
  default     = "EC2"
  description = "The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2."
}

variable "fargate_spot" {
  default     = false
  description = "Set true to use FARGATE_SPOT capacity provider by default (only when launch_type=FARGATE)"
}

variable "subnets" {
  default     = null
  description = "The subnets associated with the task or service. (REQUIRED IF 'LAUCH_TYPE' IS FARGATE)"
}

variable "nlb_subnets_ids" {
  default     = null
  description = "The subnets associated with the task or service. (REQUIRED IF 'LAUCH_TYPE' IS FARGATE)"
}

variable "nlb_subnets_cidr" {
  default     = null
  description = "The subnets associated with the task or service. (REQUIRED IF 'LAUCH_TYPE' IS FARGATE)"
}

variable "network_mode" {
  default     = null
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host. (REQUIRED IF 'LAUCH_TYPE' IS FARGATE)"
}

variable "security_groups" {
  default     = []
  type        = list
  description = "The security groups associated with the task or service"
}

variable "nlb_internal" {
  default     = false
  type        = bool
  description = "Creates an Internal NLB for this service"
}

variable "nlb" {
  default     = false
  type        = bool
  description = "Flag to create the NLB"
}

variable "assign_public_ip" {
  default     = false
  type        = bool
  description = "Configures ECS Service to assign public IP (Fargate Only)"
}

variable "cloudwatch_logs_retention" {
  default     = 120
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653."
}

variable "cloudwatch_logs_export" {
  default     = false
  description = "Whether to mark the log group to export to an S3 bucket (needs terraform-aws-log-exporter to be deployed in the account/region)"
}

variable "security_group_inbound_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "ECS Nodes inbound allowed CIDRs for the security group."
}