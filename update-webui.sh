#!/bin/bash

cd /workspace/sd-worker || exit
docker compose pull
sudo service sd-service restart
sleep 1
docker compose down
docker compose up -d