resource "aws_instance" "consul_servers" {
  count = var.consul_servers_count

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  associate_public_ip_address = true

  subnet_id = var.subnet_id

  vpc_security_group_ids = [aws_security_group.ansible-sg.id]
  key_name               = aws_key_pair.ansible_key.key_name
  iam_instance_profile   = aws_iam_instance_profile.consul-join.name
  user_data = local.ansible-client-userdata
  tags = {
    Name = "Consul-Server-${count.index+1}"
    task = "ans-node"
    node_type = "ubuntu"
    consul_server = "true"
    consul_type ="server"

  }
  provisioner "file" {
    source      = "${local_file.ansible_key.filename}"
    destination = "/home/ubuntu/${local_file.ansible_key.filename}"
    connection {   
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(local_file.ansible_key.filename)      
    }   
  }
}