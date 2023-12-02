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
FROM imgrep/llvm as llvm
FROM imgrep/perl as perl

FROM busybox as stage0
ENV SRC_SITE=https://codeload.github.com/lrvick/mrustc/legacy.tar.gz
ENV SRC_VERSION=df243f74b3267b20430b818277c7e9e1de9951ad
ENV SRC_HASH=e675b5d9f53c0456d2b513ca1b7743c0257abfc96f4d4cab9807c8c37e53301d
COPY --from=curl . /
RUN curl ${SRC_SITE}/${SRC_VERSION} -o mrustc.tar.gz
RUN echo "${SRC_HASH}  mrustc.tar.gz" | sha256sum -c
RUN tar -xzf mrustc.tar.gz
RUN mv lrvick-mrustc-* mrustc
WORKDIR mrustc
COPY --from=binutils . /
COPY --from=bash . /
COPY --from=make . /
COPY --from=cmake . /
COPY --from=python . /
COPY --from=zlib . /
COPY --from=openssl . /
COPY --from=llvm . /
COPY --from=perl . /
COPY --from=gcc . /
COPY --from=musl . /

ENV RUSTC_TARGET=x86_64-unknown-linux-musl
ENV MRUSTC_TARGET_VER=1.54
ENV RUSTC_VERSION=1.54.0
ENV MRUSTC_DEBUG=Expand
ENV MRUSTC_DUMP_PROCMACRO=dump_prefix
ENV RUSTC_INSTALL_BINDIR=bin
ENV OUTDIR_SUF=
RUN make
RUN make RUSTCSRC
RUN make -f minicargo.mk LIBS
RUN make test
RUN make local_tests
RUN make -f minicargo.mk output/rustc
RUN make -f minicargo.mk output/cargo
RUN ./output/rustc --version
RUN ./output/cargo --version
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
