variable "aws_region" {
  description = "Default region for reminder app"
  type        = string
  default     = "eu-west-1"
}

variable "api_key_secret" {
  description = "API key string to validate requests"
  type        = string
  sensitive   = true
}

variable "cloudwatch_schedule" {
  description = "Cron schedule for cloudwatch table scan job"
  type = string
  default = "cron(0 8 * * ? *)"
}

variable "sender_mail" {
  description = "Address used to send mail notification from"
  type = string
  sensitive = true
}