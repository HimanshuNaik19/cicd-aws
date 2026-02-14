# Jenkins CI/CD - Quick Start Guide

## 🚀 Start Jenkins

```bash
cd jenkins
docker-compose up -d
```

**Access**: http://localhost:8080
**Login**: admin / admin123

---

## 📝 Create Your First Pipeline

### Option 1: Simple Test (Recommended for First Time)

1. Go to Jenkins → **New Item**
2. Name: `test-pipeline`
3. Type: **Pipeline**
4. In Pipeline section, paste this:

```groovy
pipeline {
    agent any
    stages {
        stage('Hello') {
            steps {
                echo 'Hello from Jenkins!'
                sh 'docker --version'
            }
        }
    }
}
```

5. **Save** → **Build Now**

### Option 2: Full Backend Pipeline

1. **New Item** → Name: `backend-pipeline` → Type: **Pipeline**
2. Copy content from `Jenkinsfile.backend` and paste it
3. **Save** → **Build Now**

### Option 3: Full Frontend Pipeline

1. **New Item** → Name: `frontend-pipeline` → Type: **Pipeline**
2. Copy content from `Jenkinsfile.frontend` and paste it
3. **Save** → **Build Now**

---

## 🔧 Configuration

### Update Docker Hub Username

Edit both Jenkinsfiles and change:
```groovy
DOCKER_IMAGE = "himanshunaik22/${IMAGE_NAME}"
```

### Enable Docker Hub Push (Optional)

Uncomment this line in Jenkinsfiles:
```groovy
// DOCKER_REGISTRY = credentials('docker-hub')
```

Then update `casc.yaml` with your credentials and restart:
```bash
docker-compose restart
```

---

## 🛑 Stop Jenkins

```bash
docker-compose down
```

To delete all data:
```bash
docker-compose down -v
```

---

## 📊 What Each File Does

- **docker-compose.yml** - Starts Jenkins + Docker-in-Docker
- **casc.yaml** - Auto-configures Jenkins (credentials, users)
- **Jenkinsfile.backend** - Backend CI/CD pipeline
- **Jenkinsfile.frontend** - Frontend CI/CD pipeline
- **README.md** - This file

---

## ✅ Expected Pipeline Stages

1. Checkout code
2. Install dependencies
3. Run tests
4. Build Docker image
5. Push to Docker Hub (if credentials configured)
6. Deploy (if Kubernetes available)

---

## 🐛 Troubleshooting

**Jenkins won't start?**
```bash
docker logs jenkins-server
```

**Can't login?**
- Username: `admin`
- Password: `admin123`

**Pipeline fails?**
- First builds may skip Docker push (no credentials yet)
- This is normal for local testing!

---

That's it! Start with Option 1 to test, then try the full pipelines.
