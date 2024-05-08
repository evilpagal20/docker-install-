#!/bin/bash

# Check if the OS is CentOS or Red Hat
if [ -f /etc/redhat-release ]; then
    echo "Detected CentOS or Red Hat Linux"
    sudo yum install -y docker

# Check if the OS is Ubuntu or Debian-based
elif [ -f /etc/os-release ]; then
    os=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
    if [[ $os == *"Ubuntu"* ]] || [[ $os == *"Debian"* ]]; then
        echo "Detected Ubuntu or Debian-based Linux"
        sudo apt-get update
        sudo apt-get install -y docker.io
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi

else
    echo "Unsupported Linux distribution"
    exit 1
fi

# Start Docker service
sudo systemctl start docker

# Create image of Ubuntu
sudo docker pull ubuntu

# Tag the Ubuntu image
sudo docker tag ubuntu evilpagal/ubuntu

# Push Docker image to Docker Hub
sudo docker login
sudo docker push evilpagal/ubuntu

# Pull Docker image from Docker Hub
sudo docker pull evilpagal/ubuntu

# Create container and install required packages
sudo docker run -it --name mycontainer evilpagal/ubuntu /bin/bash -c \
    "apt-get update && apt-get install -y apache2 git wget iputils-ping && apt-get clean && rm -rf /var/lib/apt/lists/*"

# Start the container
sudo docker start mycontainer

# Attach to the container
sudo docker exec -it mycontainer /bin/bash
