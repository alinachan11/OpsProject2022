output "bastion_host_public_address" {
    value = aws_instance.bastion_server.public_ip
}

output "ansible_server_public_address" {
    value = aws_instance.ansible_server.*.public_ip
}

output "jenkins_lb_address" {
    value = module.jenkins_module.jenkins_lb_dns
}

output "consul_lb_address" {
    value = module.sd_module.consul_lb_dns
}

output "elk_lb_address" {
    value = aws_lb.elk_alb.dns_name
}
output "jenkins_nodes_pip_address" {
    value = module.jenkins_module.jenkins_nodes_private_addresses
}




################# EKS Output ###########################

output "cluster_name" {
    value = module.EKS_Module.cluster_name
}
output "config_map_aws_auth" {
    value = module.EKS_Module.config_map_aws_auth
}
output "oidc_provider_arn" {
    value = module.EKS_Module.oidc_provider_arn
}
output "cluster_security_group_id" {
    value = module.EKS_Module.cluster_security_group_id
}
output "cluster_endpoint" {
    value = module.EKS_Module.cluster_endpoint
}
output "cluster_id" {
    value = module.EKS_Module.cluster_id
}
output "cluster_region" {
    value = module.EKS_Module.region
}
output "kubeconfig" {
    value = module.EKS_Module.kubeconfig
}

##################### Extra output ##############################

output "kandula_role_id" {
    value = aws_iam_role.kandula_role.id
}

output "kandula_role_name" {
    value = aws_iam_role.kandula_role.name
}

output "kandula_role_arn" {
    value = aws_iam_role.kandula_role.arn
}

output "kandula_role_unique_id" {
    value = aws_iam_role.kandula_role.unique_id
}