FROM imgrep/busybox:latest as busybox
FROM imgrep/gcc:latest as gcc
FROM imgrep/binutils:latest as binutils
FROM imgrep/musl:latest as musl
FROM imgrep/make:latest as make

FROM busybox as build
ENV SRC_SITE=https://distfiles.ariadne.space/pkgconf/
ENV SRC_VERSION=1.6.3
ENV SRC_HASH=61f0b31b0d5ea0e862b454a80c170f57bad47879c0c42bd8de89200ff62ea210
RUN wget ${SRC_SITE}/pkgconf-${SRC_VERSION}.tar.xz
RUN echo "${SRC_HASH}  pkgconf-${SRC_VERSION}.tar.xz" | sha256sum -c
RUN tar -xf pkgconf-${SRC_VERSION}.tar.xz
WORKDIR pkgconf-${SRC_VERSION}
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /
RUN set -eux; \
    ./configure \
        --prefix=/usr; \
    make;
RUN make DESTDIR=/home/user/rootfs install
RUN ln -s pkgconf /home/user/rootfs/usr/bin/pkg-config
COPY --from=musl /usr/lib/libc.so /home/user/rootfs/lib/ld-musl-x86_64.so.1

FROM scratch
COPY --from=build /home/user/rootfs /
ENTRYPOINT ["/usr/bin/pkgconf"]
CMD ["--version"]
