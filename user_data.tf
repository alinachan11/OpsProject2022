

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

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
sleep 10s
aws eks --region=us-east-1 update-kubeconfig --name opsschool-eks-alina--final-project
ROLE="    - rolearn: ${aws_iam_role.ansible_role.arn}      username: build\n      groups:\n        - system:masters"
kubectl get -n kube-system configmap/aws-auth -o yaml | awk "/mapRoles: \|/{print;print \"$ROLE\";next}1" > /tmp/aws-auth-patch.yml
kubectl patch configmap/aws-auth -n kube-system --patch "$(cat /tmp/aws-auth-patch.yml)"


aws s3 cp /home/ubuntu/${local_file.ansible_key.filename} s3://alina-bucket-for-opsproject

chmod 600 /home/ubuntu/${local_file.ansible_key.filename}
mv /home/ubuntu/${local_file.ansible_key.filename} /home/ubuntu/.ssh/

cd /home/ubuntu/Ansible-Part
sleep 30s
ansible-playbook main_pb.yml
ansible-playbook jenkins_nodes_pb.yml

echo "end of user data - server"
USERDATA

ansible-client-userdata = <<USERDATA
#!/bin/bash 
chmod 600 /home/ubuntu/${local_file.ansible_key.filename}
mv /home/ubuntu/${local_file.ansible_key.filename} /home/ubuntu/.ssh/

echo "end of user data - client"
USERDATA

}

