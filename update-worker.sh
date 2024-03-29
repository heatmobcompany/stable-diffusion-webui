#!/bin/bash

cd /workspace/sd-worker || exit
docker compose pull
docker compose down
docker compose up -d