# Etapa 1: builder (compila Angular)
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

# Etapa 2: runtime
FROM nginxinc/nginx-unprivileged:stable-alpine AS runtime

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist/casino-frontend/browser/ /usr/share/nginx/html/

# Ejecuta Nginx sin privilegios de root
USER nginx

EXPOSE 8080