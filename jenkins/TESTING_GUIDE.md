# Testing Jenkins Pipelines - Step by Step Guide

## 🎯 Goal
Test both backend and frontend Jenkins pipelines to verify the CI/CD workflow.

---

## 📋 Prerequisites

✅ Jenkins running at http://localhost:8080
✅ Login credentials: admin/admin123
✅ Jenkinsfile.backend and Jenkinsfile.frontend ready

---

## 🔧 Step 1: Create Backend Pipeline

1. **Open Jenkins**: http://localhost:8080
2. **Click "New Item"** (left sidebar)
3. **Enter name**: `backend-pipeline`
4. **Select**: "Pipeline"
5. **Click "OK"**

6. **Configure the pipeline**:
   - **Description**: `Backend API CI/CD Pipeline`
   - Scroll to **Pipeline** section
   - **Definition**: Select "Pipeline script"
   - **Script**: Copy the entire content from `jenkins/Jenkinsfile.backend` and paste it

7. **Click "Save"**

---

## 🔧 Step 2: Create Frontend Pipeline

1. **Click "Dashboard"** (top left)
2. **Click "New Item"**
3. **Enter name**: `frontend-pipeline`
4. **Select**: "Pipeline"
5. **Click "OK"**

6. **Configure the pipeline**:
   - **Description**: `Frontend React CI/CD Pipeline`
   - Scroll to **Pipeline** section
   - **Definition**: Select "Pipeline script"
   - **Script**: Copy the entire content from `jenkins/Jenkinsfile.frontend` and paste it

7. **Click "Save"**

---

## 🚀 Step 3: Run Backend Pipeline

1. **Click on "backend-pipeline"**
2. **Click "Build Now"** (left sidebar)
3. **Watch the build**:
   - A build #1 will appear under "Build History"
   - Click on **#1**
   - Click **"Console Output"** to see real-time logs

**Expected stages**:
```
📥 Checkout - ✅ Should succeed
📦 Install Dependencies - ✅ Should succeed
🧪 Test - ✅ Should succeed (or skip)
🐳 Build Docker Image - ✅ Should succeed
📤 Push to Docker Hub - ⚠️ Will skip (no credentials configured)
🚀 Deploy - ⚠️ Will skip (no K8s cluster)
```

**Expected result**: ✅ SUCCESS (even with skipped stages)

---

## 🚀 Step 4: Run Frontend Pipeline

1. **Click "Dashboard"**
2. **Click on "frontend-pipeline"**
3. **Click "Build Now"**
4. **Click on build #1** → **"Console Output"**

**Expected stages**:
```
📥 Checkout - ✅ Should succeed
📦 Install Dependencies - ✅ Should succeed
🧪 Test - ✅ Should succeed (or skip)
🏗️ Build Application - ✅ Should succeed (npm run build)
🐳 Build Docker Image - ✅ Should succeed
📤 Push to Docker Hub - ⚠️ Will skip (no credentials)
🚀 Deploy - ⚠️ Will skip (no K8s)
```

**Expected result**: ✅ SUCCESS

---

## 🔍 What to Look For

### ✅ Success Indicators
- Green checkmarks ✅ in Jenkins UI
- "Finished: SUCCESS" at the end of console output
- Docker images built locally
- Clear stage progression

### ⚠️ Expected Warnings
- "Docker push skipped - configure credentials to enable"
- "Deployment skipped - Kubernetes not configured yet"
- These are NORMAL for local testing!

### ❌ Potential Issues

**Issue**: "npm: command not found"
- **Cause**: Running outside the correct directory
- **Fix**: Pipeline should use `dir('backend')` or `dir('frontend')`

**Issue**: "docker: command not found"
- **Cause**: Docker not accessible in Jenkins
- **Fix**: Already fixed with our custom Dockerfile

**Issue**: "checkout scm failed"
- **Cause**: No Git repository initialized
- **Fix**: Use "Pipeline script" instead of "Pipeline script from SCM"

---

## 🐳 Step 5: Verify Docker Images

After successful builds, check that images were created:

```bash
docker images | grep devops
```

**Expected output**:
```
himanshunaik22/devops-backend    1       abc123   2 minutes ago   150MB
himanshunaik22/devops-backend    latest  abc123   2 minutes ago   150MB
himanshunaik22/devops-frontend   1       def456   1 minute ago    50MB
himanshunaik22/devops-frontend   latest  def456   1 minute ago    50MB
```

---

## 🧪 Step 6: Test the Built Images (Optional)

### Test Backend Image
```bash
docker run -d -p 5001:5000 --name test-backend himanshunaik22/devops-backend:latest
curl http://localhost:5001/health
docker stop test-backend && docker rm test-backend
```

**Expected**: `{"status":"healthy"}`

### Test Frontend Image
```bash
docker run -d -p 3001:80 --name test-frontend himanshunaik22/devops-frontend:latest
# Open http://localhost:3001 in browser
docker stop test-frontend && docker rm test-frontend
```

**Expected**: React app loads

---

## 📊 Understanding the Console Output

### Good Signs
```
✅ Pipeline completed successfully!
[Pipeline] End of Pipeline
Finished: SUCCESS
```

### Stage Execution
```
[Pipeline] stage
[Pipeline] { (Checkout)
📥 Checking out code...
[Pipeline] }
[Pipeline] // stage
```

### Skipped Stages (Normal)
```
⚠️ Docker push skipped - configure credentials to enable
⚠️ Deployment skipped - Kubernetes not configured yet
```

---

## 🎯 Success Criteria

- ✅ Both pipelines created in Jenkins
- ✅ Both pipelines run without errors
- ✅ All build stages complete successfully
- ✅ Docker images created locally
- ✅ Console output shows clear stage progression
- ⚠️ Push and deploy stages skip gracefully

---

## 🔄 Next Steps After Testing

Once pipelines work locally:

1. **Configure Docker Hub credentials** (to enable push)
2. **Deploy AWS infrastructure** (to enable K8s deployment)
3. **Set up webhooks** (for automatic builds)
4. **Add notifications** (Slack/email)

---

## 🐛 Troubleshooting

**Pipeline won't start?**
- Check Jenkins logs: `docker logs jenkins-server`
- Verify plugins installed: Manage Jenkins → Plugins

**Build fails immediately?**
- Check the Jenkinsfile syntax
- Verify Docker is accessible: `docker ps` inside Jenkins

**Can't find the pipeline?**
- Refresh Jenkins dashboard
- Check you're logged in

---

## 📝 Quick Reference

**Jenkins URL**: http://localhost:8080
**Username**: admin
**Password**: admin123

**Pipeline locations**:
- Backend: `jenkins/Jenkinsfile.backend`
- Frontend: `jenkins/Jenkinsfile.frontend`

**Expected build time**:
- Backend: ~2-3 minutes
- Frontend: ~3-4 minutes (includes React build)

---

Ready to test! Follow the steps above and let me know if you encounter any issues.
