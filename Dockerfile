# Image with the requirements to build Amiberry for aarch64
# Author: Dimitris Panokostas
#
# Usage: docker run --rm -it -v <path-to-amiberry-sources>:/build amiberry-debian-aarch64:latest
#

# If no arg is provided, default to latest
ARG debian_release=latest
ARG sdl3_repo=https://github.com/libsdl-org/SDL.git
ARG sdl3_ref=release-3.2.x
ARG sdl3_image_repo=https://github.com/libsdl-org/SDL_image.git
ARG sdl3_image_ref=release-3.2.x
FROM debian:${debian_release}

ARG sdl3_repo
ARG sdl3_ref
ARG sdl3_image_repo
ARG sdl3_image_ref

LABEL maintainer="Dimitris Panokostas"
LABEL description="Image with the requirements to cross-compile Amiberry for Debian AARCH64 (ARM64)"

RUN dpkg --add-architecture arm64 && \
    apt-get update && \
    apt-get dist-upgrade -fuy && \
    apt-get install -y --no-install-recommends \
        autoconf ca-certificates git build-essential cmake curl file ninja-build \
        gcc-aarch64-linux-gnu g++-aarch64-linux-gnu pkg-config \
        libsdl2-dev:arm64 libsdl2-ttf-dev:arm64 libsdl2-image-dev:arm64 \
        libpng-dev:arm64 libflac-dev:arm64 libmpg123-dev:arm64 \
        libmpeg2-4-dev:arm64 libserialport-dev:arm64 libportmidi-dev:arm64 \
        libenet-dev:arm64 libpcap-dev:arm64 libzstd-dev:arm64 \
        libcurl4-openssl-dev:arm64 nlohmann-json3-dev:arm64 \
        libdbus-1-dev:arm64 && \
    if ! apt-get install -y --no-install-recommends libsdl3-dev:arm64 libsdl3-image-dev:arm64; then \
        sdl3_build_deps='libasound2-dev:arm64 libdbus-1-dev:arm64 libdrm-dev:arm64 libegl1-mesa-dev:arm64 libgbm-dev:arm64 libgl1-mesa-dev:arm64 libgles2-mesa-dev:arm64 libglib2.0-dev:arm64 libibus-1.0-dev:arm64 libjpeg62-turbo-dev:arm64 libpulse-dev:arm64 libsamplerate0-dev:arm64 libsndio-dev:arm64 libtiff-dev:arm64 libudev-dev:arm64 libwayland-dev:arm64 libwebp-dev:arm64 libx11-dev:arm64 libxcursor-dev:arm64 libxext-dev:arm64 libxfixes-dev:arm64 libxi-dev:arm64 libxinerama-dev:arm64 libxkbcommon-dev:arm64 libxrandr-dev:arm64 libxrender-dev:arm64 libxss-dev:arm64 libxt-dev:arm64 libxv-dev:arm64 libxxf86vm-dev:arm64'; \
        for optional_pkg in libdecor-0-dev:arm64; do \
            if apt-cache show "$optional_pkg" > /dev/null 2>&1; then \
                sdl3_build_deps="$sdl3_build_deps $optional_pkg"; \
            fi; \
        done; \
        apt-get install -y --no-install-recommends $sdl3_build_deps && \
        printf '%s\n' \
            'set(CMAKE_SYSTEM_NAME Linux)' \
            'set(CMAKE_SYSTEM_PROCESSOR aarch64)' \
            'set(CMAKE_C_COMPILER aarch64-linux-gnu-gcc)' \
            'set(CMAKE_CXX_COMPILER aarch64-linux-gnu-g++)' \
            'set(CMAKE_FIND_ROOT_PATH /usr /usr/aarch64-linux-gnu)' \
            'set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)' \
            'set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)' \
            'set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)' \
            'set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)' \
            > /tmp/aarch64-toolchain.cmake && \
        export PKG_CONFIG_LIBDIR=/usr/lib/aarch64-linux-gnu/pkgconfig:/usr/share/pkgconfig && \
        export PKG_CONFIG_PATH=/usr/local/lib/aarch64-linux-gnu/pkgconfig && \
        export PKG_CONFIG_SYSROOT_DIR=/ && \
        git clone --depth 1 --branch ${sdl3_ref} ${sdl3_repo} /tmp/SDL && \
        cmake -S /tmp/SDL -B /tmp/SDL/build -G Ninja \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_TOOLCHAIN_FILE=/tmp/aarch64-toolchain.cmake \
            -DCMAKE_INSTALL_PREFIX=/usr \
            -DCMAKE_INSTALL_LIBDIR=lib/aarch64-linux-gnu \
            -DSDL_SHARED=ON \
            -DSDL_STATIC=OFF && \
        cmake --build /tmp/SDL/build && \
        cmake --install /tmp/SDL/build && \
        git clone --depth 1 --branch ${sdl3_image_ref} ${sdl3_image_repo} /tmp/SDL_image && \
        cmake -S /tmp/SDL_image -B /tmp/SDL_image/build -G Ninja \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_TOOLCHAIN_FILE=/tmp/aarch64-toolchain.cmake \
            -DCMAKE_INSTALL_PREFIX=/usr \
            -DCMAKE_INSTALL_LIBDIR=lib/aarch64-linux-gnu \
            -DSDLIMAGE_SAMPLES=OFF \
            -DSDLIMAGE_TESTS=OFF \
            -DSDLIMAGE_VENDORED=OFF && \
        cmake --build /tmp/SDL_image/build && \
        cmake --install /tmp/SDL_image/build && \
        rm -rf /tmp/SDL /tmp/SDL_image /tmp/aarch64-toolchain.cmake && \
        ldconfig; \
    fi && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /build

ENV ARCH=aarch64-linux-gnu
ENV AS=${ARCH}-as
ENV CC=${ARCH}-gcc
ENV CXX=${ARCH}-g++
ENV STRIP=${ARCH}-strip

CMD [ "bash" ]
