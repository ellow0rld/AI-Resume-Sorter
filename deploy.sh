#!/bin/bash

EC2_IP=$1
SSH_KEY_PATH=$2
GEMINI_API_KEY=$3

# Example: copying files and running remote commands
scp -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no -r app ec2-user@"$EC2_IP":~/app
ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no ec2-user@"$EC2_IP" << EOF
    export GEMINI_API_KEY="$GEMINI_API_KEY"
    cd ~/app
    pip install -r requirements.txt
    nohup python3 app.py &
EOF
