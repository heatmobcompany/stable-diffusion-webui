# #!/bin/bash
ID=$1
GROUP=$2
TYPE=''
URL=''
delimiter="################################################################"

export COMMANDLINE_ARGS="--listen --xformers --enable-insecure-extension-access --theme dark --gradio-queue --api --google-id $ID --group $GROUP"
for idx in $(seq 1 5)
do
    echo $delimiter
    echo Start program, time = $idx
    echo $delimiter
    python launch.py $COMMANDLINE_ARGS
done
