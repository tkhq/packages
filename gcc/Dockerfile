ARG REGISTRY=local
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/bootstrap:latest as build

ENV GCC_SITE https://mirrors.kernel.org/gnu/gcc
ENV GCC_VERSION 12.2.0
ENV GCC_HASH e549cf9cf3594a00e27b6589d4322d70e0720cdd213f39beb4181e06926230ff

RUN echo wget ${GCC_SITE}/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz
RUN wget ${GCC_SITE}/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz
RUN echo "${GCC_HASH} gcc-${GCC_VERSION}.tar.xz" | sha256sum -c
RUN tar -xf gcc-${GCC_VERSION}.tar.xz
WORKDIR gcc-${GCC_VERSION}
RUN set -ex; \
	./contrib/download_prerequisites; \
	{ rm *.tar.* || true; }

RUN set -ex; \
	./configure \
        --target=x86_64-linux-musl \
		--build=x86_64-linux-musl \
		--host=x86_64-linux-musl \
        --prefix /usr \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --libdir=/usr/lib \
        --disable-cet \
		--disable-fixed-point \
		--disable-libstdcxx-pch \
		--disable-multilib \
		--disable-nls \
		--disable-werror \
        --enable-__cxa_atexit \
		--enable-default-pie \
		--enable-default-ssp \
		--enable-languages=c,c++ \
		--enable-link-serialization=2 \
		--enable-linker-build-id; \
	make -j "$(nproc)"
RUN set -eux; \
    make DESTDIR=/home/user/rootfs/ install-strip; \
    ln -s gcc /home/user/rootfs/usr/bin/cc
COPY --from=musl /lib/* /home/user/rootfs/lib/

FROM scratch
COPY --from=build /home/user/rootfs /
ENTRYPOINT ["/usr/bin/gcc"]
CMD ["--version"]
