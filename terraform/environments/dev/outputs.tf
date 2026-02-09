# VPC Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

# EKS Outputs
output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = module.eks.cluster_security_group_id
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}

# RDS Outputs
output "db_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.db_instance_endpoint
}

output "db_address" {
  description = "RDS address"
  value       = module.rds.db_instance_address
}

output "db_port" {
  description = "RDS port"
  value       = module.rds.db_instance_port
}

# ECR Outputs
output "backend_ecr_repository_url" {
  description = "Backend ECR repository URL"
  value       = aws_ecr_repository.backend.repository_url
}

output "frontend_ecr_repository_url" {
  description = "Frontend ECR repository URL"
  value       = aws_ecr_repository.frontend.repository_url
}

# IAM Outputs
output "ebs_csi_role_arn" {
  description = "EBS CSI driver IAM role ARN"
  value       = module.iam.ebs_csi_role_arn
}

output "app_role_arn" {
  description = "Application IAM role ARN"
  value       = module.iam.app_role_arn
}

output "cluster_autoscaler_role_arn" {
  description = "Cluster autoscaler IAM role ARN"
  value       = module.iam.cluster_autoscaler_role_arn
}

# S3 Outputs
output "app_assets_bucket" {
  description = "S3 bucket for application assets"
  value       = aws_s3_bucket.app_assets.id
}
