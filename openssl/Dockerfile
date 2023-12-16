ARG REGISTRY=local
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/make:latest as make
FROM ${REGISTRY}/perl:latest as perl
FROM ${REGISTRY}/linux-headers:latest as linux-headers
FROM ${REGISTRY}/busybox:latest as busybox

FROM busybox as base
ENV SRC_SITE=https://www.openssl.org/source
ENV SRC_VERSION=3.0.12
ENV SRC_HASH=f93c9e8edde5e9166119de31755fc87b4aa34863662f67ddfcba14d0b6b69b61
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /
COPY --from=perl . /
COPY --from=linux-headers . /

FROM base as fetch
RUN wget ${SRC_SITE}/openssl-${SRC_VERSION}.tar.gz
RUN echo "${SRC_HASH}  openssl-${SRC_VERSION}.tar.gz" | sha256sum -c

FROM fetch as build
RUN tar -xf openssl-${SRC_VERSION}.tar.gz
WORKDIR openssl-${SRC_VERSION}
RUN set -eux; \
    export CC='gcc -fPIE -pie'; \
    perl ./Configure \
        --prefix=/usr \
        --libdir=lib \
        --openssldir=/etc/ssl \
        threads \
        enable-ktls \
        shared \
		no-zlib \
		no-async \
		no-comp \
		no-idea \
		no-mdc2 \
		no-rc5 \
		no-ec2m \
		no-ssl3 \
		no-seed \
		no-weak-ssl-ciphers \
        linux-x86_64; \
    make

FROM build as install
USER 0:0
RUN set -eux; \
    make DESTDIR=/rootfs install; \
    find /rootfs -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
USER 100:100
ENTRYPOINT ["/usr/bin/openssl"]
CMD ["version"]
