#!/bin/bash
V_DOCKER_COMPOSE_URL=https://github.com/docker/compose/releases/download/v2.11.2/docker-compose-linux-x86_64
curl -SL "${V_DOCKER_COMPOSE_URL}" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose
