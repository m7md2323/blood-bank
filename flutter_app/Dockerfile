# Stage 1: Base - shared setup
FROM ghcr.io/cirruslabs/flutter:stable AS base

WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get


# Stage 2: Development
FROM base AS dev

COPY . .

EXPOSE 8080

CMD ["flutter", "run", "-d", "web-server", "--web-port=8080", "--web-hostname=0.0.0.0"]


# Stage 3: Build - compile static web assets
FROM base AS build

COPY . .

RUN flutter build web --release


# Stage 4: Production - serve static build via Nginx
FROM nginx:1.27-alpine AS production

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]