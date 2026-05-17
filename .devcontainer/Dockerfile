# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/devcontainers/base:2-noble

ARG flutter_version=stable

# Install Protocol Buffers compiler and development files
RUN apt-get update && apt-get install -y \
    protobuf-compiler \
    libprotobuf-dev \
    && rm -rf /var/lib/apt/lists/*

ENV FLUTTER_HOME=/home/vscode/sdks/flutter
ENV FLUTTER_ROOT=${FLUTTER_HOME}
ENV PATH=${PATH}:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin

RUN mkdir -p /home/vscode/sdks \
    && git clone --depth 1 --branch ${flutter_version} https://github.com/flutter/flutter.git ${FLUTTER_HOME}

RUN flutter config --no-analytics \
    && flutter config --enable-web \
    && flutter config --no-enable-android \
    && flutter config --no-enable-ios \
    && flutter config --no-enable-linux-desktop \
    && flutter config --no-enable-macos-desktop \
    && flutter config --no-enable-windows-desktop

RUN flutter precache --web \
    && flutter doctor

RUN chown -R vscode:vscode /home/vscode/sdks