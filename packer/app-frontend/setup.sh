#!/bin/bash
set -e

sudo systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent.service
sudo systemctl start snap.amazon-ssm-agent.amazon-ssm-agent.service

sudo apt-get update -y

sudo apt-get install -y nginx

sudo mkdir -p /var/www/html
sudo rm -rf /var/www/html/*
sudo cp -r /tmp/app-dist/* /var/www/html/

sudo cp /tmp/nginx.conf /etc/nginx/sites-available/default

sudo chown -R www-data:www-data /var/www/html
