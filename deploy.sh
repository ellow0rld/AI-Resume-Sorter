#!/bin/bash

EC2_IP=$1
API_KEY=$2

# Copy app to EC2
scp -o StrictHostKeyChecking=no -i ~/.ssh/your-key.pem -r app ec2-user@$EC2_IP:/home/ec2-user/
scp -o StrictHostKeyChecking=no -i ~/.ssh/your-key.pem requirements.txt ec2-user@$EC2_IP:/home/ec2-user/

# Run commands on EC2
ssh -o StrictHostKeyChecking=no -i ~/.ssh/your-key.pem ec2-user@$EC2_IP << EOF
cd /home/ec2-user/app
echo "GEMINI_API_KEY=$API_KEY" > .env
pip3 install -r /home/ec2-user/requirements.txt
nohup python3 main.py &
EOF
