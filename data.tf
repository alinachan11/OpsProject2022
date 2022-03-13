provider "aws" {
    region = var.aws_region
    #profile = "alina"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "filebeat_deployment" {
  template = file("files/filebeat_deployment.yml")
  vars = {
    ELK_IP             = module.ec2-instance.public_ip[0]
    TODAY_DATE         = local.today
  }
}
locals {
  current_time           = timestamp()
  today                  = formatdate("YYYY-MM-DD", local.current_time)
}
