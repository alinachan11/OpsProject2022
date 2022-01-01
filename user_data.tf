

locals {
  ansible-server-userdata = <<USERDATA
#!/bin/bash 

echo "inside the user data"
yes | apt-get install python3-distutils

yes |  apt-get install python3-apt

apt update
apt install software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
yes | apt install ansible 

yes | apt install python-boto3

yes | apt-get install zip

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

aws s3 cp /home/ubuntu/${local_file.ansible_key.filename} s3://alina-bucket-for-opsproject

chmod 600 /home/ubuntu/${local_file.ansible_key.filename}
mv /home/ubuntu/${local_file.ansible_key.filename} /home/ubuntu/.ssh/

cd /home/ubuntu/Ansible-Part
sleep 30s
ansible-playbook main_pb.yml

echo "end of user data - server"
USERDATA

ansible-client-userdata = <<USERDATA
#!/bin/bash 
chmod 600 /home/ubuntu/${local_file.ansible_key.filename}
mv /home/ubuntu/${local_file.ansible_key.filename} /home/ubuntu/.ssh/

echo "end of user data - client"
USERDATA

}

