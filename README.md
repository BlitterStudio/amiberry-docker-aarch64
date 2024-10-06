# amiberry-docker-aarch64

A Dockerfile which creates an image, with the requirements to cross-compile Amiberry for the `aarch64` platform (e.g. Raspberry Pi 64-bit).

The image is based on Debian:latest and includes all Amiberry dependencies (e.g. SDL2, SDL2-image, etc)

The full image is available on DockerHub: <https://hub.docker.com/repository/docker/midwan/amiberry-debian-aarch64>

## Usage

`docker run --rm -it -v <dir-you-cloned-amiberry-into>:/build midwan/amiberry-debian-aarch64:latest`

Then you can proceed to compile Amiberry with the relevant toolchain file, e.g. `cmake -DCMAKE_TOOLCHAIN_FILE=cmake/Toolchain-aarch64-linux-gnu.cmake -B build && cmake --build build`
