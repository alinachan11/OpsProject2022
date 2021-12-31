output "ansible_server_public_address" {
    value = aws_instance.ansible_server.*.public_ip
}

output "jenkins_lb_address" {
    value = module.jenkins_module.jenkins_lb_dns
}

output "consul_lb_address" {
    value = module.sd_module.consul_lb_dns
}

output "password1" {
  sensitive = true
  value =tls_private_key.ansible_key.private_key_pem
}


