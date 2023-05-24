#! /bin/bash

set -xe

sudo cp -rf sausage-store-frontend.service /etc/systemd/system/sausage-store-frontend.service

curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store.tar.gz ${NEXUS_REPO_URL}/sausage-store-kryvinya-yuriy-frontend/com/yandex/practicum/devops/sausage-store/${VERSION}/sausage-store-${VERSION}.tar.gz

sudo rm -rf /var/www-data/frontend||true
sudo tar -xf ./sausage-store.tar.gz -C /var/www-data/

sudo systemctl daemon-reload
sudo systemctl restart sausage-store-frontend
