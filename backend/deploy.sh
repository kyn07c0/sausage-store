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
echo "-----------------------------------"

# Start the new environment
echo "Starting inactive $INACTIVE_SERVICE container"
docker-compose pull $INACTIVE_SERVICE || true
docker compose --env-file .env_backend up -d --force-recreate $INACTIVE_SERVICE || true

echo "Wait startup service $INACTIVE_SERVICE"
for((i=1; i<=10; i++)); do
  CONTAINER_IP=$(docker inspect --format='{{range $key, $value := .NetworkSettings.Networks}}{{if eq $key "'"$TRAEFIK_NETWORK"'"}}{{$value.IPAddress}}{{end}}{{end}}' "$INACTIVE_SERVICE" || true)
  if [[ -z "$CONTAINER_IP" ]]; then
    # The docker inspect command failed, so sleep for a bit and retry
    sleep "$SLEEP_INTERVAL"
    continue
  fi

  HEALTH_CHECK_URL="http://$CONTAINER_IP:8080/actuator/health"
  # N.B.: We use docker to execute curl because on macOS we are unable to directly access the docker-managed Traefik network.
  if docker run --net $TRAEFIK_NETWORK --rm curlimages/curl:8.00.1 --fail --silent "$HEALTH_CHECK_URL" >/dev/null; then
    echo "$INACTIVE_SERVICE is healthy"
    break
  fi

  sleep "$SLEEP_INTERVAL"
done


#docker-compose pull backend || true
#docker-compose --env-file .env_backend up -d --force-recreate green || true
