# Getting Started Guide

This guide will help you set up and run the Multi-Tier DevOps Application locally and deploy it to AWS.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Docker** (v20.10+) and Docker Compose
- **Node.js** (v18+) and npm
- **AWS CLI** (configured with credentials)
- **kubectl** (Kubernetes CLI)
- **Terraform** (v1.0+)
- **Git**

## Local Development

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd cicd-aws
```

### 2. Start Services with Docker Compose

```bash
docker-compose up
```

This will start:
- Frontend on http://localhost:3000
- Backend API on http://localhost:5000
- PostgreSQL database on localhost:5432

### 3. Test the Application

Open your browser and navigate to http://localhost:3000. You should see the application interface where you can:
- Add new items
- View existing items
- Edit items
- Delete items

### 4. Test API Endpoints

```bash
# Health check
curl http://localhost:5000/health

# Get all items
curl http://localhost:5000/api/items

# Create an item
curl -X POST http://localhost:5000/api/items \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Item","description":"This is a test"}'
```

## AWS Deployment

### 1. Configure AWS Credentials

```bash
aws configure
```

### 2. Create ECR Repositories

```bash
aws ecr create-repository --repository-name devops-backend --region us-east-1
aws ecr create-repository --repository-name devops-frontend --region us-east-1
```

### 3. Set Up Terraform Backend

```bash
# Create S3 bucket for Terraform state
aws s3 mb s3://your-terraform-state-bucket

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

### 4. Initialize Terraform

```bash
cd terraform/environments/dev
terraform init
```

### 5. Deploy Infrastructure

```bash
# Review the plan
terraform plan

# Apply the infrastructure
terraform apply
```

### 6. Configure kubectl

```bash
aws eks update-kubeconfig --name devops-cluster --region us-east-1
```

### 7. Build and Push Docker Images

```bash
# Update AWS_ACCOUNT_ID in the script
export AWS_ACCOUNT_ID=<your-account-id>
./scripts/build-images.sh v1.0.0
```

### 8. Deploy to Kubernetes

```bash
# Update ECR registry in deployment files
./scripts/deploy.sh production v1.0.0
```

### 9. Get Application URL

```bash
kubectl get svc frontend -n production
```

Look for the `EXTERNAL-IP` of the LoadBalancer.

## Jenkins CI/CD Setup

### 1. Install Jenkins

You can run Jenkins in Kubernetes or on an EC2 instance.

### 2. Install Required Plugins

- Docker Pipeline
- Kubernetes
- AWS Steps
- SonarQube Scanner

### 3. Configure Credentials

Add the following credentials in Jenkins:
- AWS credentials
- Docker registry credentials
- Kubernetes config

### 4. Create Pipeline

- Create a new Pipeline job
- Point to `jenkins/Jenkinsfile.backend`
- Configure webhook from your Git repository

## Monitoring Setup

### 1. Deploy Prometheus

```bash
kubectl apply -f monitoring/prometheus/
```

### 2. Deploy Grafana

```bash
kubectl apply -f monitoring/grafana/
```

### 3. Access Dashboards

```bash
# Port-forward Grafana
kubectl port-forward -n monitoring svc/grafana 3000:3000
```

Access Grafana at http://localhost:3000

## Troubleshooting

### Pods not starting

```bash
kubectl get pods -n production
kubectl describe pod <pod-name> -n production
kubectl logs <pod-name> -n production
```

### Database connection issues

```bash
# Check if database is accessible
kubectl exec -it <backend-pod> -n production -- nc -zv postgres-service 5432
```

### Image pull errors

```bash
# Verify ECR login
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com
```

## Cost Optimization

To minimize costs during development:

1. Use smaller instance types for EKS nodes
2. Enable cluster autoscaler
3. Set up auto-shutdown for non-production environments
4. Use spot instances for dev/staging

## Cleanup

To destroy all resources:

```bash
./scripts/cleanup.sh
```

## Next Steps

- Set up monitoring alerts
- Configure SSL/TLS certificates
- Implement backup strategies
- Set up log aggregation
- Configure auto-scaling policies

## Support

For issues or questions, please open an issue in the repository.
