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
