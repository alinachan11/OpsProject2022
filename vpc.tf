module "vpc_module" {
  source                    = "app.terraform.io/alina-ops/my-vpc-no-public/alinaops"
  version = "1.0.1-alpha"
  vpc_cidr_block            = "10.0.0.0/16"
  private_subnets_cidr_list = ["10.0.2.0/24", "10.0.3.0/24"]
  public_subnets_cidr_list  = ["10.0.102.0/24", "10.0.103.0/24"]
}