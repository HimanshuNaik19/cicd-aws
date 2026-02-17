# Google Cloud Platform Setup Guide

## Option 1: Install gcloud CLI (Recommended)

1. **Download**: [Google Cloud SDK Installer](https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe)
2. **Run Installer**: Follow the prompts (Select "Single User").
3. **Finish**: Checked "Start Google Cloud SDK Shell" and "Run gcloud init".
4. **Restart Terminal**: After installation, close this terminal window and open a new one to refresh the `PATH`.
5. **Verify**:
   Run `gcloud version` in the new terminal.

## Option 2: Use Service Account Key (If you can't install CLI)

1. Go to **GCP Console** -> **IAM & Admin** -> **Service Accounts**.
2. Create a service account (e.g., `terraform-admin`).
3. Grant `Editor` or `Owner` role.
4. Create a JSON key: **Actions** -> **Manage keys** -> **Add key** -> **Create new key** -> **JSON**.
5. Save the file as `gcp-key.json` in `c:\games\java code\cicd-aws\`.

---

**Authenticating with gcloud (After Installation):**

```bash
gcloud auth login
gcloud config set project [YOUR_PROJECT_ID]
gcloud auth application-default login
```
