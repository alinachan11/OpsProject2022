resource "aws_security_group" "ssh-sg" {
 name        = "ssh-sg"
 description = "security group for ssh"
 vpc_id      = module.vpc_module.vpc_id
  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
  ingress {
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all inside security group"
  }
}
resource "aws_security_group" "nginx-sg" {
 name        = "nginx-sg"
 description = "security group for nginx"
 vpc_id      = module.vpc_module.vpc_id
  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
  ingress {
   from_port   = 80
   to_port     = 80
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all inside security group"
  }
}

resource "aws_security_group" "consul-sg" {
 name        = "consul-sg"
 description = "security group for consul"
 vpc_id      = module.vpc_module.vpc_id
  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
  ingress {
   from_port   = 8500
   to_port     = 8500
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all inside security group"
  }
}

resource "aws_security_group" "jenkins-accesss-sg" {
 name        = "jenkins-access-sg"
 description = "security group for jenkins"
 vpc_id      = module.vpc_module.vpc_id
  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
  ingress {
   from_port   = 8080
   to_port     = 8080
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all inside security group"
  }
}

resource "aws_security_group" "https-sg" {
 name        = "https-sg"
 description = "security group for https"
 vpc_id      = module.vpc_module.vpc_id
  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
  ingress {
   from_port   = 443
   to_port     = 443
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all inside security group"
  }
}

resource "aws_security_group" "prom-sg" {
 name        = "prom-sg"
 description = "security group for prometheus"
 vpc_id      = module.vpc_module.vpc_id
  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
  ingress {
   from_port   = 9100
   to_port     = 9100
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all inside security group"
  }
}

resource "aws_security_group" "elk-sg" {
 name        = "elk-sg"
 description = "security group for elk"
 vpc_id      = module.vpc_module.vpc_id
  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
  ingress {
   from_port   = 9200
   to_port     = 9200
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

   ingress {
   from_port   = 5044
   to_port     = 5044
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

    ingress {
   from_port   = 9300
   to_port     = 9300
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

    ingress {
   from_port   = 5601
   to_port     = 5601
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all inside security group"
  }
}

resource "aws_security_group" "default" {
  name        = "my-project-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = module.vpc_module.vpc_id
  depends_on  = [module.vpc_module]
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }
  
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
  tags = {
    purpose = "checking if this default sg is better"
  }
}

resource "aws_security_group" "common-sg" {
 name        = "common-sg"
 description = "security group for consul + prometheus + default"
 vpc_id      = module.vpc_module.vpc_id
  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
  ingress {
   from_port   = 8500
   to_port     = 8500
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

  ingress {
   from_port   = 8600
   to_port     = 8600
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

   ingress {
   from_port   = 9100
   to_port     = 9100
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
 ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all inside security group"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = module.vpc_module.vpc_id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}