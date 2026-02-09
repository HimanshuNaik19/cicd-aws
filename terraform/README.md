# Terraform AWS Infrastructure Setup Guide

This guide explains how to set up and deploy the AWS infrastructure using Terraform.

## Prerequisites

1. **AWS CLI** configured with appropriate credentials
2. **Terraform** v1.0 or later installed
3. **kubectl** installed for Kubernetes management

## Initial Setup

### 1. Configure AWS Credentials

```bash
aws configure
```

Provide your AWS Access Key ID, Secret Access Key, and default region (us-east-1).

### 2. Create S3 Bucket for Terraform State (Optional but Recommended)

```bash
# Create S3 bucket
aws s3 mb s3://devops-terraform-state --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket devops-terraform-state \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket devops-terraform-state \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

### 3. Update Backend Configuration

After creating the S3 bucket and DynamoDB table, uncomment the backend configuration in `terraform/environments/dev/main.tf`:

```hcl
backend "s3" {
  bucket         = "devops-terraform-state"
  key            = "dev/terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "terraform-state-lock"
  encrypt        = true
}
```

## Deployment Steps

### 1. Navigate to Dev Environment

```bash
cd terraform/environments/dev
```

### 2. Initialize Terraform

```bash
terraform init
```

This will:
- Download required providers
- Initialize the backend (if configured)
- Set up the working directory

### 3. Review Variables

Edit `variables.tf` or create a `terraform.tfvars` file to customize:

```hcl
# terraform.tfvars
aws_region     = "us-east-1"
project_name   = "devops"
db_password    = "YourSecurePassword123!"  # CHANGE THIS!
```

### 4. Plan the Deployment

```bash
terraform plan
```

Review the planned changes. This will show:
- VPC with public and private subnets
- EKS cluster with node groups
- RDS PostgreSQL instance
- ECR repositories
- IAM roles for service accounts
- S3 bucket for assets

### 5. Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted. This will take approximately 15-20 minutes to complete.

## Post-Deployment Configuration

### 1. Configure kubectl

```bash
aws eks update-kubeconfig --name devops-cluster --region us-east-1
```

### 2. Verify Cluster Access

```bash
kubectl get nodes
```

You should see 2 nodes in Ready status.

### 3. Get Important Outputs

```bash
terraform output
```

Save these outputs - you'll need them for:
- ECR repository URLs (for pushing Docker images)
- RDS endpoint (for database connection)
- IAM role ARNs (for Kubernetes service accounts)

## Infrastructure Components

### VPC
- **CIDR**: 10.0.0.0/16
- **Public Subnets**: 10.0.101.0/24, 10.0.102.0/24, 10.0.103.0/24
- **Private Subnets**: 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24
- **NAT Gateways**: 3 (one per AZ)

### EKS Cluster
- **Version**: 1.28
- **Node Group**: 2-4 t3.medium instances
- **Addons**: EBS CSI, VPC CNI, CoreDNS, kube-proxy

### RDS
- **Engine**: PostgreSQL 15.4
- **Instance**: db.t3.micro
- **Storage**: 20GB (auto-scaling up to 50GB)
- **Multi-AZ**: Disabled (dev environment)

### IAM Roles
- EBS CSI Driver service account
- Application service account (S3, Secrets Manager access)
- Cluster Autoscaler service account

## Estimated Costs

**Development Environment** (running 24/7):
- EKS Control Plane: ~$73/month
- EC2 Instances (2x t3.medium): ~$60/month
- RDS (db.t3.micro): ~$15/month
- NAT Gateways: ~$100/month
- Data Transfer: ~$10/month
- **Total**: ~$258/month

**Cost Optimization Tips**:
- Stop/start RDS when not in use
- Use spot instances for node groups
- Reduce NAT Gateways to 1
- Implement auto-shutdown for non-business hours

## Cleanup

To destroy all resources:

```bash
cd terraform/environments/dev
terraform destroy
```

Type `yes` when prompted. This will remove all AWS resources.

> **Warning**: This will delete the RDS database. Make sure to backup any important data first!

## Troubleshooting

### Issue: Terraform init fails

**Solution**: Check AWS credentials and region configuration.

### Issue: EKS cluster creation fails

**Solution**: Ensure you have sufficient service quotas for EC2 instances and VPCs.

### Issue: kubectl cannot connect

**Solution**: Run the configure kubectl command again:
```bash
aws eks update-kubeconfig --name devops-cluster --region us-east-1
```

### Issue: Nodes not joining cluster

**Solution**: Check security groups and ensure private subnets have NAT gateway access.

## Next Steps

1. ✅ Infrastructure deployed
2. ⏭️ Build and push Docker images to ECR
3. ⏭️ Deploy application to Kubernetes
4. ⏭️ Set up monitoring and logging
5. ⏭️ Configure CI/CD pipeline

## Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [Terraform State Management](https://www.terraform.io/docs/language/state/index.html)
