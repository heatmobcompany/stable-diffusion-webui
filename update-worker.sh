#!/bin/bash

cd /workspace/sd-worker || exit
docker compose pull
curl http://172.17.0.1:3003/stop-worker
docker compose down
docker compose up -d