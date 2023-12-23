ARG REGISTRY=local
FROM ${REGISTRY}/bootstrap:latest as bootstrap

FROM bootstrap as base
ENV SRC_SITE http://musl.libc.org
ENV SRC_VERSION 1.2.4
ENV SRC_HASH 7a35eae33d5372a7c0da1188de798726f68825513b7ae3ebe97aaaa52114f039
ENV CFLAGS="-Os -fstack-clash-protection -Wformat -Werror=format-security"
ENV CXXFLAGS="-Os -fstack-clash-protection -Wformat -Werror=format-security -D_GLIBCXX_ASSERTIONS=1 -D_LIBCPP_ENABLE_THREAD_SAFETY_ANNOTATIONS=1 -D_LIBCPP_ENABLE_HARDENED_MODE=1"
ENV LDFLAGS="-Wl,--as-needed,-O1,--sort-common -Wl,-soname,libc.musl-x86_64.so.1"

FROM base as fetch
RUN wget ${SRC_SITE}/releases/musl-$SRC_VERSION.tar.gz
RUN echo "${SRC_HASH} musl-${SRC_VERSION}.tar.gz" | sha256sum -c

FROM fetch as build
RUN tar -xzf musl-${SRC_VERSION}.tar.gz
WORKDIR musl-${SRC_VERSION}
ADD lfs64.patch .
ADD lfs64-2.patch .
RUN set -eux; \
    patch -p1 < lfs64.patch; \
    patch -p1 < lfs64-2.patch; \
    ./configure \
        --build=x86_64-linux-musl \
        --host=x86_64-linux-musl \
        --prefix=/usr \
        --sysconfdir=/etc \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --localstatedir=/var \
        --enable-debug; \
    make

FROM build as install
USER 0:0
RUN set -eux; \
    make DESTDIR=/rootfs install; \
    mkdir -p /rootfs/usr/bin; \
    printf "%s\n%s\n" '#!/bin/sh' 'exec /lib/ld-musl-x86_64.so.1 --list "$@"' \
        > /rootfs/usr/bin/ldd; \
    chmod 755 /rootfs/usr/bin/ldd; \
    mv -f /rootfs/usr/lib/libc.so /rootfs/lib/ld-musl-x86_64.so.1; \
    ln -sf ld-musl-x86_64.so.1 /rootfs/lib/libc.musl-x86_64.so.1; \
    ln -sf ../../lib/ld-musl-x86_64.so.1 /rootfs/usr/lib/libc.so; \
    find /rootfs -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
