# Jenkins Credentials Setup Guide

## 🔐 Setting Up Docker Hub Credentials

The Jenkins pipeline needs Docker Hub credentials to push images. Follow these steps:

### Step 1: Get Docker Hub Access Token

1. Go to https://hub.docker.com/
2. Log in to your account
3. Click on your username → **Account Settings**
4. Go to **Security** → **New Access Token**
5. Create a token with **Read, Write, Delete** permissions
6. **Copy the token** (you won't see it again!)

### Step 2: Add Credentials to Jenkins

1. Open Jenkins: http://localhost:8080
2. Go to **Manage Jenkins** → **Credentials**
3. Click on **(global)** domain
4. Click **Add Credentials**
5. Fill in:
   - **Kind:** Username with password
   - **Scope:** Global
   - **Username:** Your Docker Hub username (e.g., `himanshunaik22`)
   - **Password:** Paste the access token from Step 1
   - **ID:** `dockerhub-credentials` (exactly this!)
   - **Description:** Docker Hub Credentials
6. Click **Create**

### Step 3: Verify Setup

1. Go back to your pipeline
2. Click **Build Now**
3. The pipeline should now complete successfully!

---

## 🎯 Current Pipeline Behavior

### Without Credentials
- ✅ Checkout code from GitHub
- ✅ Build backend Docker image
- ✅ Build frontend Docker image
- ✅ Run tests
- ⏭️ Skip Docker Hub push
- ⏭️ Skip Kubernetes deployment

### With Credentials
- ✅ Checkout code from GitHub
- ✅ Build backend Docker image
- ✅ Build frontend Docker image
- ✅ Run tests
- ✅ Push to Docker Hub
- ✅ Deploy to Kubernetes (if configured)

---

## 🔧 Troubleshooting

### Error: "dockerhub-credentials not found"
**Solution:** Make sure the credential ID is exactly `dockerhub-credentials`

### Error: "docker login failed"
**Solution:** 
- Verify your Docker Hub username
- Make sure you're using an access token, not your password
- Check the token has write permissions

### Error: "docker push failed"
**Solution:**
- Make sure you're logged into Docker Hub
- Verify the repository name matches your Docker Hub username
- Check you have permission to push to the repository

---

## 📝 Alternative: Skip Docker Hub Push

If you don't want to push to Docker Hub, the pipeline will still work! It will:
1. Build images locally
2. Tag them properly
3. Skip the push stage
4. Complete successfully

This is perfect for:
- Testing the pipeline
- Local development
- Building without publishing

---

## 🚀 Next Steps

After setting up credentials:

1. **Test the pipeline:**
   ```bash
   # Make a small change
   git commit -m "Test pipeline"
   git push
   ```

2. **Verify images on Docker Hub:**
   - Go to https://hub.docker.com/
   - Check your repositories
   - You should see `devops-backend` and `devops-frontend`

3. **Use images in Kubernetes:**
   ```bash
   kubectl apply -f kubernetes/app.yaml
   ```

---

## ✅ Success Criteria

- [ ] Docker Hub credentials added to Jenkins
- [ ] Pipeline builds successfully
- [ ] Images pushed to Docker Hub
- [ ] Images visible in Docker Hub repositories
- [ ] Ready for Kubernetes deployment
