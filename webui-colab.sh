# #!/bin/bash
ID=$1
GROUP=$2
NGROK='2LMPw5i5nST1VFwmVjnnenjnQju_4Xx6KP2Y1n9bTtHw4t6fW'
if [ -n "$3" ]; then
    NGROK=$3
fi

delimiter="################################################################"

export COMMANDLINE_ARGS="--listen --xformers --enable-insecure-extension-access --api --nowebui --port 7860 --google-id $ID --group $GROUP --ngrok $NGROK --ngrok-region ap" 
for idx in $(seq 1 5)
do
    echo $delimiter
    echo Start program, time = $idx
    echo $delimiter
    python launch.py $COMMANDLINE_ARGS
done
