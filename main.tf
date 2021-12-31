module "vpc_module" {
  source                    = "app.terraform.io/alina-ops/my-vpc-no-public/alinaops"
  version = "1.0.1-alpha"
  vpc_cidr_block            = "10.0.0.0/16"
  private_subnets_cidr_list = ["10.0.2.0/24", "10.0.3.0/24"]
  public_subnets_cidr_list  = ["10.0.102.0/24", "10.0.103.0/24"]
}

module "jenkins_module" {
  source                    = "app.terraform.io/alina-ops/Jenkins-Module/alinaops"
  version = "1.0.0"
  vpc_id = module.vpc_module.vpc_id
  subnets_id_private = module.vpc_module.private_subnets_id
  subnets_id_public = module.vpc_module.public_subnets_id
  nodes_count = length(module.vpc_module.private_subnets_id)
  bh_public_ip = aws_instance.ansible_server[0].public_ip
  security_groups = [aws_security_group.ssh-sg.id,aws_security_group.consul-sg.id,aws_security_group.jenkins-accesss-sg.id,aws_security_group.https-sg.id]
}


module "sd_module" {
  source                    = "app.terraform.io/alina-ops/SD-Module/alinaops"
  version = "1.0.0"
  vpc_id = module.vpc_module.vpc_id
  subnets_id_private = module.vpc_module.private_subnets_id
  subnets_id_public = module.vpc_module.public_subnets_id
  consul_servers_count = 3
  bh_public_ip = aws_instance.ansible_server[0].public_ip
  for_testing_ip = true
  security_groups = [aws_security_group.ssh-sg.id,aws_security_group.consul-sg.id]
}