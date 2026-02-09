# Creating Jenkins Pipelines - Quick Guide

Since the pipelines weren't auto-created, here's how to create them manually in Jenkins (takes 2 minutes):

## Create Backend Pipeline

1. **Go to Jenkins Dashboard**: http://localhost:8080
2. **Click "New Item"** (top left)
3. **Enter name**: `backend-pipeline`
4. **Select**: "Pipeline"
5. **Click OK**

6. **In the configuration page:**
   - **Description**: `Backend API CI/CD Pipeline`
   - Scroll down to **Pipeline** section
   - **Definition**: Select "Pipeline script from SCM"
   - **SCM**: Select "Git"
   - **Repository URL**: `file:///c:/games/java code/cicd-aws` (or your project path)
   - **Branch Specifier**: `*/main`
   - **Script Path**: `jenkins/Jenkinsfile.backend`
   
7. **Click "Save"**

## Create Frontend Pipeline

1. **Click "New Item"** again
2. **Enter name**: `frontend-pipeline`
3. **Select**: "Pipeline"
4. **Click OK**

5. **In the configuration page:**
   - **Description**: `Frontend React CI/CD Pipeline`
   - Scroll down to **Pipeline** section
   - **Definition**: Select "Pipeline script from SCM"
   - **SCM**: Select "Git"
   - **Branch Specifier**: `*/main`
   - **Script Path**: `jenkins/Jenkinsfile.frontend`
   
6. **Click "Save"**

## Alternative: Use Pipeline Script Directly

If Git setup is complex, you can paste the Jenkinsfile content directly:

1. **Create New Item** → Pipeline
2. In **Pipeline** section:
   - **Definition**: "Pipeline script"
   - **Script**: Copy and paste content from `jenkins/Jenkinsfile.backend`
3. **Save**

## Test the Pipeline

1. Click on `backend-pipeline`
2. Click **"Build Now"**
3. Watch the build progress
4. Click on build #1 → **"Console Output"** to see logs

---

## Expected First Build Behavior

The first build will likely:
- ✅ Checkout code successfully
- ✅ Install dependencies
- ⚠️ May skip Docker push (no credentials yet)
- ⚠️ May skip K8s deployment (no cluster yet)

This is normal for local testing!

## Quick Alternative: Use Freestyle Jobs

If you want even simpler testing:

1. **New Item** → **Freestyle project**
2. **Build Steps** → **Execute shell**:
   ```bash
   cd backend
   npm install
   npm test
   ```
3. **Save** and **Build Now**

---

Would you like me to create a script to auto-create these jobs via Jenkins CLI?
