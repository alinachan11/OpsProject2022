#!/bin/bash
set -e

echo "starting destruction of deployments...."
aws eks --region=us-east-1 update-kubeconfig --name opsschool-eks-alina--final-project

echo "starting destruction of grafana_datasources...."
kubectl delete -f /home/ubuntu/Ansible-Part/deployments/grafana_datasources.yml

echo "starting destruction of grafana_dashboards...."
kubectl delete -f /home/ubuntu/Ansible-Part/deployments/grafana_dashboards.yml

echo "starting destruction of grafana_dashboards1...."
kubectl delete -f /home/ubuntu/Ansible-Part/deployments/grafana_dashboards1.yml

echo "starting destruction of consul...."
helm delete myconsul -n consul

echo "starting destruction of prometheus...."
helm delete myprom -n monitoring

echo "starting destruction of grafana...."
helm delete mygrafana -n monitoring

echo "starting destruction of filebeat...."
kubectl delete -f /home/ubuntu/Ansible-Part/deployments/filebeat_deployment.yml

echo "starting destruction of fmetrics-server...."
kubectl delete -f /home/ubuntu/Ansible-Part/deployments/metrics-server.yaml

echo "starting destruction of hpa kandula...."
kubectl delete -f /home/ubuntu/Ansible-Part/deployments/hpa_kandula.yml

echo "end of destruction of deployments...."
