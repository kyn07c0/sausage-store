#!/bin/bash
set +e
cat > .env_backend <<EOF
BACKEND_VERSION=${BACKEND_VERSION}
SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}
EOF

BLUE_SERVICE="blue"
GREEN_SERVICE="green"

# Find which service is currently active
if docker ps --format "{{.Names}}" | grep -q "$BLUE_SERVICE"; then
  ACTIVE_SERVICE=$BLUE_SERVICE
  INACTIVE_SERVICE=$GREEN_SERVICE
elif docker ps --format "{{.Names}}" | grep -q "$GREEN_SERVICE"; then
  ACTIVE_SERVICE=$GREEN_SERVICE
  INACTIVE_SERVICE=$BLUE_SERVICE
else
  ACTIVE_SERVICE=""
  INACTIVE_SERVICE=$BLUE_SERVICE
fi

echo "Active service: $ACTIVE_SERVICE"
echo "Inactive service: $INACTIVE_SERVICE"

# Start the new environment
echo "Starting inactive $INACTIVE_SERVICE container"
docker-compose pull $INACTIVE_SERVICE || true
docker compose --env-file .env_backend up -d --force-recreate $INACTIVE_SERVICE || true

#docker-compose pull backend || true
#docker-compose --env-file .env_backend up -d --force-recreate green || true
