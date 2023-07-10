#!/bin/bash
set +xe
docker network create -d bridge sausage_network || true
docker login gitlab.praktikum-services.ru:5050 -u $CI_REGISTRY_USER -p $CI_JOB_TOKEN $CIREGISTRY 
docker pull gitlab.praktikum-services.ru:5050/std-017-006/sausage-store/sausage-frontend:latest
docker stop frontend || true
docker rm frontend || true
set -e
docker run -d --name frontend \	
    --network=sausage_network \
    --restart always \
    --pull always \
    gitlab.praktikum-services.ru:5050/std-017-006/sausage-store/sausage-frontend:latest
