ARG REGISTRY=local
FROM ${REGISTRY}/gcc as gcc
FROM ${REGISTRY}/binutils as binutils
FROM ${REGISTRY}/musl as musl
FROM ${REGISTRY}/make as make
FROM ${REGISTRY}/autoconf as autoconf
FROM ${REGISTRY}/automake as automake
FROM ${REGISTRY}/libtool as libtool
FROM ${REGISTRY}/busybox as busybox

FROM busybox as base
ENV SRC_SITE=https://github.com/libunwind/libunwind/releases/download
ENV SRC_VERSION=1.7.2
ENV SRC_HASH=a18a6a24307443a8ace7a8acc2ce79fbbe6826cd0edf98d6326d0225d6a5d6e6
COPY --from=gcc . /
COPY --from=make . /
COPY --from=musl . /
COPY --from=binutils . /
COPY --from=autoconf . /
COPY --from=automake . /
COPY --from=libtool . /

FROM base as fetch
RUN wget ${SRC_SITE}/v${SRC_VERSION}/libunwind-${SRC_VERSION}.tar.gz
RUN echo "${SRC_HASH}  libunwind-${SRC_VERSION}.tar.gz" | sha256sum -c

FROM fetch as build
RUN tar -xf libunwind-${SRC_VERSION}.tar.gz
WORKDIR libunwind-${SRC_VERSION}
RUN set -eux; \
    ./configure \
        --build=x86_64-unknown-linux-musl \
        --host=x86_64-unknown-linux-musl \
        --prefix=/usr \
        --sysconfdir=/etc \
        --mandir=/usr/share/man \
        --localstatedir=/usr/share/man \
        --enable-cxx-exceptions \
        --disable-tests \
        --infodir=/usr/share/info || cat config.log; \
    make;

FROM build as install
USER 0:0
RUN set -eux; \
    make DESTDIR=/rootfs install; \
    find /rootfs -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
