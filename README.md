# Multi-Tier DevOps Application with Complete CI/CD Pipeline

A production-ready microservices application demonstrating enterprise-level DevOps practices with Docker, Kubernetes, Terraform, and Jenkins.

## 🏗️ Architecture

This project implements a three-tier architecture:
- **Frontend**: React.js single-page application
- **Backend**: Node.js/Express REST API
- **Database**: PostgreSQL with persistent storage

## 🛠️ Technologies Used

- **Containerization**: Docker
- **Orchestration**: Kubernetes (AWS EKS)
- **Infrastructure as Code**: Terraform
- **CI/CD**: Jenkins
- **Monitoring**: Prometheus + Grafana
- **Logging**: ELK Stack / Loki
- **Cloud Provider**: AWS

## 📁 Project Structure

```
multi-tier-devops-app/
├── frontend/                 # React application
├── backend/                  # Node.js API
├── database/                 # Database initialization
├── terraform/                # Infrastructure as Code
├── kubernetes/               # K8s manifests
├── helm/                     # Helm charts
├── jenkins/                  # CI/CD pipelines
├── monitoring/               # Monitoring stack
├── scripts/                  # Utility scripts
└── docker-compose.yml        # Local development
```

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Node.js 18+
- AWS CLI configured
- kubectl
- Terraform
- Jenkins

### Local Development

1. Clone the repository:
```bash
git clone <repository-url>
cd cicd-aws
```

2. Start all services locally:
```bash
docker-compose up
```

3. Access the application:
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000
- Database: localhost:5432

## 📦 Deployment

### Infrastructure Setup

1. Initialize Terraform:
```bash
cd terraform/environments/dev
terraform init
```

2. Plan and apply infrastructure:
```bash
terraform plan
terraform apply
```

### Application Deployment

1. Build and push Docker images:
```bash
./scripts/build-images.sh
```

2. Deploy to Kubernetes:
```bash
kubectl apply -f kubernetes/
```

## 🔄 CI/CD Pipeline

The Jenkins pipeline includes:
1. **Checkout** - Clone repository
2. **Build** - Compile and build application
3. **Test** - Run unit and integration tests
4. **Security Scan** - SAST and dependency scanning
5. **Build Docker Image** - Multi-stage builds
6. **Push to Registry** - ECR/Docker Hub
7. **Deploy to Staging** - Automated deployment
8. **Integration Tests** - E2E testing
9. **Deploy to Production** - Manual approval
10. **Notify** - Slack/email notifications

## 📊 Monitoring

- **Metrics**: Prometheus + Grafana dashboards
- **Logs**: Centralized logging with ELK/Loki
- **Alerts**: Automated alerting for critical issues

## 🔐 Security

- Docker image scanning with Trivy
- SAST with SonarQube
- Kubernetes Pod Security Standards
- Network policies
- Secrets management with AWS Secrets Manager

## 📝 Documentation

- [Implementation Plan](./docs/implementation_plan.md)
- [Architecture Diagram](./docs/architecture.md)
- [Deployment Guide](./docs/deployment.md)
- [Troubleshooting](./docs/troubleshooting.md)

## 🤝 Contributing

This is a portfolio project. Feel free to fork and customize for your needs.

## 📄 License

MIT License

## 👤 Author

Your Name - [GitHub](https://github.com/yourusername) | [LinkedIn](https://linkedin.com/in/yourprofile)
