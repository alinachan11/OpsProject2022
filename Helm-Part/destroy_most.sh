#!/bin/bash
set -e

echo "starting destruction of deployments...."
aws eks --region=us-east-1 update-kubeconfig --name opsschool-eks-alina--final-project

echo "starting destruction of filebeat...."
kubectl -f delete /home/ubuntu/Ansible-Part/deployments/filebeat.yml

echo "starting destruction of consul...."
helm delete myconsul -n consul

echo "starting destruction of prometheus...."
helm delete myprom -n monitoring

echo "starting destruction of grafana...."
helm delete mygrafana -n monitoring

echo "end of destruction of deployments...."
