ARG REGISTRY=local
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/make:latest as make
FROM ${REGISTRY}/busybox:latest as busybox

FROM busybox as base
ENV SRC_SITE=https://www.cpan.org/src/5.0
ENV SRC_VERSION=5.38.0
ENV SRC_HASH=eca551caec3bc549a4e590c0015003790bdd1a604ffe19cc78ee631d51f7072e
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /

FROM base as fetch
RUN wget ${SRC_SITE}/perl-${SRC_VERSION}.tar.xz
RUN echo "${SRC_HASH}  perl-${SRC_VERSION}.tar.xz" | sha256sum -c

FROM fetch as build
RUN tar -xf perl-${SRC_VERSION}.tar.xz
WORKDIR perl-${SRC_VERSION}
RUN set -eux; \
	./Configure \
        -des \
		-Dcccdlflags='-fPIC' \
		-Dccdlflags='-rdynamic' \
		-Dprefix=/usr \
		-Dvendorprefix=/usr \
		-Dvendorlib=/usr/share/perl5/vendor_perl \
		-Dvendorarch=/usr/lib/perl5/vendor_perl \
		-Dsiteprefix=/usr/local \
		-Dsitelib=/usr/local/share/perl5/site_perl \
		-Dsitearch=/usr/local/lib/perl5/site_perl \
		-Dlocincpth=' ' \
		-Duselargefiles \
		-Dusethreads \
		-Duseshrplib \
        -Dcc=gcc \
		-Dd_semctl_semun \
		-Dman1dir=/usr/share/man/man1 \
		-Dman3dir=/usr/share/man/man3 \
		-Dinstallman1dir=/usr/share/man/man1 \
		-Dinstallman3dir=/usr/share/man/man3 \
		-Dman1ext='1' \
		-Dman3ext='3pm' \
		-Ud_csh \
		-Ud_fpos64_t \
		-Ud_off64_t \
		-Dusenm; \
    make

FROM build as install
USER 0:0
RUN set -eux; \
    make DESTDIR=/rootfs install; \
    mkdir -p /rootfs/lib
COPY --from=musl /usr/lib/libc.so /rootfs/lib/ld-musl-x86_64.so.1
RUN find /rootfs -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
USER 100:100
ENTRYPOINT ["/usr/bin/perl"]
CMD ["--version"]
