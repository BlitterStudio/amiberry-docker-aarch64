# amiberry-docker-aarch64

A Dockerfile which creates an image, with the requirements to build Amiberry for the `aarch64` platform (e.g. Raspberry Pi 64-bit).

No Dispmanx is supported in this image, only 64-bit SDL2 versions.

The image is based on Debian:latest and includes all Amiberry dependencies (e.g. SDL2, SDL2-image, etc)

The full image is available on DockerHub: <https://hub.docker.com/repository/docker/midwan/amiberry-docker-aarch64>

## Usage

`docker run --rm -it -v <dir-you-cloned-amiberry-into>:/build midwan/amiberry-docker-aarch64:latest`

Then you can proceed to compile Amiberry as usual, e.g. `make -j8 PLATFORM=rpi4-64-sdl2`
