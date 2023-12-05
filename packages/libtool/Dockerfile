FROM imgrep/busybox:latest as busybox
FROM imgrep/gcc:latest as gcc
FROM imgrep/binutils:latest as binutils
FROM imgrep/musl:latest as musl
FROM imgrep/make:latest as make
FROM imgrep/m4:latest as m4
FROM imgrep/bash:latest as bash
FROM imgrep/sed:latest as sed

FROM busybox as build
ENV SRC_SITE=https://ftp.gnu.org/gnu/libtool
ENV SRC_VERSION=2.4.6
ENV SRC_HASH=7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f
RUN wget ${SRC_SITE}/libtool-${SRC_VERSION}.tar.xz
RUN echo "${SRC_HASH}  libtool-${SRC_VERSION}.tar.xz" | sha256sum -c
RUN tar -xf libtool-${SRC_VERSION}.tar.xz
WORKDIR libtool-${SRC_VERSION}
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /
COPY --from=m4 . /
RUN set -eux; \
    ./configure \
        --prefix=/usr; \
    make;
RUN make DESTDIR=/home/user/rootfs install
COPY --from=musl /usr/lib/libc.so /home/user/rootfs/lib/ld-musl-x86_64.so.1
COPY --from=bash . /home/user/rootfs
COPY --from=sed . /home/user/rootfs
RUN ln -s /usr/bin/bash /home/user/rootfs/bin/sh

FROM scratch
COPY --from=build /home/user/rootfs /
ENTRYPOINT ["/usr/bin/libtool"]
CMD ["--version"]
