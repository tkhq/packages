ARG REGISTRY=local
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/make:latest as make
FROM ${REGISTRY}/openssl:latest as openssl
FROM ${REGISTRY}/busybox:latest as busybox

FROM busybox as base
ENV SRC_SITE=https://www.python.org/ftp/python
ENV SRC_VERSION=3.12.0
ENV SRC_HASH=795c34f44df45a0e9b9710c8c71c15c671871524cd412ca14def212e8ccb155d
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /
COPY --from=openssl . /

FROM base as fetch
RUN wget ${SRC_SITE}/${SRC_VERSION}/Python-${SRC_VERSION}.tar.xz
RUN echo "${SRC_HASH}  Python-${SRC_VERSION}.tar.xz" | sha256sum -c

FROM fetch as build
RUN tar -xf Python-${SRC_VERSION}.tar.xz
WORKDIR Python-${SRC_VERSION}
RUN set -eux; \
    ./configure \
		--build="x86_64-linux-musl" \
		--host="x86_64-linux-musl" \
        --prefix=/usr \
        --enable-ipv6 \
		--enable-optimizations \
		--enable-shared \
		--with-lto \
		--with-computed-gotos \
		--without-ensurepip; \
    make

FROM build as install
USER 0:0
RUN set -eux; \
    make DESTDIR=/rootfs install; \
    ln -s /usr/bin/python3 /rootfs/usr/bin/python
COPY --from=musl . /rootfs/
RUN find /rootfs -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
USER 100:100
ENTRYPOINT ["/usr/bin/python"]
CMD ["--version"]
