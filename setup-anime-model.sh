#!/usr/bin/env bash

if ! command -v aria2c &> /dev/null; then
    echo "aria2c is not installed. Installing it..."
    apt update
    apt install -y aria2
fi

# Default values
id=$1
url=$2
group="RevAnimated"
type="anime_app"

aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/rev-animated/resolve/main/revAnimated_v11.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o revAnimated_v11.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/meinamix_meinaV10.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o meinamix_meinaV10.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/toonyou_beta6.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o toonyou_beta6.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/dreamshaper_8.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o dreamshaper_8.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/KizukiAnimeCivitaiv3.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o KizukiAnimeCivitaiv3.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/KizukiAnimeCivitaiv2.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o KizukiAnimeCivitaiv2.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/KizukiAnimeCivitaiv1.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o KizukiAnimeCivitaiv1.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/flat2DAnimerge_v30.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o flat2DAnimerge_v30.safetensors

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
