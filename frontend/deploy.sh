#!/bin/bash
set +xe
docker-compose up --detach --build sausage-frontend || true
