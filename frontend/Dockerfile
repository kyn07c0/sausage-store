# build
FROM node:8 as builder
WORKDIR /usr/src/app
COPY *.json ./
COPY ./src ./src
RUN npm install
RUN npm install -g http-server
RUN npm run build

# release
FROM node:8 
WORKDIR /app
RUN addgroup --system front-user \
    && adduser -S -s /bin/false -G front-user front-user -D -H
RUN npm install -g http-server
COPY --chown=front-user:front-user \ 
     --from=builder /usr/src/app/dist ./dist
EXPOSE 80
ENTRYPOINT ["http-server", "dist/frontend/", "-p", "80", "--proxy", "http://sausage-backend:8080"]


