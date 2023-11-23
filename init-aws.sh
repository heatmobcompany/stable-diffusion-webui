#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

sudo apt update -y && sudo apt upgrade -y
# install ndvia drivers
# sudo apt autoremove nvidia* --purge
# sudo apt install nvidia-driver-535 -y

# install python lib
sudo apt install -y aria2 lnav
sudo apt install -y libgoogle-perftools4 libtcmalloc-minimal4

pip install --upgrade pip
pip install yq

# create /workspace/logs if not exist
mkdir -p /workspace/logs

# setup sd-service
$SCRIPT_DIR/sd-service.sh

# setup extension
git clone https://github.com/heatmobcompany/sd-webui-controlnet /workspace/stable-diffusion-webui/extensions/sd-webui-controlnet
git clone https://github.com/heatmobcompany/sd-webui-segment-anything /workspace/stable-diffusion-webui/extensions/sd-webui-segment-anything
git clone https://github.com/heatmobcompany/sd-webui-roop /workspace/stable-diffusion-webui/extensions/sd-webui-roop
git clone https://github.com/heatmobcompany/sd-webui-adetailer /workspace/stable-diffusion-webui/extensions/sd-webui-adetailer
git clone https://github.com/heatmobcompany/sd-webui-prompt-all-in-one /workspace/stable-diffusion-webui/extensions/sd-webui-prompt-all-in-one
git clone https://github.com/heatmobcompany/Civitai-Helper /workspace/stable-diffusion-webui/extensions/Civitai-Helper
git clone https://github.com/heatmobcompany/openpose-editor /workspace/stable-diffusion-webui/extensions/openpose-editor
git clone https://github.com/heatmobcompany/stable-diffusion-webui-rembg /workspace/stable-diffusion-webui/extensions/stable-diffusion-webui-rembg

$SCRIPT_DIR/setup-checkpoint.sh all
$SCRIPT_DIR/setup-common.sh

# create and add config.yaml
if [ ! -f /workspace/config.yaml ]; then
    cp /workspace/stable-diffusion-webui/config.yaml /workspace/config.yaml
fi