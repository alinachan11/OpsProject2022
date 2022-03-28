

locals {
  ansible-server-userdata = <<USERDATA
#!/bin/bash 

echo "inside the user data"
yes | apt-get install python3-distutils
echo "1"
yes |  apt-get install python3-apt
echo "2"
apt update
echo "3"
apt install software-properties-common
echo "4"
yes | sudo apt install python3-pip
echo "5"
yes | pip3 install ansible openshift pyyaml kubernetes 
echo "6"
yes | pip3 install boto3
echo "7"
yes | apt-get install zip
echo "8"
ansible-galaxy collection install kubernetes.core
echo "9"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
echo "10"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
echo "11"
sleep 10s
aws eks --region=us-east-1 update-kubeconfig --name opsschool-eks-alina--final-project
ROLE="    - rolearn: ${aws_iam_role.ansible_role.arn}      username: build\n      groups:\n        - system:masters"
kubectl get -n kube-system configmap/aws-auth -o yaml | awk "/mapRoles: \|/{print;print \"$ROLE\";next}1" > /tmp/aws-auth-patch.yml
kubectl patch configmap/aws-auth -n kube-system --patch "$(cat /tmp/aws-auth-patch.yml)"
echo "12"

chmod 600 /home/ubuntu/${local_file.ansible_key.filename}
mv /home/ubuntu/${local_file.ansible_key.filename} /home/ubuntu/.ssh/
echo "13"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
echo "14"
ansible-galaxy collection install kubernetes.core
echo "15"
cd /home/ubuntu/Ansible-Part
sleep 30s
ansible-playbook main_pb.yml
ansible-playbook jenkins_nodes_pb.yml
ansible-playbook node_exporter_pb.yml
ansible-playbook k8s_pb.yml

cd /home/ubuntu
chmod +x /home/ubuntu/Helm-Part/destroy_most.sh
chmod +x /home/ubuntu/Helm-Part/alias_for_k8s.sh




echo "end of user data - ansible server"
USERDATA

bastion-host-userdata = <<USERDATA
#!/bin/bash 

apt update
yes | apt-get install zip

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

aws s3 cp /home/ubuntu/${local_file.ansible_key.filename} s3://alina-bucket-for-opsproject

chmod 600 /home/ubuntu/${local_file.ansible_key.filename}
mv /home/ubuntu/${local_file.ansible_key.filename} /home/ubuntu/.ssh/


echo "end of user data - bastion host"
USERDATA


}

