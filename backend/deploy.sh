#!/bin/bash
set +e
cat > .env_backend <<EOF
BACKEND_VERSION=${BACKEND_VERSION}
SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}
EOF

set +xe

BLUE_SERVICE="blue"
GREEN_SERVICE="green"

# Find which service is currently active
if docker ps --format "{{.Names}}" | grep -q "$BLUE_SERVICE"; then
  ACTIVE_SERVICE=$GREEN_SERVICE
  INACTIVE_SERVICE=$BLUE_SERVICE
else 
  ACTIVE_SERVICE=$BLUE_SERVICE
  INACTIVE_SERVICE=$GREEN_SERVICE

echo "Active service: $ACTIVE_SERVICE"
echo "Inactive service: $INACTIVE_SERVICE"
echo "-----------------------------------"

echo "Removing old container: $INACTIVE_SERVICE"
docker-compose rm -f $INACTIVE_SERVICE

# Start inactive service
echo "Start new container: $INACTIVE_SERVICE"
docker-compose pull $INACTIVE_SERVICE || true
docker-compose --env-file .env_backend up -d $INACTIVE_SERVICE
rv=$?
if [ $rv -eq 0 ]; then
    echo "New container \"$NEW_BACKEND\" started"
else
    echo "Docker compose failed with exit code: $rv"
    echo "Aborting..."
    exit 1
fi

echo "Sleeping 5 seconds"
sleep 5
