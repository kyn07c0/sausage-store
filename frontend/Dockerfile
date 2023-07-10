# build
FROM node:8 as builder
WORKDIR /usr/src/app
COPY package*.json ./
COPY . .
RUN npm install -g npm@9.8.0
RUN npm run build

# release
FROM node:8
WORKDIR /app
RUN addgroup --system front-user \
    && adduser -S -s /bin/false -G front-user front-user -D -H 
    #&& chown -R front-user:front-user ./dist/frontend/
RUN npm install -g http-server
COPY --from=builder /usr/src/app/dist/frontend ./dist/frontend
EXPOSE 80
ENTRYPOINT ["http-server", "dist/frontend/", "-p", "80", "--proxy", "http://sausage-backend:8090"]


