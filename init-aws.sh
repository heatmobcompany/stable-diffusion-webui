#!/usr/bin/env bash

### Need install these command the first time 
# sudo apt-get update -y
# sudo apt-get upgrade -y linux-aws
# sudo reboot

# install ndvia drivers
sudo apt update -y && sudo apt upgrade -y
sudo apt autoremove nvidia* --purge
sudo apt install nvidia-driver-535 -y

# install python lib
sudo apt install -y python3.10-venv python3-pip aria2 lnav
sudo apt install -y libgoogle-perftools4 libtcmalloc-minimal4

# install python toolkit
sudo apt-get install -y unzip gcc make linux-headers-$(uname -r)
cd
wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run
sudo sh cuda_11.8.0_520.61.05_linux.run --silent --override --toolkit

# reboot to apply changes
sudo reboot
