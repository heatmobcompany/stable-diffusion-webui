#!/usr/bin/env bash

# get heatmob repo
cd /workspace/stable-diffusion-webui
git remote add heatmob https://github.com/heatmobcompany/stable-diffusion-webui
git checkout fashion_pod

# downloadextension
git clone https://github.com/heatmobcompany/sd-webui-segment-anything /workspace/stable-diffusion-webui/extensions/sd-webui-segment-anything
git clone https://github.com/heatmobcompany/sd-webui-roop /workspace/stable-diffusion-webui/extensions/sd-webui-roop
git clone https://github.com/heatmobcompany/sd-webui-adetailer /workspace/stable-diffusion-webui/extensions/sd-webui-adetailer

# download segment anything models
wget -P /workspace/stable-diffusion-webui/models/sam https://huggingface.co/spaces/abhishek/StableSAM/resolve/main/sam_vit_h_4b8939.pth
wget -P /workspace/stable-diffusion-webui/extensions/sd-webui-segment-anything/models/grounding-dino https://huggingface.co/ShilongLiu/GroundingDINO/resolve/main/groundingdino_swint_ogc.pth

# download roop models
wget -P /workspace/stable-diffusion-webui/models/roop https://huggingface.co/henryruhs/roop/resolve/main/inswapper_128.onnx

# download adetailer models
wget -P /workspace/stable-diffusion-webui/models/adetailer https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8n.pt
