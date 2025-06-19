# amiberry-docker-aarch64

A Dockerfile which creates an image with all requirements to cross-compile Amiberry for the `aarch64` platform (e.g. Raspberry Pi 64-bit) on an x86_64 host.

The image is based on Debian and includes all Amiberry dependencies (e.g. SDL2, SDL2-image, etc). Supported Debian versions: `bullseye`, `bookworm` (see tags below).

The full image is available on DockerHub: <https://hub.docker.com/repository/docker/midwan/amiberry-debian-aarch64>

## Usage

To use the latest Bookworm-based image:

```bash
docker run --rm -it -v <dir-you-cloned-amiberry-into>:/build midwan/amiberry-debian-aarch64:latest
```

To use a specific Debian version:

```bash
docker run --rm -it -v <dir-you-cloned-amiberry-into>:/build midwan/amiberry-debian-aarch64:bookworm

docker run --rm -it -v <dir-you-cloned-amiberry-into>:/build midwan/amiberry-debian-aarch64:bullseye
```

Then you can proceed to compile Amiberry with the relevant toolchain file, e.g.:

```bash
cmake -DCMAKE_TOOLCHAIN_FILE=cmake/Toolchain-aarch64-linux-gnu.cmake -B build && cmake --build build
```

## Building the image locally

To build the image yourself for a specific Debian release:

```bash
docker build --build-arg debian_release=bookworm -t amiberry-debian-aarch64:bookworm .
```

## CI/CD

Images are automatically built and pushed to DockerHub via GitHub Actions on every push to `main` and on a daily schedule.
