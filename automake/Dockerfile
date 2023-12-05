FROM imgrep/busybox:latest as busybox
FROM imgrep/gcc:latest as gcc
FROM imgrep/binutils:latest as binutils
FROM imgrep/musl:latest as musl
FROM imgrep/make:latest as make
FROM imgrep/perl:latest as perl
FROM imgrep/autoconf:latest as autoconf
FROM imgrep/m4:latest as m4

FROM busybox as build
ENV SRC_SITE=https://ftp.gnu.org/gnu/automake
ENV SRC_VERSION=1.16.5
ENV SRC_HASH=f01d58cd6d9d77fbdca9eb4bbd5ead1988228fdb73d6f7a201f5f8d6b118b469
RUN wget ${SRC_SITE}/automake-${SRC_VERSION}.tar.xz
RUN echo "${SRC_HASH}  automake-${SRC_VERSION}.tar.xz" | sha256sum -c
RUN tar -xf automake-${SRC_VERSION}.tar.xz
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
RUN make DESTDIR=/home/user/rootfs install
COPY --from=musl /usr/lib/libc.so /home/user/rootfs/lib/ld-musl-x86_64.so.1
COPY --from=perl . /home/user/rootfs/

FROM scratch
COPY --from=build /home/user/rootfs /
ENTRYPOINT ["/usr/bin/automake"]
CMD ["--version"]
