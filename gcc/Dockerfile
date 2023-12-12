ARG REGISTRY=local
FROM ${REGISTRY}/musl:latest as musl

FROM ${REGISTRY}/bootstrap:latest as base
ENV VERSION 12.2.0
ENV SRC_FILE gcc-$VERSION.tar.xz
ENV SRC_SITE https://mirrors.kernel.org/gnu/gcc/gcc-${VERSION}
ENV SRC_HASH e549cf9cf3594a00e27b6589d4322d70e0720cdd213f39beb4181e06926230ff
ENV DEP_SITE https://gcc.gnu.org/pub/gcc/infrastructure/
ENV GMP_FILE gmp-6.2.1.tar.bz2
ENV GMP_HASH eae9326beb4158c386e39a356818031bd28f3124cf915f8c5b1dc4c7a36b4d7c
ENV MPFR_FILE mpfr-4.1.0.tar.bz2
ENV MPFR_HASH feced2d430dd5a97805fa289fed3fc8ff2b094c02d05287fd6133e7f1f0ec926
ENV MPC_FILE mpc-1.2.1.tar.gz
ENV MPC_HASH 17503d2c395dfcf106b622dc142683c1199431d095367c6aacba6eec30340459
ENV ISL_FILE isl-0.24.tar.bz2
ENV ISL_HASH fcf78dd9656c10eb8cf9fbd5f59a0b6b01386205fe1934b3b287a0a1898145c0

FROM base as fetch
RUN set -eux; \
    wget ${SRC_SITE}/${SRC_FILE}; \
    echo "${SRC_HASH}  ${SRC_FILE}" | sha256sum -c; \
    wget ${DEP_SITE}/${GMP_FILE}; \
    echo "${GMP_HASH}  ${GMP_FILE}" | sha256sum -c; \
    wget ${DEP_SITE}/${MPFR_FILE}; \
    echo "${MPFR_HASH}  ${MPFR_FILE}" | sha256sum -c; \
    wget ${DEP_SITE}/${MPC_FILE}; \
    echo "${MPC_HASH}  ${MPC_FILE}" | sha256sum -c; \
    wget ${DEP_SITE}/${ISL_FILE}; \
    echo "${ISL_HASH}  ${ISL_FILE}" | sha256sum -c

FROM fetch as build
RUN tar -xf ${SRC_FILE}
WORKDIR gcc-${VERSION}
RUN set -eux; \
    mv ../*.tar.* .; \
	./contrib/download_prerequisites; \
	./configure \
        --target=x86_64-linux-musl \
		--build=x86_64-linux-musl \
		--host=x86_64-linux-musl \
        --prefix=/usr \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --libdir=/usr/lib \
        --disable-cet \
		--disable-fixed-point \
		--disable-libstdcxx-pch \
		--disable-multilib \
		--disable-nls \
		--disable-werror \
        --enable-__cxa_atexit \
		--enable-default-pie \
		--enable-default-ssp \
		--enable-languages=c,c++ \
		--enable-link-serialization=2 \
		--enable-linker-build-id; \
	make -j "$(nproc)"; \
    make DESTDIR=/home/user/rootfs/ install-strip; \
    ln -s gcc /home/user/rootfs/usr/bin/cc
COPY --from=musl /lib/* /home/user/rootfs/lib/

FROM ${REGISTRY}/binutils:latest as binutils
FROM scratch as test
COPY --from=busybox . /
COPY --from=binutils . /
COPY --from=musl . /
COPY --from=build /home/user/rootfs /
ADD test.c .
RUN set -eux; \
    gcc test.c -static -o main; \
    ./main | grep "Success"

FROM scratch as package
COPY --from=build /home/user/rootfs /
ENTRYPOINT ["/usr/bin/gcc"]
CMD ["--version"]
