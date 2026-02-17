# Development Environment Configuration

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Uncomment after creating S3 bucket and DynamoDB table
  # backend "s3" {
  #   bucket         = "devops-terraform-state"
  #   key            = "dev/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-lock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "development"
      Project     = "multi-tier-devops"
      ManagedBy   = "terraform"
    }
  }
}

# VPC Module
module "vpc" {
  source = "../../modules/vpc"

  vpc_name        = "${var.project_name}-vpc"
  vpc_cidr        = var.vpc_cidr
  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    Environment = "development"
  }
}

# EKS Cluster Module
module "eks" {
  source = "../../modules/eks"

  cluster_name    = "${var.project_name}-cluster"
  cluster_version = var.eks_cluster_version

  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  public_subnet_ids   = module.vpc.public_subnet_ids

  node_groups = {
    general = {
      desired_size   = 2
      min_size       = 1
      max_size       = 4
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      disk_size      = 20
    }
  }

  enable_irsa                      = true
  cluster_endpoint_public_access   = true
  cluster_endpoint_private_access  = true

  tags = {
    Environment = "development"
  }

  depends_on = [module.vpc]
}

# RDS Module
module "rds" {
  source = "../../modules/rds"

  identifier      = "${var.project_name}-db"
  engine          = "postgres"
  engine_version  = "15.4"
  instance_class  = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 50

  database_name = var.db_name
  username      = var.db_username
  password      = var.db_password

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  allowed_security_group_ids = [module.eks.cluster_security_group_id]

  multi_az                = false
  backup_retention_period = 7
  skip_final_snapshot     = true

  tags = {
    Environment = "development"
  }

  depends_on = [module.eks]
}

# IAM Module
module "iam" {
  source = "../../modules/iam"

  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.cluster_oidc_issuer_url

  tags = {
    Environment = "development"
  }

  depends_on = [module.eks]
}

# ECR Repositories
resource "aws_ecr_repository" "backend" {
  name                 = "${var.project_name}-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = "development"
  }
}

resource "aws_ecr_repository" "frontend" {
  name                 = "${var.project_name}-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = "development"
  }
}

# S3 Bucket for Application Assets
resource "aws_s3_bucket" "app_assets" {
  bucket = "${var.project_name}-app-assets-${data.aws_caller_identity.current.account_id}"

  tags = {
    Environment = "development"
  }
}

resource "aws_s3_bucket_versioning" "app_assets" {
  bucket = aws_s3_bucket.app_assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_assets" {
  bucket = aws_s3_bucket.app_assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Data source for current AWS account
data "aws_caller_identity" "current" {}
