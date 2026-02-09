#!/bin/bash

# Deploy application to Kubernetes
# Usage: ./deploy.sh [environment] [tag]

set -e

ENVIRONMENT=${1:-production}
TAG=${2:-latest}
AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID:-"YOUR_AWS_ACCOUNT_ID"}
AWS_REGION=${AWS_REGION:-us-east-1}
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "🚀 Deploying to $ENVIRONMENT environment..."

# Update image tags in deployment files
sed -i "s|<ECR_REGISTRY>|$ECR_REGISTRY|g" kubernetes/deployments/*.yaml

# Apply Kubernetes manifests
echo "📦 Creating namespaces..."
kubectl apply -f kubernetes/namespaces/

echo "🔧 Creating ConfigMaps..."
kubectl apply -f kubernetes/configmaps/ -n $ENVIRONMENT

echo "🔐 Creating Secrets..."
kubectl apply -f kubernetes/secrets/ -n $ENVIRONMENT

echo "🚢 Deploying applications..."
kubectl apply -f kubernetes/deployments/ -n $ENVIRONMENT

echo "🌐 Creating services..."
kubectl apply -f kubernetes/services/ -n $ENVIRONMENT

echo "📊 Creating HPA..."
kubectl apply -f kubernetes/hpa/ -n $ENVIRONMENT

echo "⏳ Waiting for deployments to be ready..."
kubectl rollout status deployment/backend -n $ENVIRONMENT --timeout=5m
kubectl rollout status deployment/frontend -n $ENVIRONMENT --timeout=5m

echo "✅ Deployment completed successfully!"
echo ""
echo "📋 Deployment status:"
kubectl get pods -n $ENVIRONMENT
echo ""
echo "🌐 Services:"
kubectl get svc -n $ENVIRONMENT
