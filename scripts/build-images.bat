@echo off
REM Build and Push Docker Images to Registry (Windows)
REM Usage: build-images.bat [registry] [tag]

setlocal enabledelayedexpansion

REM Configuration
set REGISTRY=%1
if "%REGISTRY%"=="" set REGISTRY=dockerhub

set TAG=%2
if "%TAG%"=="" set TAG=latest

set PROJECT_NAME=devops

echo ========================================
echo   Docker Image Build and Push Script
echo ========================================
echo.

REM Function to build and push backend
echo ========================================
echo   Building Backend Service
echo ========================================

if "%REGISTRY%"=="ecr" (
    REM AWS ECR
    for /f "tokens=*" %%i in ('aws sts get-caller-identity --query Account --output text') do set AWS_ACCOUNT_ID=%%i
    if "%AWS_REGION%"=="" set AWS_REGION=us-east-1
    set REGISTRY_URL=!AWS_ACCOUNT_ID!.dkr.ecr.!AWS_REGION!.amazonaws.com
    set BACKEND_IMAGE=!REGISTRY_URL!/%PROJECT_NAME%-backend
    
    echo Logging in to ECR...
    aws ecr get-login-password --region !AWS_REGION! | docker login --username AWS --password-stdin !REGISTRY_URL!
    
    echo Creating repository if it doesn't exist...
    aws ecr describe-repositories --repository-names %PROJECT_NAME%-backend --region !AWS_REGION! 2>nul || aws ecr create-repository --repository-name %PROJECT_NAME%-backend --region !AWS_REGION!
) else (
    REM Docker Hub
    if "%DOCKER_USERNAME%"=="" set DOCKER_USERNAME=yourusername
    set BACKEND_IMAGE=%DOCKER_USERNAME%/%PROJECT_NAME%-backend
    
    if not "%DOCKER_PASSWORD%"=="" (
        echo Logging in to Docker Hub...
        echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin
    )
)

echo Building backend image: %BACKEND_IMAGE%:%TAG%
docker build --target production -t %BACKEND_IMAGE%:%TAG% -t %BACKEND_IMAGE%:latest -f backend\Dockerfile backend

echo Pushing backend image...
docker push %BACKEND_IMAGE%:%TAG%
docker push %BACKEND_IMAGE%:latest

echo Backend image built and pushed successfully!
echo.

REM Function to build and push frontend
echo ========================================
echo   Building Frontend Service
echo ========================================

if "%REGISTRY%"=="ecr" (
    set FRONTEND_IMAGE=!REGISTRY_URL!/%PROJECT_NAME%-frontend
    
    echo Creating repository if it doesn't exist...
    aws ecr describe-repositories --repository-names %PROJECT_NAME%-frontend --region !AWS_REGION! 2>nul || aws ecr create-repository --repository-name %PROJECT_NAME%-frontend --region !AWS_REGION!
) else (
    set FRONTEND_IMAGE=%DOCKER_USERNAME%/%PROJECT_NAME%-frontend
)

echo Building frontend image: %FRONTEND_IMAGE%:%TAG%
docker build --target production -t %FRONTEND_IMAGE%:%TAG% -t %FRONTEND_IMAGE%:latest -f frontend\Dockerfile frontend

echo Pushing frontend image...
docker push %FRONTEND_IMAGE%:%TAG%
docker push %FRONTEND_IMAGE%:latest

echo Frontend image built and pushed successfully!
echo.

echo ========================================
echo   All images built and pushed!
echo ========================================
echo.
echo Images:
echo   - %BACKEND_IMAGE%:%TAG%
echo   - %FRONTEND_IMAGE%:%TAG%

endlocal
