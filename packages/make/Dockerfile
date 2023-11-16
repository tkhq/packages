FROM ocirep/musl:latest as musl
FROM ocirep/bootstrap:latest as build

ENV SRC_SITE https://ftp.gnu.org/gnu/make
ENV SRC_VERSION 4.4
ENV SRC_HASH 581f4d4e872da74b3941c874215898a7d35802f03732bdccee1d4a7979105d18

RUN wget ${SRC_SITE}/make-${SRC_VERSION}.tar.gz
RUN echo "${SRC_HASH} make-${SRC_VERSION}.tar.gz" | sha256sum -c
RUN tar -xf make-${SRC_VERSION}.tar.gz
WORKDIR make-${SRC_VERSION}
RUN set -ex; \
    ./configure \
        --build=x86_64-linux-musl \
        --host=x86_64-linux-musl \
        --target=x86_64-linux-musl \
        --prefix=/usr \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --disable-nls; \
	make -j "$(nproc)"; \
	make DESTDIR="/rootfs" install;
COPY --from=musl /lib/libc.so /rootfs/lib/ld-musl-x86_64.so.1

FROM scratch
COPY --from=build /rootfs /
ENTRYPOINT ["/usr/bin/make"]
CMD ["--version"]
