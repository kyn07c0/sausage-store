#! /bin/bash
#чтобы скрипт завершался, если есть ошибки
set -xe
#скачиваем артефакт
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store-${VERSION}.jar - curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store-${VERSION}.jar ${NEXUS_REPO_URL}/sausage-store-kryvinya-yuriy-backend/com/yandex/practicum/devops/sausage-store/${VERSION}/sausage-store-${VERSION}.jar
#запускаем java-приложение в фоне
nohup "java -jar sausage-store-${VERSION}.jar --server.port=9090 &"
