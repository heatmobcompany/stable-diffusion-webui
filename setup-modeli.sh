#!/usr/bin/env bash

id=""
group=Majicmix
type="fashion_app_pod"
url=""

# Parse command line options
while [[ $# -gt 0 ]]; do
  case "$1" in
    -i | --id)
      id="$2"
      shift 2
      ;;
    -g | --group)
      group="$2"
      shift 2
      ;;
    -t | --type)
      type="$2"
      shift 2
      ;;
    -u | --url)
      url="$2"
      shift 2
      ;;
    *)
      echo "Invalid option: $1"
      exit 1
      ;;
  esac
done

echo id:$id
echo group:$group
echo type:$type
echo url:$url

# setup extension
git clone https://github.com/heatmobcompany/sd-webui-controlnet /workspace/stable-diffusion-webui/extensions/sd-webui-controlnet
git clone https://github.com/heatmobcompany/sd-webui-segment-anything /workspace/stable-diffusion-webui/extensions/sd-webui-segment-anything
git clone https://github.com/heatmobcompany/sd-webui-roop /workspace/stable-diffusion-webui/extensions/sd-webui-roop
git clone https://github.com/heatmobcompany/sd-webui-adetailer /workspace/stable-diffusion-webui/extensions/sd-webui-adetailer
# git clone https://github.com/heatmobcompany/sd-webui-prompt-all-in-one /workspace/stable-diffusion-webui/extensions/sd-webui-prompt-all-in-one
# git clone https://github.com/heatmobcompany/Civitai-Helper /workspace/stable-diffusion-webui/extensions/Civitai-Helper
# git clone https://github.com/heatmobcompany/openpose-editor /workspace/stable-diffusion-webui/extensions/openpose-editor
# git clont https://github.com/heatmobcompany/stable-diffusion-webui-rembg /workspace/stable-diffusion-webui/extensions/stable-diffusion-webui-rembg

# setup checkpoint
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/sinkinai/majicMIX-realistic-v5/resolve/main/majicmixRealistic_v5.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o majicmixRealistic_v5.safetensors &\
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/cyberrealistic_v32.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o cyberrealistic_v32.safetensors &\
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/chilloutmix_NiPrunedFp32.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o chilloutmix_NiPrunedFp32.safetensors &\
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/kencanmix_v20Beta.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o kencanmix_v20Beta.safetensors &\
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/beautifulRealistic_v40.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o beautifulRealistic_v40.safetensors &\
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/photon_v1.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o photon_v1.safetensors

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
"${SCRIPT_DIR}/setup-checkpoint.sh" $group
"${SCRIPT_DIR}/setup-common.sh"

# Update webui-user.sh
file_path="./webui-user.sh"
if [ -n "$group" ]; then
    sed -i "s|^GROUP=.*|GROUP=$group|" "$file_path"
fi
if [ -n "$type" ]; then
    sed -i "s|^TYPE=.*|TYPE=$type|" "$file_path"
fi
if [ -n "$id" ]; then
    sed -i "s|^ID=.*|ID=$id|" "$file_path"
fi
if [ -n "$url" ]; then
    sed -i "s|^URL=.*|URL=$url|" "$file_path"
fi
