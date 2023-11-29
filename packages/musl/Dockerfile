FROM imgrep/bootstrap:latest as build

ENV SRC_SITE http://musl.libc.org
ENV SRC_VERSION 1.2.4
ENV SRC_HASH 7a35eae33d5372a7c0da1188de798726f68825513b7ae3ebe97aaaa52114f039

RUN wget ${SRC_SITE}/releases/musl-$SRC_VERSION.tar.gz
RUN echo "${SRC_HASH} musl-${SRC_VERSION}.tar.gz" | sha256sum -c
RUN tar -xzf musl-${SRC_VERSION}.tar.gz
WORKDIR musl-${SRC_VERSION}
RUN set -eux; \
    export LDFLAGS="-Wl,-soname,libc.musl-x86_64.so.1"; \
    ./configure \
        --build=x86_64-linux-musl \
        --host=x86_64-linux-musl \
        --prefix=/usr \
        --sysconfdir=/etc \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --localstatedir=/var \
        --enable-debug; \
    make;

RUN set -eux; \
    make DESTDIR=/home/user/rootfs install; \
    mkdir -p /home/user/rootfs/usr/bin; \
    printf "%s\n%s\n" '#!/bin/sh' 'exec /lib/$LDSO --list "\$@"' \
        > /home/user/rootfs/usr/bin/ldd; \
    chmod 755 /home/user/rootfs/usr/bin/ldd; \
    mv -f /home/user/rootfs/usr/lib/libc.so /home/user/rootfs/lib/ld-musl-x86_64.so.1; \
    ln -sf ld-musl-x86_64.so.1 /home/user/rootfs/lib/libc.musl-x86_64.so.1; \
    ln -sf ../../lib/ld-musl-x86_64.so.1 /home/user/rootfs/usr/lib/libc.so;

FROM scratch
COPY --from=build /home/user/rootfs /
