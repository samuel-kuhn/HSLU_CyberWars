#!/bin/bash

docker build -t backend-api "backend-api/Management API/Docker/"

docker compose -f /home/harald/backend-api/docker-compose.yml up -d

docker exec -it Management_API sh -c "sqlite3 /usr/src/api/data/employees.db \"CREATE TABLE IF NOT EXISTS flags (ctf_flag TEXT);\""
docker exec -it Management_API sh -c "sqlite3 /usr/src/api/data/employees.db \"INSERT INTO flags (ctf_flag) VALUES ('flag{n3v3r_f0rg3t_t0_ch3ck_all_tabl3s}');\""
