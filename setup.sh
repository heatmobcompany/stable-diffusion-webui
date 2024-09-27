#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

# install python lib
sudo apt install -y aria2 lnav
sudo apt install -y libgoogle-perftools4 libtcmalloc-minimal4

# setup extension
git clone https://github.com/heatmobcompany/sd-webui-controlnet /workspace/stable-diffusion-webui/extensions/sd-webui-controlnet
git clone https://github.com/heatmobcompany/sd-webui-segment-anything /workspace/stable-diffusion-webui/extensions/sd-webui-segment-anything
git clone https://github.com/heatmobcompany/sd-webui-roop /workspace/stable-diffusion-webui/extensions/sd-webui-roop
git clone https://github.com/heatmobcompany/sd-webui-adetailer /workspace/stable-diffusion-webui/extensions/sd-webui-adetailer
git clone https://github.com/heatmobcompany/sd-webui-openpose-editor /workspace/stable-diffusion-webui/extensions/sd-webui-openpose-editor
git clone https://github.com/heatmobcompany/sd-ootd /workspace/stable-diffusion-webui/extensions/sd-ootd

$SCRIPT_DIR/setup-common.sh
$SCRIPT_DIR/setup-modeli.sh
