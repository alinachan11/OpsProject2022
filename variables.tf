terraform {
  required_version = ">= 0.13.5"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "keyname" {
  default = "ansible_key"
  type = string
}

variable "keypath" {
  default = "ansible_key.pem"
  type = string
}
