# Base
FROM ghcr.io/cirruslabs/flutter:stable AS base

WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get


# Development
FROM base AS dev

COPY . .

EXPOSE 8080

CMD ["flutter", "run", "-d", "web-server", "--web-port=8080", "--web-hostname=0.0.0.0"]
