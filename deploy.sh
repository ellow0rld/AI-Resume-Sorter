#!/bin/bash

EC2_IP=$1
SSH_KEY_PATH=$2
GEMINI_API_KEY=$3

echo "Deploying to $EC2_IP..."

# Copy all necessary files to the EC2 instance
scp -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no app.py ec2-user@"$EC2_IP":~/app.py
scp -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no requirements.txt ec2-user@"$EC2_IP":~/requirements.txt
scp -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no -r templates static ec2-user@"$EC2_IP":~/

# SSH into EC2 and start the Flask app
ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no ec2-user@"$EC2_IP" << EOF
    sudo yum install -y python3 python3-pip
    pip3 install --user -r requirements.txt
    export GEMINI_API_KEY="$GEMINI_API_KEY"
    nohup python3 app.py > output.log 2>&1 &
EOF
