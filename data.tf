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

data "template_file" "configs_for_ansible" {
  template = file("configs_for_ansible.ini")
  vars = {
    ELK_IP             = module.ec2-instance.public_ip[0]
    CONSUL_IP          = module.sd_module.consul_lb_dns
  }
}

