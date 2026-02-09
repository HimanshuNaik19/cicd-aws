#!/bin/bash

# Cleanup AWS resources
# Usage: ./cleanup.sh

set -e

echo "🧹 Cleaning up AWS resources..."

# Delete Kubernetes resources
echo "Deleting Kubernetes deployments..."
kubectl delete -f kubernetes/deployments/ --all-namespaces --ignore-not-found=true
kubectl delete -f kubernetes/services/ --all-namespaces --ignore-not-found=true
kubectl delete -f kubernetes/configmaps/ --all-namespaces --ignore-not-found=true
kubectl delete -f kubernetes/hpa/ --all-namespaces --ignore-not-found=true

# Destroy Terraform infrastructure
echo "Destroying Terraform infrastructure..."
cd terraform/environments/dev
terraform destroy -auto-approve
cd ../../..

echo "✅ Cleanup completed!"
