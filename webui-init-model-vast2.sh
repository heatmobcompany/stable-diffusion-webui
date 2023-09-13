#!/usr/bin/env bash

apt update
apt install -y aria2

# Majicmix,Meinamix,XXMix9realistic,RevAnimated,ChilloutMix
# Majicmix,SDVN1Real,ToonYou,CyberRealistic,RealisticVision,GhostMix,KenCanMix
# Majicmix
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/sinkinai/majicMIX-realistic-v5/resolve/main/majicmixRealistic_v5.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o majicmixRealistic_v5.safetensors

# # Meinamix
# aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/meinamix_meinaV10.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o meinamix_meinaV10.safetensors

# # XXMix9realistic
# aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/xxmix9realistic_v40.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o xxmix9realistic_v40.safetensors

# # RevAnimated
# aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/ckpt/rev-animated/resolve/main/revAnimated_v11.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o revAnimated_v11.safetensors

# # ChilloutMix
# aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/chilloutmix_NiPrunedFp32.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o chilloutmix_NiPrunedFp32.safetensors

# SDVN1Real
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/sdvn1Real_origin.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o sdvn1Real_origin.safetensors

# ToonYou
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/toonyou_beta6.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o toonyou_beta6.safetensors

# CyberRealistic
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/cyberrealistic_v32.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o cyberrealistic_v32.safetensors

# RealisticVision
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/realisticVisionV30_v30VAE.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o realisticVisionV30_v30VAE.safetensors

# GhostMix
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/ghostmix_v20Bakedvae.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o ghostmix_v20Bakedvae.safetensors

# KenCanMix
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/annh/general/resolve/main/kencanmix_v20Beta.safetensors -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o kencanmix_v20Beta.safetensors

