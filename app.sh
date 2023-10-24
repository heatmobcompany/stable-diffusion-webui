#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
timestamp=$(date +'%Y_%m_%d__%H_%M')
log_file="/workspace/${timestamp}.log"

# Run the first script
echo "Updating source code to latest version"
$SCRIPT_DIR/update.sh

# Run the second script, logging its output to both stdout and the log file
echo "Starting the app"
$SCRIPT_DIR/webui.sh | tee "$log_file"
