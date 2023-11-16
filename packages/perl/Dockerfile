FROM ocirep/busybox:latest as busybox
FROM ocirep/gcc:latest as gcc
FROM ocirep/binutils:latest as binutils
FROM ocirep/musl:latest as musl
FROM ocirep/make:latest as make

FROM busybox as build
ENV SRC_SITE=https://www.cpan.org/src/5.0
ENV SRC_VERSION=5.38.0
ENV SRC_HASH=eca551caec3bc549a4e590c0015003790bdd1a604ffe19cc78ee631d51f7072e
RUN wget ${SRC_SITE}/perl-${SRC_VERSION}.tar.xz
RUN echo "${SRC_HASH}  perl-${SRC_VERSION}.tar.xz" | sha256sum -c
RUN tar -xf perl-${SRC_VERSION}.tar.xz
WORKDIR perl-${SRC_VERSION}
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /
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
    make; \
    make DESTDIR=/home/user/rootfs install
COPY --from=musl /lib/libc.so /home/user/rootfs/lib/ld-musl-x86_64.so.1

FROM scratch
COPY --from=build /home/user/rootfs /
USER 100:100
ENTRYPOINT ["/usr/bin/perl"]
CMD ["--version"]
