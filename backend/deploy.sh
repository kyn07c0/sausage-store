#!/bin/bash
set +e
cat > .env_backend <<EOF
BACKEND_VERSION=${BACKEND_VERSION}
SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}
EOF
docker-compose pull backend || true
docker-compose --scale backend=3 --env-file .env_backend up -d --force-recreate backend || true
