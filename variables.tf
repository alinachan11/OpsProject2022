terraform {
  required_version = ">= 0.13.5"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "aws_account_id" {
  type = string
  default = ""
}

variable "slack_token" {
  type = string
  default = "xxxx/yyyy/zzzz"
}

variable "private_zone_name" {
  type = string
  default = "alinaops.com"
}