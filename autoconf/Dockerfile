ARG REGISTRY=local
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/make:latest as make
FROM ${REGISTRY}/m4:latest as m4
FROM ${REGISTRY}/perl:latest as perl

FROM ${REGISTRY}/busybox:latest as base
ENV SRC_SITE https://ftp.gnu.org/gnu/autoconf
ENV SRC_VERSION 2.71
ENV SRC_HASH f14c83cfebcc9427f2c3cea7258bd90df972d92eb26752da4ddad81c87a0faa4
ENV SRC_FILE autoconf-${SRC_VERSION}.tar.xz

FROM base as fetch
RUN set -eux; \
    wget ${SRC_SITE}/${SRC_FILE}; \
    echo "${SRC_HASH}  ${SRC_FILE}" | sha256sum -c

FROM fetch as build
RUN tar -xf ${SRC_FILE}
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

FROM scratch as package
COPY --from=build /home/user/rootfs /
ENTRYPOINT ["/usr/bin/autoreconf"]
CMD ["--version"]
