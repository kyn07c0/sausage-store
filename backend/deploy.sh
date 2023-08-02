#!/bin/bash
set +e
cat > .env_backend <<EOF
BACKEND_VERSION=${BACKEND_VERSION}
SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}
EOF
set +xe

# Find active service
docker container ls --filter health=healthy | grep -q green
result=$?
if [ $result -eq 0 ]; then
  ACTIVE_SERVICE="green"
  NEW_SERVICE="blue"
else
  ACTIVE_SERVICE="blue"
  NEW_SERVICE="green"
fi
echo "Active service: $ACTIVE_SERVICE"

# Stop the second service if it is running 
docker stop $NEW_SERVICE
docker rm $NEW_SERVICE

# Start new service
docker-compose pull $NEW_SERVICE || true 
docker-compose --env-file .env_backend up -d $NEW_SERVICE || true
echo "New service $NEW_SERVICE is run"

# Wait new service to become healthy
for((i=1; i<=5; i++));
do
  docker container ls --filter health=healthy | grep -q $NEW_SERVICE
  result=$?
  if [[ $result -eq 0 ]]; then
    echo "New service $NEW_SERVICE is healthy"
    break
  fi

  if [[ $i -eq 5 ]]; then
    echo "New service $NEW_SERVICE did not become healthy"
    docker stop $NEW_SERVICE
    docker rm $NEW_SERVICE
    break 
  fi

  sleep "20"
done

# Stop old service if new service is health
docker container ls --filter health=healthy | grep -q $NEW_SERVICE
result=$?
if [[ $result -eq 0 ]]; then
  docker stop $ACTIVE_SERVICE
  docker rm $ACTIVE_SERVICE
  echo "Old service $ACTIVE_SERVICE is stopped"
fi
