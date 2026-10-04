# Build with ZaidFlutterCode as the Docker build context.
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app
COPY gradProjectFlutter/ ./

RUN flutter clean \
    && flutter pub get \
    && flutter build web --release

# Serve the compiled Flutter web app.
FROM nginx:stable-alpine AS runtime

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
