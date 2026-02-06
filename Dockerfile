# Image with the requirements to build Amiberry for aarch64
# Author: Dimitris Panokostas
#
# Usage: docker run --rm -it -v <path-to-amiberry-sources>:/build amiberry-debian-aarch64:latest
#

# If no arg is provided, default to latest
ARG debian_release=latest
FROM debian:${debian_release}

LABEL maintainer="Dimitris Panokostas"
LABEL description="Image with the requirements to cross-compile Amiberry for Debian AARCH64 (ARM64)"

RUN dpkg --add-architecture arm64 && \
    apt-get update && \
    apt-get dist-upgrade -fuy && \
    apt-get install -y --no-install-recommends \
        autoconf git build-essential cmake file ninja-build \
        gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
        libsdl2-dev:arm64 libsdl2-ttf-dev:arm64 libsdl2-image-dev:arm64 \
        libpng-dev:arm64 libflac-dev:arm64 libmpg123-dev:arm64 \
        libmpeg2-4-dev:arm64 libserialport-dev:arm64 libportmidi-dev:arm64 \
        libenet-dev:arm64 pkgconf:arm64 libpcap-dev:arm64 libzstd-dev:arm64 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /build

ENV ARCH=aarch64-linux-gnu
ENV AS=${ARCH}-as
ENV CC=${ARCH}-gcc
ENV CXX=${ARCH}-g++
ENV STRIP=${ARCH}-strip

CMD [ "bash" ]
