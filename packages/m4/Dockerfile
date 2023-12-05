FROM imgrep/busybox:latest as busybox
FROM imgrep/gcc:latest as gcc
FROM imgrep/binutils:latest as binutils
FROM imgrep/musl:latest as musl
FROM imgrep/make:latest as make

FROM busybox as build
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /
ENV SRC_SITE=https://ftp.gnu.org/gnu/m4
ENV SRC_VERSION=1.4.19
ENV SRC_HASH=63aede5c6d33b6d9b13511cd0be2cac046f2e70fd0a07aa9573a04a82783af96
RUN wget ${SRC_SITE}/m4-${SRC_VERSION}.tar.xz

RUN echo "${SRC_HASH}  m4-${SRC_VERSION}.tar.xz" | sha256sum -c
RUN tar -xf m4-${SRC_VERSION}.tar.xz
WORKDIR m4-${SRC_VERSION}
RUN set -eux; \
    ./configure \
        --prefix=/usr; \
    make;
RUN make DESTDIR=/home/user/rootfs install
COPY --from=musl /usr/lib/libc.so /home/user/rootfs/lib/ld-musl-x86_64.so.1

FROM scratch
COPY --from=build /home/user/rootfs /
ENTRYPOINT ["/usr/bin/m4"]
CMD ["--version"]
