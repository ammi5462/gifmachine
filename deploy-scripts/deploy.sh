#!/bin/bash
set -e

# Variables
ECR_ACCOUNT="156916772993"
REGION="us-east-1"
IMAGE_NAME="gifmachine"
CONTAINER_NAME="gifmachine"
DB_URL="postgres://gifadmin:mv62jCJZeJXZSzeS4OMe@gifmachine.c2pccckqsbed.us-east-1.rds.amazonaws.com:5432/gifmachine?sslmode=require"
GIFMACHINE_PASSWORD="mySuperSecret"

# Login to ECR
echo "Logging in to ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_ACCOUNT.dkr.ecr.$REGION.amazonaws.com

# Pull latest image from ECR
echo "Pulling latest Docker image..."
docker pull $ECR_ACCOUNT.dkr.ecr.$REGION.amazonaws.com/$IMAGE_NAME:latest

# Stop and remove old container
echo "Stopping and removing old container if it exists..."
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

# Remove dangling/unused images to free space
echo "Cleaning up unused Docker images..."
docker image prune -af

# Run new container
echo "Starting new container..."
docker run -d \
  --name $CONTAINER_NAME \
  --restart unless-stopped \
  -p 80:4567 \
  -e DATABASE_URL="$DB_URL" \
  -e GIFMACHINE_PASSWORD="$GIFMACHINE_PASSWORD" \
  $ECR_ACCOUNT.dkr.ecr.$REGION.amazonaws.com/$IMAGE_NAME:latest

# Validate service after 30 seconds
echo "Waiting 30 seconds to validate service..."
sleep 30
curl -f http://localhost || { echo "Validation failed!"; exit 1; }

echo "GIFMachine is up and running!"
