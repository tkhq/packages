ARG REGISTRY=local
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/curl:latest as curl
FROM ${REGISTRY}/ninja:latest as ninja
FROM ${REGISTRY}/openssl:latest as openssl
FROM ${REGISTRY}/linux-headers:latest as linux-headers
FROM ${REGISTRY}/openssl:latest as openssl
FROM ${REGISTRY}/make:latest as make
FROM ${REGISTRY}/busybox:latest as busybox

FROM busybox as base
ENV SRC_SITE=https://cmake.org/files
ENV SRC_VERSION=3.27.8
ENV SRC_HASH=fece24563f697870fbb982ea8bf17482c9d5f855d8c9bf0b82463d76c9e8d0cc
COPY --from=binutils . /
COPY --from=ninja . /
COPY --from=musl . /
COPY --from=make . /
COPY --from=linux-headers . /
COPY --from=gcc . /
COPY --from=openssl . /

FROM base as fetch
RUN wget --no-check-certificate ${SRC_SITE}/v3.27/cmake-${SRC_VERSION}.tar.gz
RUN echo "${SRC_HASH}  cmake-${SRC_VERSION}.tar.gz" | sha256sum -c

FROM fetch as build
RUN tar -xf cmake-${SRC_VERSION}.tar.gz
WORKDIR cmake-${SRC_VERSION}
RUN set -eux; \
    ./bootstrap \
        --prefix=/usr \
        --mandir=/share/man \
        --datadir=/share/cmake \
        --docdir=/share/doc/cmake \
        --no-system-cppdap \
		--no-system-curl \
		--no-system-jsoncpp \
        --generator=Ninja; \
    ninja

FROM build as install
USER 0:0
RUN DESTDIR=/rootfs bin/cmake -P cmake_install.cmake
COPY --from=musl /lib/* /rootfs/lib/
COPY --from=musl /usr/lib/* /rootfs/usr/lib/
COPY --from=gcc /usr/lib/* /rootfs/usr/lib/
COPY --from=gcc /usr/lib64/* /rootfs/usr/lib/
COPY --from=openssl /usr/lib/* /rootfs/usr/lib/
RUN find /rootfs -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
USER 100:100
ENTRYPOINT ["/usr/bin/cmake"]
CMD ["--version"]
