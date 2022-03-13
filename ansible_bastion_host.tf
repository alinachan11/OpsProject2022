resource "aws_instance" "ansible_server" {
  count = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = module.vpc_module.private_subnets_id[0]
  vpc_security_group_ids = [aws_security_group.ssh-sg.id, aws_default_security_group.default.id]
  key_name               = aws_key_pair.ansible_key.key_name
  iam_instance_profile = "${aws_iam_instance_profile.assume_role_profile.name}"
  user_data = local.ansible-server-userdata
  tags = {
    Name = "Ansible_Server"
    task = "ans-control"
    puropse = "ansible"
  }
  provisioner "file" {
    source      = "${local_file.ansible_key.filename}"
    destination = "/home/ubuntu/${local_file.ansible_key.filename}"
    connection {   
      type        = "ssh" 
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(local_file.ansible_key.filename) 

      bastion_host = aws_instance.bastion_server.public_ip
      bastion_user = "ubuntu"
      bastion_private_key =  file(local_file.ansible_key.filename)          
    }
  }
    provisioner "file" {
    source      = "files"
    destination = "/home/ubuntu/"
    connection {   
      type        = "ssh" 
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(local_file.ansible_key.filename) 

      bastion_host = aws_instance.bastion_server.public_ip
      bastion_user = "ubuntu"
      bastion_private_key =  file(local_file.ansible_key.filename)          
    }   
  }

    provisioner "file" {
    content     = module.EKS_Module.kubeconfig
    #module.EKS_Module.config_map_aws_auth["value"]
    
    destination = "/tmp/kubeconfig_opsSchool-eks"
     connection {   
      type        = "ssh" 
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(local_file.ansible_key.filename)

      bastion_host = aws_instance.bastion_server.public_ip
      bastion_user = "ubuntu"
      bastion_private_key =  file(local_file.ansible_key.filename)           
    }  
  }

  provisioner "file" {
    content     = "${data.template_file.configs_for_ansible.rendered}"
    destination = "/home/ubuntu/configs_for_ansible.ini"
     connection {   
      type        = "ssh" 
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(local_file.ansible_key.filename)

      bastion_host = aws_instance.bastion_server.public_ip
      bastion_user = "ubuntu"
      bastion_private_key =  file(local_file.ansible_key.filename)           
    }  
  }
  provisioner "file" {
    source      = "Ansible-Part"
    destination = "/home/ubuntu/"
    connection {   
      type        = "ssh" 
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(local_file.ansible_key.filename) 

      bastion_host = aws_instance.bastion_server.public_ip
      bastion_user = "ubuntu"
      bastion_private_key =  file(local_file.ansible_key.filename)     
    }   
  }

  provisioner "file" {
    source      = "Helm-Part"
    destination = "/home/ubuntu/"
    connection {   
      type        = "ssh" 
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(local_file.ansible_key.filename) 

      bastion_host = aws_instance.bastion_server.public_ip
      bastion_user = "ubuntu"
      bastion_private_key =  file(local_file.ansible_key.filename)     
    }   
  }
}

################### BASTION ##########################################################################

resource "aws_instance" "bastion_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = module.vpc_module.public_subnets_id[0]
  vpc_security_group_ids = [aws_security_group.ssh-sg.id, aws_default_security_group.default.id]
  key_name               = aws_key_pair.ansible_key.key_name
  iam_instance_profile = "${aws_iam_instance_profile.bucket_access.name}"
  user_data = local.bastion-host-userdata
  tags = {
    Name = "bastion_host"
    task = "bastion"
    puropse = "bastion host"
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

#resource "null_resource" "host_file" {
#  triggers = {
#    template_rendered = data.template_file.dev_hosts.rendered
#  }
#  provisioner "local-exec" {
#    command = "echo \"${data.template_file.dev_hosts.rendered}\" > hosts.INI"
#  }
#}