#!/bin/bash
set +e
cat > .env_backend <<EOF
VERSION=${VERSION}
SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}
EOF
docker-compose stop backend || true
docker-compose rm -f backend || true
docker-compose pull backend || true
docker-compose --env-file .env_backend up -d backend || true
