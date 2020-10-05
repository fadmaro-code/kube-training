#!/bin/bash
# Docker installation script for ubuntu
# Source: https://docs.docker.com/engine/install/ubuntu/
# Date: October 3 2020

printf "%s\n" "[================== Updating system ===================]"
sudo apt update

printf "%s\n" "[================== Installing certificates ==================]"
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

printf "%s\n" "[================== Adding gpg key ==================]"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

printf "%s\n" "[================== Key validation ==================]"
sudo apt-key fingerprint 0EBFCD88

printf "%s\n" "[================== Adding repository ==================]"
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

printf "%s\n" "[================== Installing docker ==================]"
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
