# Image with the requirements to build Amiberry for aarch64
# Author: Dimitris Panokostas
# Version: 1.0
# Date: 2022-06-07
#
# Usage: docker run --rm -it -v <path-to-amiberry-sources>:/build amiberry-docker-aarch64:latest
#
FROM debian:latest

RUN dpkg --add-architecture arm64
RUN apt-get update && apt-get install -y autoconf git build-essential gcc-aarch64-linux-gnu g++-aarch64-linux-gnu libsdl2-dev:arm64 libsdl2-ttf-dev:arm64 libsdl2-image-dev:arm64 libpng-dev:arm64 libflac-dev:arm64 libmpg123-dev:arm64 libmpeg2-4-dev:arm64 pkgconf:arm64

WORKDIR /build

ENV ARCH=aarch64-linux-gnu
ENV AS=${ARCH}-as
ENV CC=${ARCH}-gcc
ENV CXX=${ARCH}-g++
ENV STRIP=${ARCH}-strip

CMD [ "bash"]
