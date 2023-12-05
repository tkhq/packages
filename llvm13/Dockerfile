FROM imgrep/busybox:latest as busybox
FROM imgrep/gcc:latest as gcc
FROM imgrep/binutils:latest as binutils
FROM imgrep/musl:latest as musl
FROM imgrep/openssl:latest as openssl
FROM imgrep/python:latest as python
FROM imgrep/py-setuptools:latest as py-setuptools
FROM imgrep/cmake:latest as cmake
FROM imgrep/ninja:latest as ninja

FROM busybox as build
ENV SRC_SITE=https://github.com/llvm/llvm-project/releases/download
ENV SRC_VERSION=13.0.1
ENV SRC_HASH=326335a830f2e32d06d0a36393b5455d17dc73e0bd1211065227ee014f92cbf8
RUN wget ${SRC_SITE}/llvmorg-${SRC_VERSION}/llvm-project-${SRC_VERSION}.src.tar.xz
RUN echo "${SRC_HASH}  llvm-project-${SRC_VERSION}.src.tar.xz" | sha256sum -c
RUN tar -xf llvm-project-${SRC_VERSION}.src.tar.xz
WORKDIR llvm-project-${SRC_VERSION}.src
RUN ls -lah .
ADD . .
RUN patch -p1 < rust-feature-tables.patch
COPY --from=binutils . /
COPY --from=cmake . /
COPY --from=ninja . /
COPY --from=musl . /
COPY --from=gcc . /
COPY --from=python . /
COPY --from=py-setuptools . /

RUN set -eux; \
    python -c "import setuptools; print(setuptools.__version__)"; \
    cmake \
        -B build \
        -G Ninja \
        -Wno-dev -S llvm \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr/ \
		-DCMAKE_INSTALL_RPATH=/usr/ \
		-DLLVM_DEFAULT_TARGET_TRIPLE="x86_64-linux-musl" \
		-DLLVM_HOST_TRIPLE="x86_64-linux-musl" \
		-DLLVM_APPEND_VC_REV=OFF \
		-DLLVM_BINUTILS_INCDIR=/usr/include \
		-DLLVM_BUILD_DOCS=OFF \
		-DLLVM_BUILD_EXAMPLES=OFF \
		-DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON \
		-DLLVM_BUILD_LLVM_DYLIB=ON \
		-DLLVM_BUILD_TESTS=ON \
		-DLLVM_ENABLE_ASSERTIONS=OFF \
		-DLLVM_ENABLE_DUMP=ON \
		-DLLVM_ENABLE_EH=ON \
		-DLLVM_ENABLE_FFI=OFF \
		-DLLVM_ENABLE_LIBCXX=OFF \
		-DLLVM_ENABLE_LIBEDIT=OFF \
		-DLLVM_ENABLE_PIC=ON \
		-DLLVM_ENABLE_RTTI=ON \
		-DLLVM_ENABLE_SPHINX=OFF \
		-DLLVM_ENABLE_TERMINFO=ON \
		-DLLVM_ENABLE_ZLIB=OFF \
		-DLLVM_ENABLE_ZSTD=OFF \
		-DLLVM_INCLUDE_BENCHMARKS=OFF \
		-DLLVM_INCLUDE_EXAMPLES=OFF \
		-DLLVM_INSTALL_UTILS=ON \
		-DLLVM_LINK_LLVM_DYLIB=ON \
		-DLLVM_USE_PERF=ON; \
	cmake --build build; \
    python3 llvm/utils/lit/setup.py build

RUN set -eux; \
    export DESTDIR="/home/user/rootfs/"; \
    cmake --install build; \
	python3 llvm/utils/lit/setup.py install --root="$DESTDIR"

COPY --from=musl /lib/* /home/user/rootfs/lib/
COPY --from=gcc /usr/lib/* /home/user/rootfs/usr/lib/
COPY --from=gcc /usr/lib64/* /home/user/rootfs/usr/lib/

FROM scratch
COPY --from=build /home/user/rootfs /
USER 100:100
ENTRYPOINT ["/usr/bin/llc"]
CMD ["--version"]
