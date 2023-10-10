#!/usr/bin/env bash

# install ndvia drivers
sudo apt update -y && sudo apt upgrade -y
sudo apt autoremove nvidia* --purge
sudo apt install ubuntu-drivers-common -y
sudo ubuntu-drivers autoinstall

# install cuda toolkit
sudo apt install nvidia-cuda-toolkit -y
sudo apt install -y python3.10-venv python3-pip aria2

# reboot to apply drivers
sudo reboot