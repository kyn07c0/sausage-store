#!/bin/bash
set +e
cat > .env <<EOF
SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}
SPRING_DATA_MONGODB_URI=${SPRING_DATA_MONGODB_URI}
EOF
docker network create -d bridge sausage_network || true
docker pull gitlab.praktikum-services.ru:5050/std-017-006/sausage-store/backend-report:latest
docker stop backend-report || true
docker rm backend-report || true
set -e
docker run -d --name backend-report \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    gitlab.praktikum-services.ru:5050/std-017-006/sausage-store/backend-report:latest
