terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# VPC Network
resource "google_compute_network" "vpc" {
  name                    = "devops-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "devops-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

# GKE Cluster
resource "google_container_cluster" "primary" {
  name     = "devops-cluster"
  location = var.region
  
  remove_default_node_pool = true
  initial_node_count       = 1
  
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "devops-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 2
  
  node_config {
    machine_type = "e2-medium"
    
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    
    labels = {
      env = "dev"
    }
    
    tags = ["devops", "gke-node"]
  }
}

# Cloud SQL Instance
resource "google_sql_database_instance" "postgres" {
  name             = "devops-postgres"
  database_version = "POSTGRES_15"
  region           = var.region
  
  settings {
    tier = "db-f1-micro"
    
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "all"
        value = "0.0.0.0/0"
      }
    }
  }
  
  deletion_protection = false
}

resource "google_sql_database" "database" {
  name     = "devops"
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "user" {
  name     = "postgres"
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
}

# Outputs
output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "database_connection" {
  value = google_sql_database_instance.postgres.connection_name
}

output "database_ip" {
  value = google_sql_database_instance.postgres.public_ip_address
}
