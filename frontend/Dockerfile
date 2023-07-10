# build
FROM node:16-alpine3.16 as builder
WORKDIR /usr/src/app
COPY package*.json ./
COPY . .
RUN npm install
RUN npm run build

# release
FROM node:16
WORKDIR /app
RUN npm install -g http-server
RUN addgroup --system front-user \
    && adduser -S -s /bin/false -G front-user front-user -D -H  
COPY --chown=front-user:front-user \ 
     --from=builder /usr/src/app/dist/frontend ./dist/frontend
EXPOSE 80
USER front-user
ENTRYPOINT ["http-server", "dist/frontend/", "-p", "80", "--proxy", "http://sausage-backend:8090"]


