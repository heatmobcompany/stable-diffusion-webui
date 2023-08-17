#!/usr/bin/env bash

# get heatmob repo
# cd /workspace/stable-diffusion-webui
# git remote add heatmob git@github.com:heatmobcompany/stable-diffusion-webui.git
# git checkout fashion_pod

apt update
apt install -y aria2

# downloadextension
git clone https://github.com/heatmobcompany/sd-webui-segment-anything /workspace/stable-diffusion-webui/extensions/sd-webui-segment-anything
git clone https://github.com/heatmobcompany/sd-webui-roop /workspace/stable-diffusion-webui/extensions/sd-webui-roop
git clone https://github.com/heatmobcompany/sd-webui-adetailer /workspace/stable-diffusion-webui/extensions/sd-webui-adetailer

# Model checkpoint
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/digiplay/majicMIX_realistic_v6/resolve/main/majicmixRealistic_v6.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o majicmixRealistic_v6.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/rev-animated/resolve/main/revAnimated_v11.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o revAnimated_v11.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/realisticVisionV30_v30VAE.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o realisticVisionV30_v30VAE.safetensors

# Controlnet
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile.pth -d /workspace/stable-diffusion-webui/extensions/control/models -o control_v11f1e_sd15_tile.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11e_sd15_ip2p.pth -d /workspace/stable-diffusion-webui/extensions/control/models -o control_v11e_sd15_ip2p.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11e_sd15_shuffle.pth -d /workspace/stable-diffusion-webui/extensions/control/models -o control_v11e_sd15_shuffle.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.pth -d /workspace/stable-diffusion-webui/extensions/control/models -o control_v11f1p_sd15_depth.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.pth -d /workspace/stable-diffusion-webui/extensions/control/models -o control_v11p_sd15_canny.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint.pth -d /workspace/stable-diffusion-webui/extensions/control/models -o control_v11p_sd15_inpaint.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart.pth -d /workspace/stable-diffusion-webui/extensions/control/models -o control_v11p_sd15_lineart.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_mlsd.pth -d /workspace/stable-diffusion-webui/extensions/control/models -o control_v11p_sd15_mlsd.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_normalbae.pth -d /workspace/stable-diffusion-webui/extensions/control/models -o control_v11p_sd15_normalbae.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.pth -d /workspace/stable-diffusion-webui/extensions/control/models -o control_v11p_sd15_openpose.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_scribble.pth -d /workspace/stable-diffusion-webui/extensions/control/models -o control_v11p_sd15_scribble.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg.pth -d /workspace/stable-diffusion-webui/extensions/control/models -o control_v11p_sd15_seg.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_softedge.pth -d /workspace/stable-diffusion-webui/extensions/control/models -o control_v11p_sd15_softedge.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime.pth -d /workspace/stable-diffusion-webui/extensions/control/models -o control_v11p_sd15s2_lineart_anime.pth

# Lora
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/Naruto.safetensors -d /workspace/stable-diffusion-webui/models/Lora -o Naruto.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/Naruto.jpeg -d /workspace/stable-diffusion-webui/models/Lora -o Naruto.jpeg
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/foodphoto.safetensors -d /workspace/stable-diffusion-webui/models/Lora -o foodphoto.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/foodphoto.jpeg -d /workspace/stable-diffusion-webui/models/Lora -o foodphoto.jpeg
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/kda_v3.safetensors -d /workspace/stable-diffusion-webui/models/Lora -o kda_v3.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/kda_v3.jpeg -d /workspace/stable-diffusion-webui/models/Lora -o kda_v3.jpeg
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/3DMM_V12.safetensors -d /workspace/stable-diffusion-webui/models/Lora -o 3DMM_V12.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/3DMM_V12.jpeg -d /workspace/stable-diffusion-webui/models/Lora -o 3DMM_V12.jpeg
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/makina69_rose_v1.0.safetensors -d /workspace/stable-diffusion-webui/models/Lora -o makina69_rose_v1.0.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/makina69_rose_v1.0.jpeg -d /workspace/stable-diffusion-webui/models/Lora -o makina69_rose_v1.0.jpeg
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/sontung-000006.safetensors -d /workspace/stable-diffusion-webui/models/Lora -o sontung-000006.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/sontung-000006.jpeg -d /workspace/stable-diffusion-webui/models/Lora -o sontung-000006.jpeg
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/ngoctrinh-000008.safetensors -d /workspace/stable-diffusion-webui/models/Lora -o ngoctrinh-000008.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/ngoctrinh-000008.jpeg -d /workspace/stable-diffusion-webui/models/Lora -o ngoctrinh-000008.jpeg
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/Amee_V12.safetensors -d /workspace/stable-diffusion-webui/models/Lora -o Amee_V12.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/Amee_V12.jpeg -d /workspace/stable-diffusion-webui/models/Lora -o Amee_V12.jpeg
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/embed/upscale/resolve/main/4x-UltraSharp.pth -d /workspace/stable-diffusion-webui/models/ESRGAN -o 4x-UltraSharp.pth

# Roop
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/henryruhs/roop/resolve/main/inswapper_128.onnx -d /workspace/stable-diffusion-webui/models/roop -o inswapper_128.onnx

# Adetailer
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8n.pt -d /workspace/stable-diffusion-webui/models/adetailer -o face_yolov8n.pt
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8s.pt -d /workspace/stable-diffusion-webui/models/adetailer -o face_yolov8s.pt
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/Bingsu/adetailer/resolve/main/hand_yolov8n.pt -d /workspace/stable-diffusion-webui/models/adetailer -o hand_yolov8n.pt
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8n-seg.pt -d /workspace/stable-diffusion-webui/models/adetailer -o person_yolov8n-seg.pt
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8s-seg.pt -d /workspace/stable-diffusion-webui/models/adetailer -o person_yolov8s-seg.pt

# Segment anything
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/spaces/abhishek/StableSAM/resolve/main/sam_vit_h_4b8939.pth -d /workspace/stable-diffusion-webui/models/sam -o sam_vit_h_4b8939.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ShilongLiu/GroundingDINO/resolve/main/groundingdino_swint_ogc.pth -d /workspace/stable-diffusion-webui/extensions/sd-webui-segment-anything/models/grounding-dino -o groundingdino_swint_ogc.pth

