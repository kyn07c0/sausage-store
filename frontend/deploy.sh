#!/bin/bash
set +xe
docker network create -d bridge sausage_network || true
docker pull gitlab.praktikum-services.ru:5050/std-017-006/sausage-store/sausage-frontend:latest
docker stop sausage-frontend || true
docker rm sausage-frontend || true
set -e
docker run -d --name sausage-frontend \
	--network=sausage_network \
	--restart always \
	--pull always \
	-p 8080:80 \
	gitlab.praktikum-services.ru:5050/std-017-006/sausage-store/sausage-frontend:latest
