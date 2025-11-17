#!/bin/bash
set -e

# Login to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 156916772993.dkr.ecr.us-east-1.amazonaws.com

# Pull latest image
docker pull 156916772993.dkr.ecr.us-east-1.amazonaws.com/gifmachine:latest

# Stop and remove old container
docker stop gifmachine || true
docker rm gifmachine || true

# Run new container with consistent DB variables
docker run -d \
  --name gifmachine \
  --restart unless-stopped \
  -p 80:4567 \
  -e DB_USER=gifadmin \
  -e DB_PASSWORD="mv62jCJZeJXZSzeS4OMe" \
  -e DB_HOST=gifmachine.c2pccckqsbed.us-east-1.rds.amazonaws.com \
  -e DB_PORT=5432 \
  -e DB_NAME=gifmachine \
  -e GIFMACHINE_PASSWORD=mySuperSecret \
  156916772993.dkr.ecr.us-east-1.amazonaws.com/gifmachine:latest

# Wait and validate
sleep 30
curl -f http://localhost || exit 1
echo "GIFMachine is up and running!"
