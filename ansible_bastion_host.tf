resource "aws_instance" "ansible_server" {
  count = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = module.vpc_module.public_subnets_id[0]
  vpc_security_group_ids = [aws_security_group.ssh-sg.id, aws_default_security_group.default.id]
  key_name               = aws_key_pair.ansible_key.key_name
  iam_instance_profile = "${aws_iam_instance_profile.assume_role_profile.name}"
  user_data = local.ansible-server-userdata
  tags = {
    Name = "Server"
    task = "ans-control"
    puropse = "ansible and bastion host"
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

    provisioner "file" {
    content     = tostring(module.EKS_Module.config_map_aws_auth[0].data["data"]["mapRoles"])
    destination = "/tmp/kubeconfig_opsSchool-eks"
     connection {   
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(local_file.ansible_key.filename)      
    }  
  }
  provisioner "file" {
    source      = "Ansible-Part"
    destination = "/home/ubuntu/"
    connection {   
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(local_file.ansible_key.filename)      
    }   
  }
}