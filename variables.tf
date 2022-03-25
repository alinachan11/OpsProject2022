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

variable "private_zone_name" {
  type = string
  default = "alinaops.com"
}

variable "slack_hook" {
  type        = string
  description = "The hook address of slack."
}

variable "email_address" {
  type        = string
  description = "The email address."
}

variable "acme_server_url" {
  type        = string
  description = "The  address of acme server."
  default = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "dns_challenge_provider" {
  type        = string
  description = "the dns provider"
  default = "route53"
}








