ARG REGISTRY=local
FROM ${REGISTRY}/busybox:latest as busybox
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/make:latest as make

FROM busybox as build
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /
ENV SRC_SITE=https://www.zlib.net/
ENV SRC_VERSION=1.3
ENV SRC_HASH=ff0ba4c292013dbc27530b3a81e1f9a813cd39de01ca5e0f8bf355702efa593e
RUN wget ${SRC_SITE}/zlib-${SRC_VERSION}.tar.gz
RUN echo "${SRC_HASH}  zlib-${SRC_VERSION}.tar.gz" | sha256sum -c
RUN tar -xf zlib-${SRC_VERSION}.tar.gz
WORKDIR zlib-${SRC_VERSION}
RUN set -eux; \
    ./configure \
        --prefix=/usr \
        --libdir=/lib \
        --shared; \
    make;
RUN make DESTDIR=/home/user/rootfs install

FROM scratch
COPY --from=build /home/user/rootfs /
