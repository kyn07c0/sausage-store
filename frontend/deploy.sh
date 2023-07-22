#!/bin/bash
set +xe
docker-compose up --detach --build frontend || true
