#!/bin/bash
set +e
cat > .env_frontend <<EOF
FRONTEND_VERSION=${FRONTEND_VERSION}
EOF
#docker-compose stop frontend || true
#docker-compose rm -f frontend || true
docker-compose pull frontend || true
docker-compose up -d --force-recreate frontend || true
#docker-compose up -d frontend || true
