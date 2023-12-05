FROM imgrep/busybox:latest as busybox
FROM imgrep/gcc:latest as gcc
FROM imgrep/binutils:latest as binutils
FROM imgrep/musl:latest as musl
FROM imgrep/make:latest as make
FROM imgrep/openssl:latest as openssl
FROM imgrep/python:latest as python

FROM busybox as build
ENV SRC_SITE=https://github.com/martine/ninja/archive/
ENV SRC_VERSION=1.9.0
ENV SRC_HASH=5d7ec75828f8d3fd1a0c2f31b5b0cea780cdfe1031359228c428c1a48bfcd5b9
RUN wget ${SRC_SITE}/v${SRC_VERSION}.tar.gz
RUN echo "${SRC_HASH}  v${SRC_VERSION}.tar.gz" | sha256sum -c
RUN tar -xf v${SRC_VERSION}.tar.gz
WORKDIR ninja-${SRC_VERSION}
ADD fix-musl.patch .
RUN patch -p1 < fix-musl.patch
COPY --from=binutils . /
COPY --from=make . /
COPY --from=python . /
COPY --from=musl . /
COPY --from=gcc . /

# HACK: figure out why gcc package puts these in the wrong path at install time
COPY --from=gcc /usr/lib64/* /usr/lib/

RUN set -eux; \
    python3 ./configure.py --bootstrap; \
    mkdir -p /home/user/rootfs/usr/bin/; \
    cp ninja /home/user/rootfs/usr/bin/

# HACK: figure out why gcc package puts these in the wrong path at install time
COPY --from=gcc /usr/lib64/* /home/user/rootfs/usr/lib/
COPY --from=musl . /home/user/rootfs/

FROM scratch
COPY --from=build /home/user/rootfs /
USER 100:100
ENTRYPOINT ["/usr/bin/ninja"]
CMD ["--version"]
