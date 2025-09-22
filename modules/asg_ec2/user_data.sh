#!/bin/bash
set -e
# Basics
yum update -y || true
amazon-linux-extras install epel -y || true
yum install -y amazon-efs-utils jq python3 git

# Install SSM agent (often preinstalled on AL2)
systemctl enable amazon-ssm-agent || true
systemctl start amazon-ssm-agent || true

# Tag role for dynamic inventory
echo "Role=wordpress" >> /etc/environment

# Mount EFS (wp-content)
mkdir -p /var/www/html/wp-content
echo "${efs_id}:/ /var/www/html/wp-content efs _netdev,tls 0 0" >> /etc/fstab
mount -a || true

# Allow Ansible Python
alternatives --set python /usr/bin/python3 || true
