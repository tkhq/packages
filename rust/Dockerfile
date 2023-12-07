FROM imgrep/busybox as busybox
FROM imgrep/gcc as gcc
FROM imgrep/binutils as binutils
FROM imgrep/musl as musl
FROM imgrep/bash as bash
FROM imgrep/make as make
FROM imgrep/cmake as cmake
FROM imgrep/python as python
FROM imgrep/py-setuptools as py-setuptools
FROM imgrep/curl as curl
FROM imgrep/zlib as zlib
FROM imgrep/openssl as openssl
FROM imgrep/llvm13 as llvm13
FROM imgrep/perl as perl
FROM imgrep/libunwind as libunwind

FROM busybox as rust1.54-build
ENV SRC_SITE=https://codeload.github.com/lrvick/mrustc/legacy.tar.gz
ENV SRC_VERSION=16d744fd62e74a2d4356df864b5850bf782918da
ENV SRC_HASH=88d5d022875d279a75fa1e9c95d0de779cb3ad3bb587f2edeb85e6f59e99d528
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
COPY --from=llvm13 . /
COPY --from=perl . /
COPY --from=gcc . /
COPY --from=libunwind . /
COPY --from=musl . /
ENV MRUSTC_TARGET_VER=1.54
ENV RUSTC_VERSION=1.54.0
ENV RUSTC_TARGET=x86_64-unknown-linux-musl
ENV MRUSTC_DEBUG=Expand
ENV MRUSTC_DUMP_PROCMACRO=dump_prefix
ENV RUSTC_INSTALL_BINDIR=bin
ENV OUTDIR_SUF=
RUN make
RUN make RUSTCSRC
RUN make -f minicargo.mk LIBS
RUN make test local_tests
RUN make -f minicargo.mk LLVM_CONFIG=/usr/bin/llvm-config output/rustc
RUN make -f minicargo.mk LLVM_CONFIG=/usr/bin/llvm-config output/cargo
RUN make -C run_rustc LLVM_CONFIG=/usr/bin/llvm-config
RUN ls -Rlah run_rustc/output/prefix
RUN set -eux; \
    mkdir -p /home/user/rootfs/usr/bin; \
    cp -R run_rustc/output/prefix/* /home/user/rootfs/; \
    rm /home/user/rootfs/bin/rustc; \
    mv /home/user/rootfs/bin/rustc_binary /home/user/rootfs/usr/bin/rustc; \
    mv /home/user/rootfs/bin/cargo /home/user/rootfs/usr/bin/; \
    mv /home/user/rootfs/lib/rustlib/x86_64-unknown-linux-musl/lib/librustc_driver.so /home/user/rootfs/lib/
COPY --from=musl /lib/* /home/user/rootfs/lib/
COPY --from=gcc /usr/lib/* /home/user/rootfs/usr/lib/
COPY --from=gcc /usr/lib64/* /home/user/rootfs/usr/lib/
RUN ls -Rlah /home/user/rootfs/

FROM scratch as rust1.54
USER 100:100
COPY --from=rust1.54-build /home/user/rootfs/ /
ENTRYPOINT ["/usr/bin/rustc"]
CMD ["--version"]
