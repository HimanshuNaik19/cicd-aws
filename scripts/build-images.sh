#!/bin/bash

# Build and Push Docker Images to Registry
# Usage: ./build-images.sh [registry] [tag]

set -e

# Configuration
REGISTRY=${1:-"dockerhub"}  # dockerhub or ecr
TAG=${2:-"latest"}
PROJECT_NAME="devops"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Docker Image Build and Push Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to build and push image
build_and_push() {
    local service=$1
    local context=$2
    local dockerfile=$3
    
    echo -e "${GREEN}Building ${service} image...${NC}"
    
    if [ "$REGISTRY" == "ecr" ]; then
        # AWS ECR
        AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
        AWS_REGION=${AWS_REGION:-us-east-1}
        REGISTRY_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        IMAGE_NAME="${REGISTRY_URL}/${PROJECT_NAME}-${service}"
        
        # Login to ECR
        echo -e "${BLUE}Logging in to ECR...${NC}"
        aws ecr get-login-password --region ${AWS_REGION} | \
            docker login --username AWS --password-stdin ${REGISTRY_URL}
        
        # Create repository if it doesn't exist
        aws ecr describe-repositories --repository-names ${PROJECT_NAME}-${service} --region ${AWS_REGION} 2>/dev/null || \
            aws ecr create-repository --repository-name ${PROJECT_NAME}-${service} --region ${AWS_REGION}
    else
        # Docker Hub
        DOCKER_USERNAME=${DOCKER_USERNAME:-"yourusername"}
        IMAGE_NAME="${DOCKER_USERNAME}/${PROJECT_NAME}-${service}"
        
        # Login to Docker Hub
        if [ -n "$DOCKER_PASSWORD" ]; then
            echo -e "${BLUE}Logging in to Docker Hub...${NC}"
            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
        fi
    fi
    
    # Build image
    echo -e "${BLUE}Building image: ${IMAGE_NAME}:${TAG}${NC}"
    docker build \
        --target production \
        -t ${IMAGE_NAME}:${TAG} \
        -t ${IMAGE_NAME}:latest \
        -f ${dockerfile} \
        ${context}
    
    # Push image
    echo -e "${BLUE}Pushing image: ${IMAGE_NAME}:${TAG}${NC}"
    docker push ${IMAGE_NAME}:${TAG}
    docker push ${IMAGE_NAME}:latest
    
    echo -e "${GREEN}✅ ${service} image built and pushed successfully!${NC}"
    echo ""
}

# Build and push backend
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Building Backend Service${NC}"
echo -e "${BLUE}========================================${NC}"
build_and_push "backend" "./backend" "./backend/Dockerfile"

# Build and push frontend
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Building Frontend Service${NC}"
echo -e "${BLUE}========================================${NC}"
build_and_push "frontend" "./frontend" "./frontend/Dockerfile"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  All images built and pushed!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Images:"
if [ "$REGISTRY" == "ecr" ]; then
    AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    AWS_REGION=${AWS_REGION:-us-east-1}
    echo "  - ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PROJECT_NAME}-backend:${TAG}"
    echo "  - ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PROJECT_NAME}-frontend:${TAG}"
else
    DOCKER_USERNAME=${DOCKER_USERNAME:-"yourusername"}
    echo "  - ${DOCKER_USERNAME}/${PROJECT_NAME}-backend:${TAG}"
    echo "  - ${DOCKER_USERNAME}/${PROJECT_NAME}-frontend:${TAG}"
fi
