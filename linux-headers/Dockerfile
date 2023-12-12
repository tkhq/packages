ARG REGISTRY=local
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/bootstrap:latest as build

ENV SRC_SITE https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/
ENV SRC_VERSION 6.6
ENV SRC_HASH d926a06c63dd8ac7df3f86ee1ffc2ce2a3b81a2d168484e76b5b389aba8e56d0

RUN wget ${SRC_SITE}/linux-${SRC_VERSION}.tar.xz
RUN echo "${SRC_HASH} linux-${SRC_VERSION}.tar.xz" | sha256sum -c
RUN tar -xf linux-${SRC_VERSION}.tar.xz
WORKDIR linux-${SRC_VERSION}
RUN set -ex; \
    make headers; \
    mkdir -p /rootfs/usr; \
    cp -a usr/include /rootfs/usr/; \
    find /rootfs/usr/include/ ! -iname "*.h" -type f -exec rm -v {} \+; \
    rm -rf /rootfs/usr/include/drm;

FROM scratch as package
COPY --from=build /rootfs /
