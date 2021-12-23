

locals {
  server-userdata = <<USERDATA
#!/bin/bash 

echo "inside the user data"
yes | apt-get install python3-distutils

yes |  apt-get install python3-apt

apt update
apt install software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
yes | apt install ansible 

yes | apt install python-boto3

chmod 600 /home/ubuntu/${local_file.ansible_key.filename}
mv /home/ubuntu/${local_file.ansible_key.filename} /home/ubuntu/.ssh/

cd /home/ubuntu/Ansible-Part
sleep 30s
ansible-playbook main_pb.yml

echo "end of user data - server"
USERDATA

client-userdata = <<USERDATA
#!/bin/bash 
chmod 600 /home/ubuntu/${local_file.ansible_key.filename}
mv /home/ubuntu/${local_file.ansible_key.filename} /home/ubuntu/.ssh/

echo "end of user data - client"
USERDATA

}

