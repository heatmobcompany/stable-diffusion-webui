#!/bin/bash
#########################################################
# Uncomment and change the variables below to your need:#
#########################################################

# Group: Majicmix, RevAnimated, Meinamix, RealisticVision, CosplayMix, ...
ID=
GROUP=
TYPE=
URL=

if [ -z "$ID" ] || [ "$ID" = '""' ]; then
    ID=$(cat /workspace/config.yaml | yq .app.server_id)
fi

if [ -z "$ID" ] || [ "$ID" = '""' ]; then
    ID=$(curl ifconfig.me --silent)
fi

if [ -z "$TYPE" ] || [ "$TYPE" = '""' ]; then
    TYPE=$(cat /workspace/config.yaml | yq .app.server_type)
fi

if [ -z "$GROUP" ] || [ "$GROUP" = '""' ]; then
    GROUP=$(cat /workspace/config.yaml | yq .app.models)
fi

if [ -z "$URL" ] || [ "$URL" = '""' ]; then
    URL=$(cat /workspace/config.yaml | yq .app.url)
fi

if [ -z "$URL" ] || [ "$URL" = '""' ]; then
    URL="http://$(curl ifconfig.me --silent):3000"
fi

# Install directory without trailing slash
install_dir="/workspace"

# Name of the subdirectory
#clone_dir="stable-diffusion-webui"

# Commandline arguments for webui.py, for example: export COMMANDLINE_ARGS="--medvram --opt-split-attention"
export COMMANDLINE_ARGS="--log-file /workspace/logs/app.logging.log --xformers --opt-sdp-attention --port 3000 --listen --enable-insecure-extension-access --api --google-id $ID --group $GROUP --type $TYPE --share-url $URL"
#export XFORMERS_PACKAGE="xformers==0.0.17.dev447"

# python3 executable
#python_cmd="python3"

# git executable
#export GIT="git"

# python3 venv without trailing slash (defaults to ${install_dir}/${clone_dir}/venv)
venv_dir="/workspace/venv"

# script to launch to start the app
#export LAUNCH_SCRIPT="launch.py"

# install command for torch
#export TORCH_COMMAND="pip install torch==1.12.1+cu113 --extra-index-url https://download.pytorch.org/whl/cu113"

# Requirements file to use for stable-diffusion-webui
#export REQS_FILE="requirements_versions.txt"

# Fixed git repos
#export K_DIFFUSION_PACKAGE=""
#export GFPGAN_PACKAGE=""

# Fixed git commits
#export STABLE_DIFFUSION_COMMIT_HASH=""
#export CODEFORMER_COMMIT_HASH=""
#export BLIP_COMMIT_HASH=""

# Uncomment to enable accelerated launch
#export ACCELERATE="True"

# Uncomment to disable TCMalloc
#export NO_TCMALLOC="True"

###########################################
