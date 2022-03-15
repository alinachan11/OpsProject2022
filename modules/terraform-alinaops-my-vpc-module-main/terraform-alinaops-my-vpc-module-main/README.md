# VPC Module

A small vpc module, creates a vpc, public_subnets and private subnets

![](https://miro.medium.com/max/2570/1*YcNHxdrbPlV-lWjN_0Ek3g.png)

# Input:
The module accepts the following inputs:
1) vpc_cidr_block
2) private_subnets_cidr_list
3) public_subnets_cidr_list


# Output:
The module generates the following outputs:
1) public_subnets_id
2) private_subnets_id
3) vpc_id
4) vpc_cidr
