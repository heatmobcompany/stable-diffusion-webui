#!/usr/bin/env bash

id=""
group=Majicmix,Meinamix,XXMix9realistic,RevAnimated,ChilloutMix,Counterfeit,MechaMix,DreamShaper,ChildrenStories,XSarchitectural,SDVN1Real,ToonYou,CyberRealistic,RealisticVision,GhostMix,KenCanMix,dvArch,NightSkyYOZORAStyle,AZovyaRPGArtistTools
type="webui"
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
git clone https://github.com/heatmobcompany/sd-webui-prompt-all-in-one /workspace/stable-diffusion-webui/extensions/sd-webui-prompt-all-in-one
git clone https://github.com/heatmobcompany/Civitai-Helper /workspace/stable-diffusion-webui/extensions/Civitai-Helper
git clone https://github.com/heatmobcompany/openpose-editor /workspace/stable-diffusion-webui/extensions/openpose-editor
git clont https://github.com/heatmobcompany/stable-diffusion-webui-rembg /workspace/stable-diffusion-webui/extensions/stable-diffusion-webui-rembg

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
