#Это так называемый мультистейдж docker-файл. Сначала делаем образ, который соберёт нам java-приложение,
#а затем из него берём собранный артефакт и кладём его в новый образ, чтобы оставить в нём меньше лишнего

# build
FROM maven:3.8.2-openjdk-16-slim as builder
# задаём переменную VERSION, которая будет использоваться для сборки проекта
ARG VERSION=${VERSION}
WORKDIR /usr/src/app
COPY ./src ./src
COPY *.xml ./
# копируем CA-сертификат Яндекса в образ
RUN curl https://storage.yandexcloud.net/cloud-certs/CA.pem -o YandexInternalRootCA.crt \
    && mvn package -Dversion.application=${VERSION}

# release
FROM openjdk:16-jdk-alpine
ARG VERSION=${VERSION}
WORKDIR /app
COPY --from=builder /usr/src/app/YandexInternalRootCA.crt .
# подкидываем CA-сертификат Яндекса в хранилище сертификатов для Java
# создаём пользователя jarservice
RUN keytool -importcert -file YandexInternalRootCA.crt \
    -alias yandex -cacerts -storepass changeit -noprompt \
    && rm -rf YandexInternalRootCA.crt \
    && addgroup --system jarservice \
    && adduser -S -s /bin/false -G jarservice -G jarservice jarservice -D -H \
    && apk add --no-cache dumb-init==1.2.5-r0
RUN apk add curl
COPY --chown=jarservice:jarservice \
     --from=builder /usr/src/app/target/sausage-store-${VERSION}.jar ./sausage-store.jar
RUN chown jarservice:jarservice /app     
EXPOSE 8090
# приложение будет запускаться под пользователем jarservice
USER jarservice
ENTRYPOINT ["dumb-init", "java", "-jar", "-Dserver.port=8090", "./sausage-store.jar"]
