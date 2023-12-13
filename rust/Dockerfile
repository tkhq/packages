ARG REGISTRY=local
ARG VERSION=1.74.0
ARG BUILD_VERSION=1.73.0
ARG LLVM_VERSION=13.0.1
FROM ${REGISTRY}/gcc as gcc
FROM ${REGISTRY}/binutils as binutils
FROM ${REGISTRY}/musl as musl
FROM ${REGISTRY}/bash as bash
FROM ${REGISTRY}/make as make
FROM ${REGISTRY}/cmake as cmake
FROM ${REGISTRY}/perl as perl
FROM ${REGISTRY}/curl as curl
FROM ${REGISTRY}/libunwind as libunwind
FROM ${REGISTRY}/python as python
FROM ${REGISTRY}/py-setuptools as py-setuptools
FROM ${REGISTRY}/zlib as zlib
FROM ${REGISTRY}/openssl as openssl
FROM ${REGISTRY}/pkgconf as pkgconf
FROM ${REGISTRY}/llvm:${LLVM_VERSION} as llvm

FROM ${REGISTRY}/busybox as base
ENV BOOTSTRAP_VERSION=1.54.0
ENV SRC_SITE=https://static.rust-lang.org/dist
ENV MRUSTC_VERSION=16d744fd62e74a2d4356df864b5850bf782918da
ENV MRUSTC_SITE=https://codeload.github.com/lrvick/mrustc/legacy.tar.gz
ENV MRUSTC_HASH=88d5d022875d279a75fa1e9c95d0de779cb3ad3bb587f2edeb85e6f59e99d528
ENV SRC_HASH_1_54_0=ac8511633e9b5a65ad030a1a2e5bdaa841fdfe3132f2baaa52cc04e71c6c6976
ENV SRC_HASH_1_55_0=b2379ac710f5f876ee3c3e03122fe33098d6765d371cac6c31b1b6fc8e43821e
ENV SRC_HASH_1_56_0=cd0fd72d698deb3001c18e0f4bf8261d8f86420097eef94ca3a1fe047f2df43f
ENV SRC_HASH_1_57_0=3546f9c3b91b1f8b8efd26c94d6b50312c08210397b4072ed2748e2bd4445c1a
ENV SRC_HASH_1_58_0=0ad531a32f3c2e996b9322c6b7262a9cfe557e49ff3363adea07b575106cd770
ENV SRC_HASH_1_59_0=a7c8eeaee85bfcef84c96b02b3171d1e6540d15179ff83dddd9eafba185f85f9
ENV SRC_HASH_1_60_0=20ca826d1cf674daf8e22c4f8c4b9743af07973211c839b85839742314c838b7
ENV SRC_HASH_1_61_0=ad0b4351675aa9abdf4c7e066613bd274c4391c5506db152983426376101daed
ENV SRC_HASH_1_62_0=7d0878809b64d206825acae3eb7f60afb2212d81e3de1adf4c11c6032b36c027
ENV SRC_HASH_1_63_0=1f9580295642ef5da7e475a8da2397d65153d3f2cb92849dbd08ed0effca99d0
ENV SRC_HASH_1_64_0=b3cd9f481e1a2901bf6f3808d30c69cc4ea80d93c4cc4e2ed52258b180381205
ENV SRC_HASH_1_65_0=5828bb67f677eabf8c384020582b0ce7af884e1c84389484f7f8d00dd82c0038
ENV SRC_HASH_1_66_0=3b3cd3ea5a82a266e75d0b35f0b54c16021576d9eb78d384052175a772935a48
ENV SRC_HASH_1_67_0=d029f14fce45a2ec7a9a605d2a0a40aae4739cb2fdae29ee9f7a6e9025a7fde4
ENV SRC_HASH_1_68_0=eaf4d8b19f23a232a4770fb53ab5e7acdedec11da1d02b0e5d491ca92ca96d62
ENV SRC_HASH_1_69_0=fb05971867ad6ccabbd3720279f5a94b99f61024923187b56bb5c455fa3cf60f
ENV SRC_HASH_1_70_0=b2bfae000b7a5040e4ec4bbc50a09f21548190cb7570b0ed77358368413bd27c
ENV SRC_HASH_1_71_0=a667e4abdc5588ebfea35c381e319d840ffbf8d2dbfb79771730573642034c96
ENV SRC_HASH_1_72_0=ea9d61bbb51d76b6ea681156f69f0e0596b59722f04414b01c6e100b4b5be3a1
ENV SRC_HASH_1_73_0=96d62e6d1f2d21df7ac8acb3b9882411f9e7c7036173f7f2ede9e1f1f6b1bb3a
ENV SRC_HASH_1_74_0=882b584bc321c5dcfe77cdaa69f277906b936255ef7808fcd5c7492925cf1049
ARG REGISTRY
ENV REGISTRY=${REGISTRY}
ARG VERSION
ENV VERSION=${VERSION}
ARG BUILD_VERSION
ENV BUILD_VERSION=${BUILD_VERSION}
ARG LLVM_VERSION
ENV LLVM_VERSION=${LLVM_VERSION}
COPY --from=binutils . /
COPY --from=bash . /
COPY --from=make . /
COPY --from=cmake . /
COPY --from=python . /
COPY --from=py-setuptools . /
COPY --from=zlib . /
COPY --from=pkgconf . /
COPY --from=openssl . /
COPY --from=llvm . /
COPY --from=perl . /
COPY --from=gcc . /
COPY --from=libunwind . /
COPY --from=musl . /
COPY --from=gcc . /
COPY --from=musl . /

