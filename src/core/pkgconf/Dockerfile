ARG REGISTRY=local
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/make:latest as make
FROM ${REGISTRY}/busybox:latest as busybox

FROM busybox as base
ENV SRC_SITE=https://distfiles.ariadne.space/pkgconf/
ENV SRC_VERSION=1.6.3
ENV SRC_HASH=61f0b31b0d5ea0e862b454a80c170f57bad47879c0c42bd8de89200ff62ea210
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /

FROM base as fetch
RUN wget ${SRC_SITE}/pkgconf-${SRC_VERSION}.tar.xz
RUN echo "${SRC_HASH}  pkgconf-${SRC_VERSION}.tar.xz" | sha256sum -c

FROM fetch as build
RUN tar -xf pkgconf-${SRC_VERSION}.tar.xz
WORKDIR pkgconf-${SRC_VERSION}
RUN set -eux; \
    ./configure \
        --prefix=/usr; \
    make

FROM build as install
USER 0:0
RUN set -eux; \
    make DESTDIR=/rootfs install; \
    ln -s pkgconf /rootfs/usr/bin/pkg-config
COPY --from=musl /usr/lib/libc.so /rootfs/lib/ld-musl-x86_64.so.1
RUN find /rootfs -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
ENTRYPOINT ["/usr/bin/pkgconf"]
CMD ["--version"]
