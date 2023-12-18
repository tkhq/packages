ARG REGISTRY=local
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/make:latest as make
FROM ${REGISTRY}/busybox:latest as busybox

FROM busybox as base
ENV SRC_SITE=https://www.zlib.net/
ENV SRC_VERSION=1.3
ENV SRC_HASH=ff0ba4c292013dbc27530b3a81e1f9a813cd39de01ca5e0f8bf355702efa593e
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /

FROM base as fetch
RUN wget ${SRC_SITE}/zlib-${SRC_VERSION}.tar.gz
RUN echo "${SRC_HASH}  zlib-${SRC_VERSION}.tar.gz" | sha256sum -c

FROM fetch as build
RUN tar -xf zlib-${SRC_VERSION}.tar.gz
WORKDIR zlib-${SRC_VERSION}
RUN set -eux; \
    ./configure \
        --prefix=/usr \
        --libdir=/lib \
        --shared; \
    make

FROM build as install
USER 0:0
RUN set -eux; \
    make DESTDIR=/rootfs install; \
    find /rootfs -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
