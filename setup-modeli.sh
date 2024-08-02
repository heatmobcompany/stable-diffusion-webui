#!/usr/bin/env bash

git clone https://github.com/heatmobcompany/sd-webui-controlnet /workspace/stable-diffusion-webui/extensions/sd-webui-controlnet
git clone https://github.com/heatmobcompany/sd-webui-segment-anything /workspace/stable-diffusion-webui/extensions/sd-webui-segment-anything
git clone https://github.com/heatmobcompany/sd-webui-roop /workspace/stable-diffusion-webui/extensions/sd-webui-roop
git clone https://github.com/heatmobcompany/sd-webui-adetailer /workspace/stable-diffusion-webui/extensions/sd-webui-adetailer
git clone https://github.com/heatmobcompany/sd-ootd /workspace/stable-diffusion-webui/extensions/sd-ootd
git clone https://github.com/heatmobcompany/stable-diffusion-webui-rembg /workspace/stable-diffusion-webui/extensions/stable-diffusion-webui-rembg

# setup checkpoint
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/chilloutmix_NiPrunedFp32.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o chilloutmix_NiPrunedFp32.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/kencanmix_v20Beta.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o kencanmix_v20Beta.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/beautifulRealistic_v40.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o beautifulRealistic_v40.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/photon_v1.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o photon_v1.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/cyberrealistic_v40-inpainting.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o cyberrealistic_v40-inpainting.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/vnf19.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o vnf19.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/realisticVisionV60B1_v51VAE_2G.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o realisticVisionV60B1_v51VAE_2G.safetensors

# setup lora
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/vnfs_lr.safetensors -d /workspace/stable-diffusion-webui/models/Lora -o vnfs_lr.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/suanbei_v7-000002.safetensors -d /workspace/stable-diffusion-webui/models/Lora -o suanbei_v7-000002.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/vnman4.safetensors -d /workspace/stable-diffusion-webui/models/Lora -o vnman4.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/bgw.safetensors -d /workspace/stable-diffusion-webui/models/Lora -o bgw.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/chouchou-000005.safetensors -d /workspace/stable-diffusion-webui/models/Lora -o chouchou-000005.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/bg_deco_v.0.2.8-000005.safetensors -d /workspace/stable-diffusion-webui/models/Lora -o bg_deco_v.0.2.8-000005.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/weight_slider-LECO-v1.safetensors -d /workspace/stable-diffusion-webui/models/Lora -o weight_slider-LECO-v1.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/lora_office_3.safetensors -d /workspace/stable-diffusion-webui/models/Lora -o lora_office_3.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/microwaistV05.safetensors -d /workspace/stable-diffusion-webui/models/Lora -o microwaistV05.safetensors
