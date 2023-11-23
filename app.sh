#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Run the first script
echo "Updating source code to latest version"
$SCRIPT_DIR/update.sh

$SCRIPT_DIR/job_healthcheck.sh

echo "Starting the app"
$SCRIPT_DIR/webui.sh

$SCRIPT_DIR/job_healthcheck.sh remove
