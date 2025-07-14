FROM debian:12-slim AS builder

USER root

ENV HOME="/root"
ARG flutter_version="stable"

ENV FLUTTER_HOME=${HOME}/sdks/flutter \
    FLUTTER_VERSION=$flutter_version
ENV FLUTTER_ROOT=$FLUTTER_HOME
ENV PATH="$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$HOME/.pub-cache/bin:${PATH}"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        bash \
        curl \
        git \
        wget \
        unzip \
        libstdc++6 \
        ca-certificates \
        xz-utils \
        zip \
        libglu1-mesa && \
    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git ${FLUTTER_HOME}

RUN flutter config --no-enable-windows-desktop --no-enable-macos-desktop --no-enable-linux-desktop --no-enable-android --no-enable-ios --enable-web && \
    flutter channel stable && \
    flutter doctor && \
    flutter precache --web --no-ios --no-windows --no-macos --no-linux --no-android && \
    chown -R root:root ${FLUTTER_HOME}

WORKDIR /app
COPY . .

RUN flutter pub global activate melos && \
    melos bootstrap && \
    flutter build web --release --wasm

FROM nginx:1.28-alpine3.21-slim

COPY --from=builder /app/build/web /usr/share/nginx/html

RUN sed -i 's|application/javascript[[:space:]]\+js;|application/javascript       js mjs;|' /etc/nginx/mime.types

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget -O /dev/null http://localhost || exit 1

CMD ["nginx", "-g", "daemon off;"]
