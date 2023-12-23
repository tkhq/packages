ARG REGISTRY=local
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/bootstrap:latest as bootstrap

FROM bootstrap as base
ENV SRC_SITE https://ftp.gnu.org/gnu/binutils
ENV SRC_VERSION 2.41
ENV SRC_HASH ae9a5789e23459e59606e6714723f2d3ffc31c03174191ef0d015bdf06007450

FROM base as fetch
RUN wget ${SRC_SITE}/binutils-${SRC_VERSION}.tar.xz
RUN echo "${SRC_HASH} binutils-${SRC_VERSION}.tar.xz" | sha256sum -c

FROM fetch as build
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
	make -j "$(nproc)"

FROM build as install
USER 0:0
RUN make DESTDIR="/rootfs" install;
COPY --from=musl /usr/lib/libc.so /rootfs/lib/ld-musl-x86_64.so.1
RUN find /rootfs -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
ENTRYPOINT ["/bin/ld"]
CMD ["--version"]
