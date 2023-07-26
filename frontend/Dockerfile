# build
FROM node:16-alpine3.16 as builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# release
FROM nginxproxy/nginx-proxy
WORKDIR /app
COPY --from=builder /usr/src/app/dist/frontend /usr/share/nginx/html
COPY nginx.tmpl /app/nginx.tmpl
