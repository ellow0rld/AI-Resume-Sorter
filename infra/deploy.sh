#!/bin/bash

# Exit on error
set -e

echo "[INFO] Deploying Resume Ranking Flask App..."

cd /home/ec2-user/resume-ranking-app

echo "GEMINI_API_KEY=$GEMINI_API_KEY" > .env
echo "[INFO] .env file created."

pip3 install -r requirements.txt

nohup python3 app.py > flask.log 2>&1 &

echo "[INFO] Flask app started successfully."
