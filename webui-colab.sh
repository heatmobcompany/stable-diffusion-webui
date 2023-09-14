# #!/bin/bash
ID=$1
GROUP=$2

delimiter="################################################################"

export COMMANDLINE_ARGS="--listen --xformers --enable-insecure-extension-access --api --nowebui --port 7860 --google-id $ID --group $GROUP --cloudflared" 
for idx in $(seq 1 5)
do
    echo $delimiter
    echo Start program, time = $idx
    echo $delimiter
    python launch.py $COMMANDLINE_ARGS
done
