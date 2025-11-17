#!/bin/bash
set -e

# Pull latest image from ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 156916772993.dkr.ecr.us-east-1.amazonaws.com
docker pull 156916772993.dkr.ecr.us-east-1.amazonaws.com/gifmachine:latest

# Stop and remove old container
docker stop gifmachine || true
docker rm gifmachine || true

# Run new container
docker run -d \
  --name gifmachine \
  --restart unless-stopped \
  -p 80:4567 \
  -e DATABASE_URL="postgres://gifadmin:mv62jCJZeJXZSzeS4OMe@gifmachine.c2pccckqsbed.us-east-1.rds.amazonaws.com:5432/gifmachine?sslmode=require" \
  -e GIFMACHINE_PASSWORD=mySuperSecret \
  123456789012.dkr.ecr.us-east-1.amazonaws.com/gifmachine:latest

# Validate after 30 seconds
sleep 30
curl -f http://localhost || exit 1
echo "GIFMachine is up and running!"
