# Stage 1: Build the Flutter app
FROM ubuntu:20.04 AS build

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run basic check to download Dart SDK
RUN flutter doctor

WORKDIR /app

# Copy the rest of the application
COPY . .

# Build web application
RUN flutter build web

# Stage 2: Serve the app with Nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
