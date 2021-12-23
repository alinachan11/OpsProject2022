terraform {
  required_version = ">= 0.13.5"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "AWS VPC id"
  default     = "vpc-0e9e3e546ce4e72b4"
}

variable "subnet_id" {
  description = "Ansible Subnet id"
  default     = "subnet-022b1ea949f3ac56f"
}

variable "ingress_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [22,8080,443, 8500]
}

variable "consul_types" {
  type        = list(string)
  description = "list of consul types"
  default     = ["server","client"]
}

variable "ubuntu_nodes_count" {
  default = 1
}

variable "consul_servers_count" {
  default = 3
}
  