#!/bin/bash

cd /workspace/sd-worker || exit
docker compose pull
docker compose down
sudo service sd-service restart
sleep 60
docker compose up -d