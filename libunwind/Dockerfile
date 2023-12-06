FROM imgrep/busybox:latest as busybox
FROM imgrep/gcc:latest as gcc
FROM imgrep/binutils:latest as binutils
FROM imgrep/musl:latest as musl
FROM imgrep/make:latest as make
FROM imgrep/autoconf:latest as autoconf
FROM imgrep/automake:latest as automake
FROM imgrep/libtool:latest as libtool

FROM busybox as build
ENV SRC_SITE=https://github.com/libunwind/libunwind/releases/download
ENV SRC_VERSION=1.7.2
ENV SRC_HASH=a18a6a24307443a8ace7a8acc2ce79fbbe6826cd0edf98d6326d0225d6a5d6e6
RUN wget ${SRC_SITE}/v${SRC_VERSION}/libunwind-${SRC_VERSION}.tar.gz
RUN echo "${SRC_HASH}  libunwind-${SRC_VERSION}.tar.gz" | sha256sum -c
RUN tar -xf libunwind-${SRC_VERSION}.tar.gz
WORKDIR libunwind-${SRC_VERSION}
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /
COPY --from=autoconf . /
COPY --from=automake . /
COPY --from=libtool . /
#LDFLAGS="-lucontext" CFLAGS="-fno-stack-protector" \
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
        --infodir=/usr/share/info; \
    make;
RUN make DESTDIR=/home/user/rootfs install

FROM scratch
COPY --from=build /home/user/rootfs /
