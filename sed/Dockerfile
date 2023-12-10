REGISTRY=local
FROM ${REGISTRY}/busybox:latest as busybox
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/make:latest as make
FROM ${REGISTRY}/bash:latest as bash

FROM busybox as build
ENV SRC_SITE=https://ftp.gnu.org/gnu/sed
ENV SRC_VERSION=4.9
ENV SRC_HASH=6e226b732e1cd739464ad6862bd1a1aba42d7982922da7a53519631d24975181
RUN wget ${SRC_SITE}/sed-${SRC_VERSION}.tar.xz
RUN echo "${SRC_HASH}  sed-${SRC_VERSION}.tar.xz" | sha256sum -c
RUN tar -xf sed-${SRC_VERSION}.tar.xz
WORKDIR sed-${SRC_VERSION}
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /
RUN set -eux; \
    ./configure \
        --prefix=/; \
    make;
RUN make DESTDIR=/home/user/rootfs install
COPY --from=musl /usr/lib/libc.so /home/user/rootfs/lib/ld-musl-x86_64.so.1

FROM scratch
COPY --from=build /home/user/rootfs /
ENTRYPOINT ["/bin/sed"]
CMD ["--version"]
