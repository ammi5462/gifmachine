#!/bin/bash
cd /root/gifmachine

docker build -t gifmachine:latest .

docker run -d \
  --name gifmachine \
  --restart unless-stopped \
  -p 80:4567 \
  -e DATABASE_URL="postgres://gifadmin:mv62jCJZeJXZSzeS4OMe@gifmachine.c2pccckqsbed.us-east-1.rds.amazonaws.com:5432/gifmachine?sslmode=require" \
  -e GIFMACHINE_PASSWORD=mySuperSecret \
  gifmachine:latest
