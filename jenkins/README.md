# Jenkins CI/CD Setup Guide

This guide will help you set up Jenkins for automated CI/CD pipelines.

## Quick Start

### 1. Start Jenkins Server

```bash
cd jenkins
docker-compose up -d
```

Jenkins will be available at: **http://localhost:8080**

**Default Credentials:**
- Username: `admin`
- Password: `admin123`

> ⚠️ **Change the default password** after first login!

### 2. Verify Jenkins is Running

```bash
docker ps | grep jenkins
docker logs jenkins-server
```

Wait for the message: `Jenkins is fully up and running`

### 3. Access Jenkins

Open your browser and navigate to:
```
http://localhost:8080
```

## Configuration

### Pre-configured Features

The Jenkins instance comes pre-configured with:

✅ **Configuration as Code (JCasC)** - No manual setup needed
✅ **Docker support** - Build and push Docker images
✅ **Git integration** - Source code management
✅ **Pre-created pipelines** - Backend and Frontend jobs
✅ **Credentials management** - Docker Hub, GitHub, AWS

### Update Credentials

Edit `jenkins/casc.yaml` and update the following:

```yaml
credentials:
  system:
    domainCredentials:
      - credentials:
          - usernamePassword:
              id: "docker-hub"
              username: "YOUR_DOCKERHUB_USERNAME"
              password: "YOUR_DOCKERHUB_PASSWORD"
          - usernamePassword:
              id: "github"
              username: "YOUR_GITHUB_USERNAME"
              password: "YOUR_GITHUB_TOKEN"
          - string:
              id: "aws-access-key"
              secret: "YOUR_AWS_ACCESS_KEY"
          - string:
              id: "aws-secret-key"
              secret: "YOUR_AWS_SECRET_KEY"
```

Then restart Jenkins:
```bash
docker-compose restart jenkins
```

## Pipeline Overview

### Backend Pipeline

**Stages:**
1. ✅ Checkout - Clone repository
2. ✅ Install Dependencies - npm install
3. ✅ Lint - Code quality checks
4. ✅ Test - Unit tests with coverage
5. ✅ Security Scan - npm audit
6. ✅ Build Docker Image - Multi-stage build
7. ✅ Scan Docker Image - Trivy security scan
8. ✅ Push to Registry - Docker Hub/ECR
9. ✅ Deploy to Staging - Auto-deploy on develop branch
10. ✅ Integration Tests - E2E tests
11. ✅ Deploy to Production - Manual approval required
12. ✅ Verify Deployment - Health checks

**Triggers:**
- Automatic on push to `develop` → Deploy to staging
- Manual approval for `main` → Deploy to production

### Frontend Pipeline

**Stages:**
1. ✅ Checkout
2. ✅ Install Dependencies
3. ✅ Lint
4. ✅ Test - Unit tests with coverage
5. ✅ Build Application - Production build
6. ✅ Build Docker Image
7. ✅ Scan Docker Image - Trivy
8. ✅ Push to Registry
9. ✅ Deploy to Staging
10. ✅ Deploy to Production - Manual approval
11. ✅ Verify Deployment

## Running Pipelines

### Option 1: Manual Trigger

1. Go to Jenkins dashboard: http://localhost:8080
2. Click on `backend-pipeline` or `frontend-pipeline`
3. Click **"Build Now"**

### Option 2: Git Push (Automatic)

The pipelines are configured to poll SCM every 5 minutes:

```bash
# Make changes to your code
git add .
git commit -m "Your changes"
git push origin develop  # Triggers staging deployment

# Or for production
git push origin main     # Triggers production deployment (with approval)
```

### Option 3: Webhook (Recommended for Production)

Configure GitHub/GitLab webhooks to trigger builds automatically:

**GitHub Webhook URL:**
```
http://your-jenkins-server:8080/github-webhook/
```

**Payload URL:** `http://your-jenkins-server:8080/github-webhook/`
**Content type:** `application/json`
**Events:** Push events

## Build and Deploy Workflow

### Development Workflow

```bash
# 1. Create feature branch
git checkout -b feature/new-feature

# 2. Make changes and test locally
docker-compose up

# 3. Commit and push
git add .
git commit -m "Add new feature"
git push origin feature/new-feature

# 4. Create PR to develop
# 5. Merge to develop → Auto-deploy to staging
# 6. Test in staging
# 7. Create PR to main
# 8. Merge to main → Manual approval for production
```

