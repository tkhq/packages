ARG REGISTRY=local
FROM ${REGISTRY}/busybox:latest as busybox
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/make:latest as make
FROM ${REGISTRY}/m4:latest as m4
FROM ${REGISTRY}/perl:latest as perl

FROM busybox as build
ENV SRC_SITE=https://ftp.gnu.org/gnu/autoconf
ENV SRC_VERSION=2.71
ENV SRC_HASH=f14c83cfebcc9427f2c3cea7258bd90df972d92eb26752da4ddad81c87a0faa4
RUN wget ${SRC_SITE}/autoconf-${SRC_VERSION}.tar.xz
RUN echo "${SRC_HASH}  autoconf-${SRC_VERSION}.tar.xz" | sha256sum -c
RUN tar -xf autoconf-${SRC_VERSION}.tar.xz
WORKDIR autoconf-${SRC_VERSION}
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /
COPY --from=m4 . /
COPY --from=perl . /
ENV M4=/usr/bin/m4
RUN set -eux; \
    ./configure \
        --prefix=/usr; \
    make;
RUN make DESTDIR=/home/user/rootfs install
COPY --from=perl . /home/user/rootfs/

FROM scratch
COPY --from=build /home/user/rootfs /
ENTRYPOINT ["/usr/bin/autoreconf"]
CMD ["--version"]
