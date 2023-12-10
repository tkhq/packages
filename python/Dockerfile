ARG REGISTRY=local
FROM ${REGISTRY}/busybox:latest as busybox
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/make:latest as make
FROM ${REGISTRY}/openssl:latest as openssl

FROM busybox as build
ENV SRC_SITE=https://www.python.org/ftp/python
ENV SRC_VERSION=3.12.0
ENV SRC_HASH=795c34f44df45a0e9b9710c8c71c15c671871524cd412ca14def212e8ccb155d
RUN wget ${SRC_SITE}/${SRC_VERSION}/Python-${SRC_VERSION}.tar.xz
RUN echo "${SRC_HASH}  Python-${SRC_VERSION}.tar.xz" | sha256sum -c
RUN tar -xf Python-${SRC_VERSION}.tar.xz
WORKDIR Python-${SRC_VERSION}
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /
COPY --from=openssl . /
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
    make; \
    make DESTDIR=/home/user/rootfs install
RUN ln -s /usr/bin/python3 /home/user/rootfs/usr/bin/python
COPY --from=musl . /home/user/rootfs/

FROM scratch
COPY --from=build /home/user/rootfs /
USER 100:100
ENTRYPOINT ["/usr/bin/python"]
CMD ["--version"]
