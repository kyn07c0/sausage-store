#!/bin/bash
set +e
echo ${SPRING_DATA_MONGODB_URI}
cat > .env_backend_report <<EOF
BACKEND_REPORT_VERSION=${BACKEND_REPORT_VERSION}
DB=${SPRING_DATA_MONGODB_URI}
EOF
docker-compose pull backend-report || true
docker-compose --env-file .env_backend_report up -d --force-recreate backend-report || true