FROM base as bootstrap-fetch
COPY --from=curl . /
RUN set -eux; \
    curl ${MRUSTC_SITE}/${MRUSTC_VERSION} -o mrustc.tar.gz; \
    echo "${MRUSTC_HASH}  mrustc.tar.gz" | sha256sum -c; \
    curl -OJ ${SRC_SITE}/rustc-${BOOTSTRAP_VERSION}-src.tar.gz; \
    echo "$(printenv SRC_HASH_${BOOTSTRAP_VERSION//./_})  rustc-${BOOTSTRAP_VERSION}-src.tar.gz" | sha256sum -c

FROM bootstrap-fetch as bootstrap-build
ENV MRUSTC_TARGET_VER=1.54
ENV RUSTC_VERSION=1.54.0
ENV RUSTC_TARGET=x86_64-unknown-linux-musl
ENV MRUSTC_DEBUG=Expand
ENV MRUSTC_DUMP_PROCMACRO=dump_prefix
ENV RUSTC_INSTALL_BINDIR=bin
ENV OUTDIR_SUF=
RUN tar -xzf mrustc.tar.gz
RUN mv lrvick-mrustc-* mrustc
WORKDIR mrustc
RUN set -eux; \
    cp ../rustc-${BOOTSTRAP_VERSION}-src.tar.gz .; \
    tar -xzf rustc-${BOOTSTRAP_VERSION}-src.tar.gz; \
    cd rustc-${BOOTSTRAP_VERSION}-src; \
    patch -p0 < ../rustc-${BOOTSTRAP_VERSION}-src.patch
