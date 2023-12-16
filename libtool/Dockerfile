ARG REGISTRY=local
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/make:latest as make
FROM ${REGISTRY}/m4:latest as m4
FROM ${REGISTRY}/bash:latest as bash
FROM ${REGISTRY}/sed:latest as sed
FROM ${REGISTRY}/busybox:latest as busybox

FROM busybox as base
ENV SRC_SITE=https://ftp.gnu.org/gnu/libtool
ENV SRC_VERSION=2.4.6
ENV SRC_HASH=7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /
COPY --from=m4 . /

FROM base as fetch
RUN wget ${SRC_SITE}/libtool-${SRC_VERSION}.tar.xz
RUN echo "${SRC_HASH}  libtool-${SRC_VERSION}.tar.xz" | sha256sum -c

FROM fetch as build
RUN tar -xf libtool-${SRC_VERSION}.tar.xz
WORKDIR libtool-${SRC_VERSION}
RUN set -eux; \
    ./configure \
        --prefix=/usr; \
    make;

FROM build as install
USER 0:0
RUN make DESTDIR=/rootfs install
COPY --from=musl /usr/lib/libc.so /rootfs/lib/ld-musl-x86_64.so.1
COPY --from=bash . /rootfs
COPY --from=sed . /rootfs
RUN ln -s /bin/bash /rootfs/bin/sh
RUN find /rootfs -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
ENTRYPOINT ["/usr/bin/libtool"]
CMD ["--version"]
