#!/bin/bash
set -e

# Add repo tool to path
echo "export PATH=/home/docker/bin:$PATH" >> /etc/profile

# Allow docker user to run the build image script
chmod a+x /build_image.sh

# Create ssh dir with correct permissions
SSH_DIR=/home/docker/.ssh
mkdir -p $SSH_DIR
chmod 700 $SSH_DIR
chown docker:docker -R $SSH_DIR
