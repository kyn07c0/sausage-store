#! /bin/bash

set -xe

sudo cp -rf sausage-store-backend.service /etc/systemd/system/sausage-store-backend.service

curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store.jar ${NEXUS_REPO_URL}/sausage-store-kryvinya-yuriy-backend/com/yandex/practicum/devops/sausage-store/${VERSION}/sausage-store-${VERSION}.jar

sudo rm -f /var/jarservice/sausage-store.jar||true
sudo install -o ${BACKEND_USER} ./sausage-store.jar /var/jarservice/sausage-store.jar||true

sudo systemctl daemon-reload
sudo systemctl restart sausage-store-backend


