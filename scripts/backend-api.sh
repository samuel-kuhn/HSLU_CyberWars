#!/bin/bash

docker build -t php-api "backend-api/Management API/Docker/"

docker compose -f /home/harald/backend-api/docker-compose.yml up -d