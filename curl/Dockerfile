ARG REGISTRY=local
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/busybox:latest as busybox
FROM ${REGISTRY}/make:latest as make
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/openssl:latest as openssl
FROM ${REGISTRY}/ca-certificates:latest as ca-certificates

FROM busybox as build
ENV SRC_SITE=https://curl.se/download
ENV SRC_VERSION=8.4.0
ENV SRC_HASH=16c62a9c4af0f703d28bda6d7bbf37ba47055ad3414d70dec63e2e6336f2a82d
RUN wget ${SRC_SITE}/curl-${SRC_VERSION}.tar.xz
RUN echo wget ${SRC_SITE}/curl-${SRC_VERSION}.tar.xz
RUN echo "${SRC_HASH}  curl-${SRC_VERSION}.tar.xz" | sha256sum -c
RUN tar -xf curl-${SRC_VERSION}.tar.xz
WORKDIR curl-${SRC_VERSION}
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /
COPY --from=gcc . /
COPY --from=openssl . /

RUN set -eux; \
    ./configure \
        --build=x86_64-linux-musl \
        --host=x86_64-linux-musl \
        --prefix=/usr \
        --sysconfdir=/etc \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt \
        --with-openssl \
        --enable-static-link; \
    make
RUN make install DESTDIR=/home/user/rootfs
COPY --from=musl . /home/user/rootfs/
COPY --from=openssl . /home/user/rootfs/
COPY --from=ca-certificates . /home/user/rootfs/

FROM scratch as package
COPY --from=build /home/user/rootfs /
USER 100:100
ENTRYPOINT ["/usr/bin/curl"]
CMD ["--version"]
