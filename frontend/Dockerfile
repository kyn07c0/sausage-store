# build
FROM node:16-alpine3.16 as builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# release
FROM node:16-alpine3.16
WORKDIR /app
RUN npm install -g http-server
COPY --from=builder /usr/src/app/dist/frontend ./dist/frontend
RUN addgroup --system front-user \
    && adduser -S -s /bin/false -G front-user front-user -D -H \
    && chown -R front-user:front-user ./dist/frontend/
EXPOSE 8010
USER front-user
CMD ["http-server", "dist/frontend/", "-p", "8010", "--proxy", "http://sausage-backend:8090"]


