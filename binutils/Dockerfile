ARG REGISTRY=local
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/bootstrap:latest as build

ENV SRC_SITE https://ftp.gnu.org/gnu/binutils
ENV SRC_VERSION 2.41
ENV SRC_HASH ae9a5789e23459e59606e6714723f2d3ffc31c03174191ef0d015bdf06007450

RUN wget ${SRC_SITE}/binutils-${SRC_VERSION}.tar.xz
RUN echo "${SRC_HASH} binutils-${SRC_VERSION}.tar.xz" | sha256sum -c
RUN tar -xf binutils-${SRC_VERSION}.tar.xz
WORKDIR binutils-${SRC_VERSION}
RUN set -ex; \
    CFLAGS='-Os -Wformat -Werror=format-security -O2' \
    CXXFLAGS='-Os -Wformat -Werror=format-security -O2' \
    ./configure \
        --build=x86_64-linux-musl \
        --host=x86_64-linux-musl \
        --target=x86_64-linux-musl \
        --with-build-sysroot= \
        --with-sysroot=/ \
        --prefix=/usr \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --sysconfdir=/etc \
        --enable-plugins \
        --without-zstd \
        --disable-shared \
        --disable-jansson \
        --disable-gdb \
        --disable-gprofng \
        --disable-multilib \
        --disable-nls \
        --disable-werror \
        --enable-gold \
        --enable-64-bit-bfd \
        --enable-default-execstack=no \
        --enable-default-hash-style=gnu \
        --enable-deterministic-archives \
        --enable-ld=default \
        --enable-new-dtags \
        --enable-relro \
        --enable-threads \
        --with-mmap \
        --with-pic; \
	make -j "$(nproc)"; \
	make DESTDIR="/home/user/rootfs" install;
COPY --from=musl /usr/lib/libc.so /rootfs/lib/ld-musl-x86_64.so.1

FROM scratch
COPY --from=build /home/user/rootfs /
ENTRYPOINT ["/bin/ld"]
CMD ["--version"]
