#!/bin/bash
cd /home/ec2-user/ai-resume-sorter
nohup python3 app.py > output.log 2>&1 &
