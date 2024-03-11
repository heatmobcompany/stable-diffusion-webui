#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ "$1" == "stop" ]; then
    echo "Stop the app"
    $SCRIPT_DIR/job_healthcheck.sh remove
    exit 0
fi

# Run the first script
echo "Updating source code to latest version"
$SCRIPT_DIR/update.sh

$SCRIPT_DIR/job_healthcheck.sh

echo "Starting the app"
$SCRIPT_DIR/webui.sh --api-log --skip-prepare-environment --disable-safe-unpickle

$SCRIPT_DIR/job_healthcheck.sh remove
