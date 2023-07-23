#!/bin/bash
set +e
cat > .env <<EOF
SPRING_DATA_MONGODB_URI=${SPRING_DATA_MONGODB_URI}
EOF
docker-compose stop backend-report || true
docker-compose rm -f backend-report || true
docker-compose pull backend-report || true
docker-compose up -d backend-report || true

