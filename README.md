# DevOps Multi-Tier Application

A full-stack DevOps project demonstrating CI/CD, containerization, cloud infrastructure, and monitoring.

## 🚀 Quick Start

### Prerequisites
- Docker Desktop
- Git

### Run Locally

```bash
# Clone the repository
git clone https://github.com/HimanshuNaik19/cicd-aws.git
cd cicd-aws

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f
```

### Access Applications

- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:5000
- **Grafana:** http://localhost:3001 (admin/admin)
- **Prometheus:** http://localhost:9090

---

## 📁 Project Structure

```
cicd-aws/
├── backend/              # Node.js Express API
├── frontend/             # React Application
├── database/             # PostgreSQL init scripts
├── jenkins/              # CI/CD configuration
├── terraform/            # GCP infrastructure
├── kubernetes/           # K8s manifests for GKE
├── docker-compose.yml    # Local development
└── README.md
```

---

## 🛠️ Technology Stack

### Application
- **Backend:** Node.js, Express, PostgreSQL
- **Frontend:** React, Axios
- **Database:** PostgreSQL 15

### DevOps
- **Containerization:** Docker, Docker Compose
- **CI/CD:** Jenkins
- **Cloud:** Google Cloud Platform (GCP)
- **Orchestration:** Kubernetes (GKE)
- **IaC:** Terraform
- **Monitoring:** Prometheus, Grafana

---

## 🔧 Development

### Backend Development
```bash
cd backend
npm install
npm run dev
```

### Frontend Development
```bash
cd frontend
npm install
npm start
```

### Database Access
```bash
docker exec -it devops-postgres psql -U postgres -d devops
```

---

## 🚢 Deployment

### Deploy to GCP

1. **Set up GCP credentials**
   ```bash
   gcloud auth login
   gcloud config set project YOUR_PROJECT_ID
   ```

2. **Deploy infrastructure**
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

3. **Deploy to Kubernetes**
   ```bash
   gcloud container clusters get-credentials devops-cluster --region us-central1
   kubectl apply -f kubernetes/
   ```

---

## 📊 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check |
| GET | `/api` | API information |
| GET | `/api/items` | Get all items |
| POST | `/api/items` | Create item |
| PUT | `/api/items/:id` | Update item |
| DELETE | `/api/items/:id` | Delete item |

---

## 🧪 Testing

```bash
# Test backend health
curl http://localhost:5000/health

# Test API
curl http://localhost:5000/api/items

# Create item
curl -X POST http://localhost:5000/api/items \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","description":"Testing"}'
```

---

## 📈 Monitoring

### Grafana Dashboards
1. Access Grafana: http://localhost:3001
2. Login: admin/admin
3. Add Prometheus datasource: http://prometheus:9090
4. Import dashboards or create custom ones

### Prometheus Metrics
- Application metrics: http://localhost:9090
- Query examples:
  - `up` - Service availability
  - `http_requests_total` - Request count

---

## 🔄 CI/CD Pipeline

Jenkins pipeline automatically:
1. Checks out code from GitHub
2. Builds Docker images
3. Runs tests
4. Pushes images to Docker Hub
5. Deploys to Kubernetes (GKE)

### Trigger Build
```bash
# Push to GitHub triggers webhook
git add .
git commit -m "Update"
git push origin main
```

---

## 🛑 Stop Services

```bash
# Stop all containers
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

---

## 📝 Environment Variables

### Backend (.env)
```env
NODE_ENV=development
PORT=5000
DB_HOST=postgres
DB_PORT=5432
DB_NAME=devops
DB_USER=postgres
DB_PASSWORD=postgres
```

### Frontend (.env)
```env
REACT_APP_API_URL=http://localhost:5000
```

---

## 🐛 Troubleshooting

### Containers not starting
```bash
docker-compose down -v
docker-compose up -d --build
```

### Database connection issues
```bash
docker logs devops-backend
docker logs devops-postgres
```

### Port already in use
```bash
# Stop conflicting services
docker ps
docker stop <container_id>
```

---

## 💰 Cost Estimate (GCP)

- **GKE Cluster:** ~$70/month
- **Cloud SQL:** ~$15/month
- **Networking:** ~$10/month
- **Total:** ~$95/month

**Free Tier:** $300 credit = 3 months free

---

## 🎯 Features

- ✅ Full-stack application (React + Node.js)
- ✅ RESTful API with CRUD operations
- ✅ PostgreSQL database with migrations
- ✅ Docker containerization
- ✅ Docker Compose orchestration
- ✅ Jenkins CI/CD pipeline
- ✅ Terraform infrastructure as code
- ✅ Kubernetes deployment manifests
- ✅ Prometheus monitoring
- ✅ Grafana dashboards
- ✅ Health checks and logging
- ✅ Environment-based configuration

---

## 📚 Learn More

- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Jenkins Documentation](https://www.jenkins.io/doc/)

---

## 👤 Author

**Himanshu Naik**
- GitHub: [@HimanshuNaik19](https://github.com/HimanshuNaik19)
- LinkedIn: [Himanshu Naik](https://linkedin.com/in/himanshunaik)

---

## 📄 License

This project is licensed under the MIT License.

---

## 🙏 Acknowledgments

Built as a DevOps portfolio project demonstrating:
- Modern application development
- Cloud-native architecture
- CI/CD best practices
- Infrastructure as Code
- Container orchestration
- Monitoring and observability
