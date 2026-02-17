# How to Configure Jenkins with GitHub SCM

## 1. Get a GitHub Personal Access Token

1. Go to **GitHub** → **Settings** → **Developer settings**
2. Click **Personal access tokens** → **Tokens (classic)**
3. Click **Generate new token (classic)**
4. Note: `Jenkins`
5. Select scopes:
   - `repo` (Full control of private repositories)
   - `admin:repo_hook` (for webhooks)
6. Click **Generate token**
7. **Copy the token** immediately!

## 2. Add Credentials to Jenkins

1. Go to **Jenkins** → **Manage Jenkins** → **Credentials**
2. Click **(global)** domain
3. Click **Add Credentials**
4. **Kind**: Username with password
5. **Scope**: Global
6. **Username**: `HimanshuNaik19` (Your GitHub username)
7. **Password**: Paste your **GitHub Token** here
8. **ID**: `github`
9. **Description**: `GitHub Credentials`
10. Click **Create**

## 3. Update Pipelines to use SCM

### For Backend Pipeline:
1. Go to **backend-pipeline** → **Configure**
2. Scroll to **Pipeline** section
3. Change **Definition** to **Pipeline script from SCM**
4. **SCM**: Git
5. **Repository URL**: `https://github.com/HimanshuNaik19/cicd-aws.git`
6. **Credentials**: Select `HimanshuNaik19/****** (GitHub Credentials)`
7. **Branch Specifier**: `*/master`
8. **Script Path**: `jenkins/Jenkinsfile.backend`
9. Click **Save**

### For Frontend Pipeline:
1. Go to **frontend-pipeline** → **Configure**
2. Scroll to **Pipeline** section
3. Change **Definition** to **Pipeline script from SCM**
4. **SCM**: Git
5. **Repository URL**: `https://github.com/HimanshuNaik19/cicd-aws.git`
6. **Credentials**: Select `HimanshuNaik19/****** (GitHub Credentials)`
7. **Branch Specifier**: `*/master`
8. **Script Path**: `jenkins/Jenkinsfile.frontend`
9. Click **Save**

## 4. Run the Pipelines

Click **Build Now** for both pipelines. They will now clone the code directly from GitHub!
