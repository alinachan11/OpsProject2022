# OpsProject2022
ops school project using: ansible, terraform, aws, consul, jenkins, eks(k8s) and kandula(python).
![](https://cdn2.iconfinder.com/data/icons/coding-7/100/coding-workstation-5-coding-developer-web-html-programmer-software-coder-laptop-workstation-female-512.png)

# Using the following modules:
VPC module: [a link](https://github.com/alinachan11/terraform-alinaops-my-vpc-module/blob/main/README.md)  <br />
Jenkins module: [a link](https://github.com/alinachan11/terraform-alinaops-Jenkins-Module/blob/main/README.md)  <br />
Consul module: [a link](https://github.com/alinachan11/terraform-alinaops-SD-Module/blob/main/README.md)  <br />
EKS module:  [a link](https://github.com/alinachan11/terraform-alinaops-my-EKS-Module/blob/main/README.md) <br />


# Using the project:
1. After making changes and pushing in the changes, terraform cloud will make a plan, we can choose to apply it or not, we can also
start a new run based on last succefull build.

2. In case we want to ssh the machines we need the ssh key which is kept inside s3 bucket - alina-bucket-for-opsproject. we can download from there.
    (I have created a user with only permissions to S3)

3. While jenkins comes with most needed things we still need to make a few changes:
    a. we need to update the ssh credensials with the new pem file content.
    b. we need to update the ip address of the 2 jenkins nodes with the new ip's(Inside the output of terraform cloud)
    c. we need to update inside of gitapp the address of Homepage and webhook with the jenkins-lb address(also inside terraform cloud output or from consul)
    
4. we can access the ansible-server to get the grafana password for admin user:
   kubectl get secret mygrafana -n monitoring -o jsonpath='{.data.admin-password}' | base64 --decode -
   
5. The addresses of all load-balancers are inside consul - so no need to get them.


# Usefull Things:
1. inside ansible-server in the folder Helm-Part we have a script which destroyes most of active k8s deployments destroy_most.sh [a link](https://github.com/alinachan11/OpsProject2022/blob/main/Helm-Part/destroy_most.sh)
