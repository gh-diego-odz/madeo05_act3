#!/bin/bash
set -e

sudo systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
sudo systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service

sudo apt-get update -y

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo npm install -g pm2

sudo mkdir -p /opt/app
sudo cp -r /tmp/app-backend/* /opt/app/

cd /opt/app
sudo npm ci --production

sudo pm2 startup systemd -u ubuntu --hp /home/ubuntu

sudo chown -R ubuntu:ubuntu /opt/app
