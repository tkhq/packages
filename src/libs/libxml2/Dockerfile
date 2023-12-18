ARG REGISTRY=local
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/make:latest as make
FROM ${REGISTRY}/autoconf:latest as autoconf
FROM ${REGISTRY}/automake:latest as automake
FROM ${REGISTRY}/libtool:latest as libtool
FROM ${REGISTRY}/pkgconf:latest as pkgconf
FROM ${REGISTRY}/python:latest as python
FROM ${REGISTRY}/m4:latest as m4
FROM ${REGISTRY}/busybox:latest as busybox

FROM busybox as base
ENV SRC_SITE=https://gitlab.gnome.org/GNOME/libxml2/-/archive
ENV SRC_VERSION=2.12.1
ENV SRC_HASH=1090e62c5a1900429f63e4681263b96e7829876ccbc66cf2d9266cd589f67286
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

FROM base as fetch
RUN wget ${SRC_SITE}/v${SRC_VERSION}/libxml2-v${SRC_VERSION}.tar.gz
RUN echo "${SRC_HASH}  libxml2-v${SRC_VERSION}.tar.gz" | sha256sum -c

FROM fetch as build
RUN tar -xf libxml2-v${SRC_VERSION}.tar.gz
WORKDIR libxml2-v${SRC_VERSION}
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
    make

FROM build as install
USER 0:0
RUN set -eux; \
    make DESTDIR=/rootfs install; \
    find /rootfs -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
