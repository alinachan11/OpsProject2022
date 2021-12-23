output "ansible_server_public_address" {
    value = aws_instance.ansible_server.*.public_ip
}

output "ubuntu_consul_servers_public_addresses" {
    value = aws_instance.consul_servers.*.public_ip
}
output "ubuntu_consul_servers_private_addresses" {
    value = aws_instance.consul_servers.*.private_ip
}

output "ubuntu_ansible_nodes_public_addresses" {
    value = aws_instance.ubuntu_nodes.*.public_ip
}
output "ubuntu_ansible_nodes_private_addresses" {
    value = aws_instance.ubuntu_nodes.*.private_ip
}


