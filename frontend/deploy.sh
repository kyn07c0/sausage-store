#!/bin/bash
set +e
cat > .env_frontend <<EOF
VERSION=${VERSION}
EOF
docker-compose stop frontend || true
docker-compose rm -f frontend || true
docker-compose pull frontend || true
docker-compose up -d frontend || true
