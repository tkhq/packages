FROM imgrep/musl:latest as musl
FROM imgrep/bootstrap:latest as build

ENV GCC_SITE https://mirrors.kernel.org/gnu/gcc
ENV GCC_VERSION 13.2.0
ENV GCC_HASH e275e76442a6067341a27f04c5c6b83d8613144004c0413528863dc6b5c743da

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
RUN make DESTDIR=/home/user/rootfs/ install-strip
COPY --from=musl /lib/* /home/user/rootfs/lib/

FROM scratch
COPY --from=build /home/user/rootfs /
ENTRYPOINT ["/usr/bin/gcc"]
CMD ["--version"]
