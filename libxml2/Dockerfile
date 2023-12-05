FROM imgrep/busybox:latest as busybox
FROM imgrep/gcc:latest as gcc
FROM imgrep/binutils:latest as binutils
FROM imgrep/musl:latest as musl
FROM imgrep/make:latest as make
FROM imgrep/autoconf:latest as autoconf
FROM imgrep/automake:latest as automake
FROM imgrep/libtool:latest as libtool
FROM imgrep/pkgconf:latest as pkgconf
FROM imgrep/python:latest as python
FROM imgrep/m4:latest as m4

FROM busybox as build
ENV SRC_SITE=https://gitlab.gnome.org/GNOME/libxml2/-/archive
ENV SRC_VERSION=2.12.1
ENV SRC_HASH=1090e62c5a1900429f63e4681263b96e7829876ccbc66cf2d9266cd589f67286
RUN wget ${SRC_SITE}/v${SRC_VERSION}/libxml2-v${SRC_VERSION}.tar.gz
RUN echo "${SRC_HASH}  libxml2-v${SRC_VERSION}.tar.gz" | sha256sum -c
RUN tar -xf libxml2-v${SRC_VERSION}.tar.gz
WORKDIR libxml2-v${SRC_VERSION}
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /
COPY --from=python . /
COPY --from=autoconf . /
COPY --from=automake . /
COPY --from=pkgconf . /
COPY --from=libtool . /
COPY --from=m4 . /
RUN ls -lah
RUN set -eux; \
    sh autogen.sh; \
    ./configure \
        --build=x86_64-unknown-linux-musl \
        --host=x86_64-unknown-linux-musl \
        --target=x86_64-unknown-linux-musl \
        --prefix=/usr \
        --sysconfdir=/etc \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info; \
    make;
RUN make DESTDIR=/home/user/rootfs install
RUN ls -Rlah /home/user/rootfs

FROM scratch
COPY --from=build /home/user/rootfs /
