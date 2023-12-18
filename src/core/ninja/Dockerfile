ARG REGISTRY=local
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/make:latest as make
FROM ${REGISTRY}/python:latest as python
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/busybox:latest as busybox

FROM busybox as base
ENV SRC_SITE=https://github.com/martine/ninja/archive/
ENV SRC_VERSION=1.9.0
ENV SRC_HASH=5d7ec75828f8d3fd1a0c2f31b5b0cea780cdfe1031359228c428c1a48bfcd5b9
COPY --from=binutils . /
COPY --from=make . /
COPY --from=python . /
COPY --from=musl . /
COPY --from=gcc . /

FROM base as fetch
RUN wget ${SRC_SITE}/v${SRC_VERSION}.tar.gz
RUN echo "${SRC_HASH}  v${SRC_VERSION}.tar.gz" | sha256sum -c

FROM fetch as build
RUN tar -xf v${SRC_VERSION}.tar.gz
WORKDIR ninja-${SRC_VERSION}
ADD fix-musl.patch .
RUN patch -p1 < fix-musl.patch
# HACK: figure out why gcc package puts these in the wrong path at install time
COPY --from=gcc /usr/lib64/* /usr/lib/
RUN set -eux; \
    python3 ./configure.py --bootstrap

FROM build as install
USER 0:0
RUN set -eux; \
    mkdir -p /rootfs/usr/bin/; \
    cp ninja /rootfs/usr/bin/
# HACK: figure out why gcc package puts these in the wrong path at install time
COPY --from=gcc /usr/lib64/* /rootfs/usr/lib/
COPY --from=musl . /rootfs/
RUN find /rootfs -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
USER 100:100
ENTRYPOINT ["/usr/bin/ninja"]
CMD ["--version"]