RUN make
RUN make -f minicargo.mk LIBS
RUN make test local_tests
RUN make -f minicargo.mk LLVM_CONFIG=/usr/bin/llvm-config output/rustc
RUN make -f minicargo.mk LLVM_CONFIG=/usr/bin/llvm-config output/cargo
RUN make -C run_rustc LLVM_CONFIG=/usr/bin/llvm-config
RUN set -eux; \
    mkdir -p /home/user/rootfs/usr/bin /home/user/rootfs/usr/lib; \
    cp -R run_rustc/output/prefix/* /home/user/rootfs/; \
    rm /home/user/rootfs/bin/rustc; \
    mv /home/user/rootfs/bin/rustc_binary /home/user/rootfs/usr/bin/rustc; \
    mv /home/user/rootfs/bin/cargo /home/user/rootfs/usr/bin/; \
    mv /home/user/rootfs/lib/rustlib /home/user/rootfs/usr/lib/rustlib; \
    mv /home/user/rootfs/usr/lib/rustlib/x86_64-unknown-linux-musl/lib/librustc_driver.so /home/user/rootfs/usr/lib/
COPY --from=musl /lib/* /home/user/rootfs/lib/
COPY --from=gcc /usr/lib/* /home/user/rootfs/usr/lib/
COPY --from=gcc /usr/lib64/* /home/user/rootfs/usr/lib/

FROM scratch as bootstrap-package
USER 100:100
COPY --from=bootstrap-build /home/user/rootfs/ /
ENTRYPOINT ["/usr/bin/rustc"]
CMD ["--version"]

FROM base as fetch
COPY --from=curl . /
RUN curl -OJ ${SRC_SITE}/rustc-${VERSION}-src.tar.gz
RUN env
RUN echo "$(printenv SRC_HASH_${VERSION//./_})  rustc-${VERSION}-src.tar.gz"
RUN echo "$(printenv SRC_HASH_${VERSION//./_})  rustc-${VERSION}-src.tar.gz" | sha256sum -c

FROM ${REGISTRY}/rust:${BUILD_VERSION} as rust
FROM fetch as build
RUN tar -xzf rustc-${VERSION}-src.tar.gz
WORKDIR rustc-${VERSION}-src
COPY --from=rust . /
RUN set -eux; \
    ./configure \
        --build="x86_64-unknown-linux-musl" \
        --host="x86_64-unknown-linux-musl" \
        --target="x86_64-unknown-linux-musl" \
        --prefix="/usr" \
        --release-channel="stable" \
        --enable-local-rust \
        --local-rust-root="/usr" \
        --sysconfdir="/home/user/rootfs/etc" \
        --llvm-root="/usr/lib/llvm${LLVM_VERSION}" \
        --disable-docs \
        --tools="cargo" \
        --enable-llvm-link-shared \
        --enable-option-checking \
        --enable-locked-deps \
        --enable-vendor \
        --dist-compression-formats=gz \
        --python="python3" \
        --set="install.prefix=/home/user/rootfs/usr" \
        --set="build.extended=true" \
        --set="rust.musl-root=/usr" \
        --set="rust.backtrace-on-ice=true" \
        --set="rust.codegen-units=1" \
        --set="rust.codegen-units-std=1" \
        --set="rust.deny-warnings=false" \
        --set="rust.parallel-compiler=false" \
        --set="rust.remap-debuginfo=true" \
        --set="build.full-bootstrap=true" \
        --set="target.x86_64-unknown-linux-musl.crt-static=false" \
        --set="target.x86_64-unknown-linux-musl.musl-root=/usr" \
        --set="target.x86_64-unknown-linux-musl.llvm-config=/usr/bin/llvm-config" \
        --set="target.x86_64-unknown-linux-musl.cc=cc" \
        --set="target.x86_64-unknown-linux-musl.cxx=c++" \
        --set="target.x86_64-unknown-linux-musl.ar=ar" \
        --set="target.x86_64-unknown-linux-musl.linker=cc"; \
    python3 x.py dist
RUN python3 x.py install
COPY --from=musl /lib/* /home/user/rootfs/lib/
COPY --from=gcc /usr/lib/* /home/user/rootfs/usr/lib/
COPY --from=gcc /usr/lib64/* /home/user/rootfs/usr/lib/
COPY --from=llvm /usr/lib/* /home/user/rootfs/usr/lib/

FROM scratch as package
USER 100:100
COPY --from=build /home/user/rootfs/ /
ENTRYPOINT ["/usr/bin/rustc"]
CMD ["--version"]
