#!/usr/bin/env bash

if ! command -v aria2c &> /dev/null; then
    echo "aria2c is not installed. Installing it..."
    sudo apt update
    sudo apt install -y aria2
fi

# Default values
id=$1
url=$2
group="Majicmix"
type="fashion_app_pod"

aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/sinkinai/majicMIX-realistic-v5/resolve/main/majicmixRealistic_v5.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o majicmixRealistic_v5.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/cyberrealistic_v32.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o cyberrealistic_v32.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/chilloutmix_NiPrunedFp32.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o chilloutmix_NiPrunedFp32.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/kencanmix_v20Beta.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o kencanmix_v20Beta.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/beautifulRealistic_v40.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o beautifulRealistic_v40.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/photon_v1.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o photon_v1.safetensors

# Update webui-user.sh
file_path="./webui-user.sh"
sed -i "s|^GROUP=.*|GROUP=$group|" "$file_path"
sed -i "s|^TYPE=.*|TYPE=$type|" "$file_path"
if [ -n "$id" ]; then
    sed -i "s|^ID=.*|ID=$id|" "$file_path"
fi
if [ -n "$url" ]; then
    sed -i "s|^URL=.*|URL=$url|" "$file_path"
fi
