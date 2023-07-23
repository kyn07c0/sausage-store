#!/bin/bash
set +e
cat > .env_backend_report <<EOF
BACKEND_REPORT_VERSION=${BACKEND_REPORT_VERSION}
SPRING_DATA_MONGODB_URI='${SPRING_DATA_MONGODB_URI}'
EOF
docker-compose stop backend-report || true
docker-compose rm -f backend-report || true
docker-compose pull backend-report || true
docker-compose --env-file .env_backend_report up -d backend-report || true
