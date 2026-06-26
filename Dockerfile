# Dockerfile — casino-frontend (Angular 17 build + nginx-unprivileged en 8080)
# Multi-stage: 1) compila la SPA con Node, 2) la sirve con nginx sin root.

# ---- Etapa 1: build de produccion ----
FROM node:20-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# genera dist/casino-frontend/browser (Angular 17 'application' builder)
RUN npm run build

# ---- Etapa 2: servir con nginx no root ----
FROM nginxinc/nginx-unprivileged:1.27-alpine
# nginx-unprivileged corre como usuario 'nginx' (no root) y escucha en 8080
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist/casino-frontend/browser /usr/share/nginx/html
EXPOSE 8080
