ARG REGISTRY=local
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/make:latest as make
FROM ${REGISTRY}/bash:latest as bash
FROM ${REGISTRY}/busybox:latest as busybox

FROM busybox as base
ENV SRC_SITE=https://ftp.gnu.org/gnu/sed
ENV SRC_VERSION=4.9
ENV SRC_HASH=6e226b732e1cd739464ad6862bd1a1aba42d7982922da7a53519631d24975181
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /

FROM base as fetch
RUN wget ${SRC_SITE}/sed-${SRC_VERSION}.tar.xz
RUN echo "${SRC_HASH}  sed-${SRC_VERSION}.tar.xz" | sha256sum -c

FROM fetch as build
RUN tar -xf sed-${SRC_VERSION}.tar.xz
WORKDIR sed-${SRC_VERSION}
RUN set -eux; \
    ./configure \
        --prefix=/; \
    make

FROM build as install
USER 0:0
RUN make DESTDIR=/rootfs install
COPY --from=musl /usr/lib/libc.so /rootfs/lib/ld-musl-x86_64.so.1
RUN find /rootfs -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
ENTRYPOINT ["/bin/sed"]
CMD ["--version"]
