FROM imgrep/busybox as busybox
FROM imgrep/gcc as gcc
FROM imgrep/binutils as binutils
FROM imgrep/musl as musl
FROM imgrep/bash as bash
FROM imgrep/make as make
FROM imgrep/cmake as cmake
FROM imgrep/python as python
FROM imgrep/curl as curl
FROM imgrep/zlib as zlib
FROM imgrep/openssl as openssl
FROM imgrep/llvm13 as llvm13
FROM imgrep/perl as perl

FROM busybox as rust1.54
ENV SRC_SITE=https://codeload.github.com/thepowersgang/mrustc/legacy.tar.gz
ENV SRC_VERSION=6cc28a575edb785eef044571b79f8df466512f11
ENV SRC_HASH=e1d2f54031ef448cab91fbd5773105bde81bdd11af2bd01923007d7e7af90d7c
COPY --from=curl . /
RUN curl ${SRC_SITE}/${SRC_VERSION} -o mrustc.tar.gz
RUN echo "${SRC_HASH}  mrustc.tar.gz" | sha256sum -c
RUN tar -xzf mrustc.tar.gz
RUN mv thepowersgang-mrustc-* mrustc

WORKDIR mrustc
COPY --from=binutils . /
COPY --from=bash . /
COPY --from=make . /
COPY --from=cmake . /
COPY --from=python . /
COPY --from=zlib . /
COPY --from=openssl . /
COPY --from=llvm13 . /
COPY --from=perl . /
COPY --from=gcc . /
COPY --from=musl . /
ENV MRUSTC_TARGET_VER=1.54
ENV RUSTC_VERSION=1.54.0
ENV MRUSTC_DEBUG=Expand
ENV MRUSTC_DUMP_PROCMACRO=dump_prefix
ENV RUSTC_INSTALL_BINDIR=bin
ENV OUTDIR_SUF=
RUN make
RUN make RUSTCSRC
RUN rm -rf rustc-1.54.0-src/src/llvm-project
RUN make -f minicargo.mk LIBS
RUN make test local_tests
RUN make -f minicargo.mk LLVM_CONFIG=/usr/bin/llvm-config output/rustc
RUN make -f minicargo.mk LLVM_CONFIG=/usr/bin/llvm-config output/cargo
RUN set -eux; \
    mkdir -p /home/user/rootfs/usr/bin; \
    mv output/rustc output/cargo /home/user/rootfs/usr/bin/
COPY --from=musl /lib/* /home/user/rootfs/lib/
COPY --from=gcc /usr/lib/* /home/user/rootfs/usr/lib/
COPY --from=gcc /usr/lib64/* /home/user/rootfs/usr/lib/

FROM scratch
COPY --from=stage0 /home/user/rootfs /
USER 100:100
ENTRYPOINT ["/usr/bin/rustc"]
CMD ["--version"]
