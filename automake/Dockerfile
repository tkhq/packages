ARG REGISTRY=local
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/make:latest as make
FROM ${REGISTRY}/perl:latest as perl
FROM ${REGISTRY}/autoconf:latest as autoconf
FROM ${REGISTRY}/m4:latest as m4
FROM ${REGISTRY}/busybox:latest as busybox

FROM busybox as base
ENV SRC_SITE=https://ftp.gnu.org/gnu/automake
ENV SRC_VERSION=1.16.5
ENV SRC_HASH=f01d58cd6d9d77fbdca9eb4bbd5ead1988228fdb73d6f7a201f5f8d6b118b469

FROM base as fetch
RUN wget ${SRC_SITE}/automake-${SRC_VERSION}.tar.xz
RUN echo "${SRC_HASH}  automake-${SRC_VERSION}.tar.xz" | sha256sum -c
RUN tar -xf automake-${SRC_VERSION}.tar.xz

FROM fetch as build
WORKDIR automake-${SRC_VERSION}
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /
COPY --from=perl . /
COPY --from=m4 . /
COPY --from=autoconf . /
RUN set -eux; \
    ./configure \
        --prefix=/usr; \
    make;

FROM build as install
USER 0:0
RUN make DESTDIR=/rootfs install
COPY --from=musl /usr/lib/libc.so /rootfs/lib/ld-musl-x86_64.so.1
COPY --from=perl . /rootfs/
RUN find /rootfs -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
ENTRYPOINT ["/usr/bin/automake"]
CMD ["--version"]
