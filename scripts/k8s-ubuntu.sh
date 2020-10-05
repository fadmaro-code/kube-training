#!/bin/bash
# kubernetes installation script for ubuntu
# Date: October 3 2020

printf "%s\n" "Adding signing key"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

printf "%s\n" "Adding Xenial k8s repo"
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

printf "%s\n" "Installing kubeadm"
sudo apt install -y kubeadm
