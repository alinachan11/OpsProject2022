


module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.16.0"

  instance_count              = var.instance_count
  name                        = "${var.prefix_name}-elk"
  instance_type               = "t3.medium"
  ami                         = data.aws_ami.ami.id
  key_name                    = var.ssh_key_name
  subnet_id                   = tolist(module.vpc_module.public_subnets_id)[1]
  vpc_security_group_ids      = [module.security-group.this_security_group_id]
  associate_public_ip_address = true
  user_data = file("./scrips/logsuserdata.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

################################################################################################
# get latest ubuntu 18 ami
data "aws_ami" "ami" {
  owners      = ["099720109477"] # canonical
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
# get my external ip
data "http" "myip" {
  url = "http://ifconfig.me"
}

# ---------------------------------------------------------------------------------------------------------------------
# security group
# ---------------------------------------------------------------------------------------------------------------------
module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.17.0"

  name   = "${var.prefix_name}-elk"
  vpc_id = module.vpc_module.vpc_id

  ingress_cidr_blocks = ["${data.http.myip.body}/32"]
  ingress_rules = [
    "elasticsearch-rest-tcp",
    "elasticsearch-java-tcp",
    "kibana-tcp",
    "logstash-tcp",
    "ssh-tcp"
  ]
  ingress_with_self = [{ rule = "all-all" }]
  egress_rules      = ["all-all"]

}

##################################################################

output "public_ip" {
  value = module.ec2-instance.public_ip[0]
}
output "kibana_url" {
  value = "http://${module.ec2-instance.public_ip[0]}:5601"
}

######################################################################

variable "ssh_key_name" {
  type = string
  default = "ansible_key"
}
variable "prefix_name" {
  type = string
  default = "alina_project"
}
variable "instance_count" {
  type    = number
  default = 1
}