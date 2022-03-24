


module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.16.0"

  instance_count              = var.instance_count
  name                        = "${var.prefix_name}-elk"
  instance_type               = "t3.medium"
  ami                         = data.aws_ami.ami.id
  key_name                    = var.ssh_key_name
  subnet_id                   = tolist(module.vpc_module.private_subnets_id)[1]
  vpc_security_group_ids      = [aws_security_group.elk-sg.id,aws_security_group.ssh-sg.id,aws_security_group.default.id,aws_security_group.consul-sg.id]
  associate_public_ip_address = false
  user_data = file("./loguserdata.sh")

  tags = {
    Terraform   = "true"
    task = "elk"
    node_type = "ubuntu"
    consul_server = "false"
    consul_type ="client"
    task2 = "node_exporter"
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

#output "public_ip" {
#  value = module.ec2-instance.public_ip[0]
#}
#output "kibana_url" {
 # value = "http://${module.ec2-instance.public_ip[0]}:5601"
#}

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


###########################################################################

resource "aws_lb" "elk_alb" {
  name               = "elk-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            =  module.vpc_module.public_subnets_id
  security_groups    = [aws_security_group.elk-sg.id,aws_security_group.ssh-sg.id,aws_security_group.default.id,aws_security_group.consul-sg.id]

  tags = {
    "Name" = "elk-alb-${module.vpc_module.vpc_id}"
  }
}


resource "aws_lb_listener" "elk" {
  load_balancer_arn = aws_lb.elk_alb.arn
  port              = 5601
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elk.arn
  }
}

resource "aws_lb_target_group" "elk" {
  name     = "elk-target-group"
  port     = 5601
  protocol = "HTTP"
  vpc_id   = module.vpc_module.vpc_id

  health_check {
    enabled = true
    path    = "/"
  }

  tags = {
    "Name" = "elk_target_group_${module.vpc_module.vpc_id}"
  }
}

resource "aws_lb_target_group_attachment" "elk" {
  target_group_arn = aws_lb_target_group.elk.id
  target_id        = module.ec2-instance.id[0]
  port             = 5601
}
