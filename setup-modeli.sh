#!/usr/bin/env bash

if ! command -v aria2c &> /dev/null; then
    echo "aria2c is not installed. Installing it..."
    apt update
    apt install -y aria2
fi

id=$1
url=$2

# downloadextension
git clone https://github.com/heatmobcompany/sd-webui-controlnet /workspace/stable-diffusion-webui/extensions/sd-webui-controlnet
git clone https://github.com/heatmobcompany/sd-webui-segment-anything /workspace/stable-diffusion-webui/extensions/sd-webui-segment-anything
git clone https://github.com/heatmobcompany/sd-webui-roop /workspace/stable-diffusion-webui/extensions/sd-webui-roop
git clone https://github.com/heatmobcompany/sd-webui-adetailer /workspace/stable-diffusion-webui/extensions/sd-webui-adetailer

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
"${SCRIPT_DIR}/setup-modeli-model.sh" $1 $2
"${SCRIPT_DIR}/setup-common.sh"
