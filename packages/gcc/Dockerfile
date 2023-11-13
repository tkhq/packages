FROM ocirep/musl:latest as musl
FROM ocirep/bootstrap:latest as build

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
		--build="x86_64-linux-musl" \
		--host="x86_64-linux-musl" \
		--disable-multilib \
		--enable-languages=c,c++ \
        --prefix /rootfs \
	; \
	make -j "$(nproc)"; \
	make install-strip
COPY --from=musl /lib /libmusl
RUN mv /libmusl/* /rootfs/lib/

FROM scratch
COPY --from=build /rootfs /
ENTRYPOINT ["/bin/gcc"]
CMD ["--version"]
