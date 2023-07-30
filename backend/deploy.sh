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
else docker ps --format "{{.Names}}" | grep -q "$GREEN_SERVICE"; then
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
    echo "New \"$NEW_BACKEND\" container started"
else
    echo "Docker compose failed with exit code: $rv"
    echo "Aborting..."
    exit 1
fi

echo "Sleeping 5 seconds"
sleep 5

#echo "Wait startup service $INACTIVE_SERVICE"
#for((i=1; i<=10; i++)); do
#  CONTAINER_IP=$(docker inspect --format='{{range $key, $value := .NetworkSettings.Networks}}{{if eq $key "'"sausage-store_sausage-store"'"}}{{$value.IPAddress}}{{end}}{{end}}' "$INACTIVE_SERVICE" || true)
#  if [[ -z "$CONTAINER_IP" ]]; then
#    sleep 5
#    continue
#  fi

#  HEALTH_CHECK_URL="http://$CONTAINER_IP:8081/actuator/health"
#  echo "HEALTH_CHECK_URL: $HEALTH_CHECK_URL"
#  if docker run --net sausage-store_sausage-store --rm curlimages/curl:8.00.1 --fail --silent "$HEALTH_CHECK_URL" >/dev/null; then
#    echo "$INACTIVE_SERVICE is healthy"
#    break
#  fi

#  sleep 5
#done

# If the new environment is not healthy within the timeout, stop it and exit with an error
#echo "Check new container is run."
#if ! docker run --net sausage-store_sausage-store --rm curlimages/curl:8.00.1 --fail --silent "$HEALTH_CHECK_URL" >/dev/null; then
#  echo "$INACTIVE_SERVICE did not become healthy within 60 seconds"
#  docker-compose down $INACTIVE_SERVICE
#  exit 1
#fi

# Check that Traefik recognizes the new container
#echo "Checking if Traefik recognizes $INACTIVE_SERVICE..."
#for ((i=1; i<=10; i++)); do
#  TRAEFIK_SERVER_STATUS=$(curl --fail --silent "$TRAEFIK_API_URL" | jq --arg container_ip "http://$CONTAINER_IP:8081" '.[] | select(.type == "loadbalancer") | select(.serverStatus[$container_ip] == "UP") | .serverStatus[$container_ip]')
#  if [[ -n "$TRAEFIK_SERVER_STATUS" ]]; then
#    echo "Traefik recognizes $INACTIVE_SERVICE as healthy"
#    break
#  fi

#  sleep 5
#done

# If Traefik does not recognize the new container within the timeout, stop it and exit with an error
#if [[ -z "$TRAEFIK_SERVER_STATUS" ]]; then
#  echo "Traefik did not recognize $INACTIVE_SERVICE within 60 seconds"
#  docker-compose stop --timeout=30 $INACTIVE_SERVICE
#  exit 1
#fi

# Set Traefik priority label to 0 on the old service and stop the old environment if it was previously running
#if [[ -n "$ACTIVE_SERVICE" ]]; then
#  echo "Stopping $ACTIVE_SERVICE container"
#  docker-compose down $ACTIVE_SERVICE
#fi