### Branch Strategy

- `feature/*` - Feature branches (no auto-deploy)
- `develop` - Development branch (auto-deploy to staging)
- `main` - Production branch (manual approval required)

## Docker Image Management

### Tagging Strategy

Images are tagged with:
- Build number: `devops-backend:123`
- Latest: `devops-backend:latest`
- Git commit: `devops-backend:abc1234` (optional)

### Push to Docker Hub

```bash
# Login to Docker Hub
docker login

# Build and push manually
docker build -t yourusername/devops-backend:latest ./backend
docker push yourusername/devops-backend:latest
```

### Push to AWS ECR

```bash
# Login to ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin \
  YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

# Tag and push
docker tag devops-backend:latest \
  YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/devops-backend:latest

docker push YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/devops-backend:latest
```

## Monitoring Pipelines

### View Build Logs

1. Click on a pipeline
2. Click on a build number
3. Click **"Console Output"**

### View Test Reports

1. Click on a build
2. Click **"Test Results"** or **"Coverage Report"**

### Email Notifications

Add to `Jenkinsfile`:

```groovy
post {
    success {
        emailext (
            subject: "✅ Build Successful: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: "Build completed successfully.",
            to: "team@example.com"
        )
    }
    failure {
        emailext (
            subject: "❌ Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
            body: "Build failed. Check console output.",
            to: "team@example.com"
        )
    }
}
```

## Troubleshooting

### Issue: Jenkins won't start

**Solution:**
```bash
# Check logs
docker logs jenkins-server

# Restart
docker-compose restart jenkins

# Rebuild
docker-compose down
docker-compose up -d --build
```

### Issue: Docker commands fail in pipeline

**Solution:** Ensure Docker socket is mounted:
```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
```

### Issue: Cannot push to Docker registry

**Solution:** Update credentials in `casc.yaml` and restart Jenkins.

### Issue: Kubernetes deployment fails

**Solution:** 
1. Ensure kubectl is configured: `kubectl get nodes`
2. Check namespace exists: `kubectl get ns`
3. Verify deployment exists: `kubectl get deploy -n production`

## Security Best Practices

1. ✅ **Change default password** immediately
2. ✅ **Use secrets** for sensitive data (not hardcoded)
3. ✅ **Enable HTTPS** for production
4. ✅ **Scan Docker images** with Trivy
5. ✅ **Audit dependencies** with npm audit
6. ✅ **Use least privilege** IAM roles
7. ✅ **Enable build approval** for production

## Advanced Configuration

### Add SonarQube Integration

```groovy
stage('SonarQube Analysis') {
    steps {
        withSonarQubeEnv('SonarQube') {
            sh 'npm run sonar'
        }
    }
}
```

### Add Slack Notifications

```groovy
post {
    success {
        slackSend (
            color: 'good',
            message: "✅ Build successful: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
        )
    }
}
```

### Parallel Stages

```groovy
stage('Parallel Tests') {
    parallel {
        stage('Unit Tests') {
            steps { sh 'npm test' }
        }
        stage('Integration Tests') {
            steps { sh 'npm run test:integration' }
        }
    }
}
```

## Cleanup

### Stop Jenkins

```bash
cd jenkins
docker-compose down
```

### Remove volumes (⚠️ deletes all data)

```bash
docker-compose down -v
```

## Next Steps

1. ✅ Jenkins server running
2. ⏭️ Configure credentials
3. ⏭️ Test pipelines locally
4. ⏭️ Set up webhooks
5. ⏭️ Deploy to staging
6. ⏭️ Deploy to production

---

## Quick Reference

**Jenkins URL:** http://localhost:8080
**Username:** admin
**Password:** admin123 (change this!)

**Pipelines:**
- Backend: http://localhost:8080/job/backend-pipeline/
- Frontend: http://localhost:8080/job/frontend-pipeline/

**Useful Commands:**
```bash
# Start Jenkins
docker-compose up -d

# View logs
docker logs -f jenkins-server

# Restart
docker-compose restart

# Stop
docker-compose down
```
