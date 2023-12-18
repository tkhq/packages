.PHONY: core
core: \
	out/rust.tgz \
	out/go.tgz \
	out/python.tgz \
	out/perl.tgz \
	out/gcc.tgz \
	out/llvm.tgz

out/bash.tgz: \
	out/busybox.tgz \
	out/gcc.tgz \
	out/binutils.tgz \
	out/musl.tgz \
	out/make.tgz
	$(call build,core,bash)

out/m4.tgz: \
	out/busybox.tgz \
	out/gcc.tgz \
	out/binutils.tgz \
	out/musl.tgz \
	out/make.tgz
	$(call build,core,m4)

out/perl.tgz: \
	out/gcc.tgz \
	out/binutils.tgz \
	out/busybox.tgz \
	out/make.tgz \
	out/musl.tgz
	$(call build,core,perl)

out/autoconf.tgz: \
	out/busybox.tgz \
	out/gcc.tgz \
	out/binutils.tgz \
	out/musl.tgz \
	out/make.tgz \
	out/perl.tgz \
	out/m4.tgz
	$(call build,core,autoconf,,fetch)
	$(call build,core,autoconf)

out/automake.tgz: \
	out/busybox.tgz \
	out/gcc.tgz \
	out/binutils.tgz \
	out/musl.tgz \
	out/make.tgz \
	out/perl.tgz \
	out/autoconf.tgz \
	out/m4.tgz
	$(call build,core,automake)

out/sed.tgz: \
	out/busybox.tgz \
	out/gcc.tgz \
	out/binutils.tgz \
	out/musl.tgz \
	out/make.tgz
	$(call build,core,sed)

out/libtool.tgz: \
	out/busybox.tgz \
	out/gcc.tgz \
	out/binutils.tgz \
	out/musl.tgz \
	out/make.tgz \
	out/bash.tgz \
	out/sed.tgz \
	out/m4.tgz
	$(call build,core,libtool)

out/pkgconf.tgz: \
	out/busybox.tgz \
	out/gcc.tgz \
	out/binutils.tgz \
	out/musl.tgz \
	out/make.tgz \
	out/libtool.tgz
	$(call build,core,pkgconf)

out/libunwind.tgz: \
	out/busybox.tgz \
	out/gcc.tgz \
	out/binutils.tgz \
	out/musl.tgz \
	out/make.tgz \
	out/bash.tgz \
	out/autoconf.tgz \
	out/automake.tgz \
	out/libtool.tgz
	$(call build,core,libunwind)

out/linux-headers.tgz:
	$(call build,core,linux-headers)

out/openssl.tgz: \
	out/gcc.tgz \
	out/binutils.tgz \
	out/busybox.tgz \
	out/linux-headers.tgz \
	out/musl.tgz
	$(call build,core,openssl)

out/go.tgz: \
	out/gcc.tgz \
	out/binutils.tgz \
	out/busybox.tgz \
	out/bash.tgz \
	out/musl.tgz
	$(call build,core,go)

out/python.tgz: \
	out/gcc.tgz \
	out/perl.tgz \
	out/binutils.tgz \
	out/busybox.tgz \
	out/openssl.tgz \
	out/make.tgz \
	out/musl.tgz
	$(call build,core,python)

out/ninja.tgz: \
	out/busybox.tgz \
	out/gcc.tgz \
	out/binutils.tgz \
	out/musl.tgz \
	out/make.tgz \
	out/openssl.tgz \
	out/python.tgz
	$(call build,core,ninja)

out/cmake.tgz: \
	out/busybox.tgz \
	out/gcc.tgz \
	out/binutils.tgz \
	out/ninja.tgz \
	out/musl.tgz \
	out/make.tgz \
	out/linux-headers.tgz
	$(call build,core,cmake)

out/py-setuptools.tgz: \
	out/busybox.tgz \
	out/python.tgz
	$(call build,core,py-setuptools)

out/zlib.tgz: \
	out/busybox.tgz \
	out/gcc.tgz \
	out/binutils.tgz \
	out/musl.tgz \
	out/make.tgz
	$(call build,core,zlib)

out/llvm13.tgz: \
	out/gcc.tgz \
	out/python.tgz \
	out/py-setuptools.tgz \
	out/perl.tgz \
	out/binutils.tgz \
	out/cmake.tgz \
	out/ninja.tgz \
	out/busybox.tgz \
	out/musl.tgz
	$(call build,core,llvm,13.0.1)

out/llvm.tgz: \
	out/gcc.tgz \
	out/python.tgz \
	out/py-setuptools.tgz \
	out/perl.tgz \
	out/binutils.tgz \
	out/cmake.tgz \
	out/ninja.tgz \
	out/busybox.tgz \
	out/musl.tgz
	$(call build,core,llvm)
	$(BUILDER) tag $(REGISTRY)/llvm $(REGISTRY)/llvm:16
	$(BUILDER) tag $(REGISTRY)/llvm $(REGISTRY)/llvm:16.0.6

out/rust1.54.tgz: \
	out/gcc.tgz \
	out/bash.tgz \
	out/zlib.tgz \
	out/python.tgz \
	out/py-setuptools.tgz \
	out/perl.tgz \
	out/libunwind.tgz \
	out/pkgconf.tgz \
	out/llvm13.tgz \
	out/binutils.tgz \
	out/cmake.tgz \
	out/make.tgz \
	out/busybox.tgz \
	out/musl.tgz
	$(call build,core,rust,1.54.0,bootstrap-package)

out/rust1.55.tgz: out/rust1.54.tgz
	$(call build,core,rust,1.55.0,package,--build-arg BUILD_VERSION=1.54.0)

out/rust1.56.tgz: out/rust1.55.tgz
	$(call build,core,rust,1.56.0,package,--build-arg BUILD_VERSION=1.55.0)

out/rust1.57.tgz: out/rust1.56.tgz
	$(call build,core,rust,1.57.0,package,--build-arg BUILD_VERSION=1.56.0)

out/rust1.58.tgz: out/rust1.57.tgz
	$(call build,core,rust,1.58.0,package,--build-arg BUILD_VERSION=1.57.0)

out/rust1.59.tgz: out/rust1.58.tgz
	$(call build,core,rust,1.59.0,package,--build-arg BUILD_VERSION=1.58.0)

out/rust1.60.tgz: out/rust1.59.tgz
	$(call build,core,rust,1.60.0,package,--build-arg BUILD_VERSION=1.59.0)

out/rust1.61.tgz: out/rust1.60.tgz
	$(call build,core,rust,1.61.0,package,--build-arg BUILD_VERSION=1.60.0)

out/rust1.62.tgz: out/rust1.61.tgz
	$(call build,core,rust,1.62.0,package,--build-arg BUILD_VERSION=1.61.0)

out/rust1.63.tgz: out/rust1.62.tgz
	$(call build,core,rust,1.63.0,package,--build-arg BUILD_VERSION=1.62.0)

out/rust1.64.tgz: out/rust1.63.tgz
	$(call build,core,rust,1.64.0,package,--build-arg BUILD_VERSION=1.63.0)

out/rust1.65.tgz: out/rust1.64.tgz
	$(call build,core,rust,1.65.0,package,--build-arg BUILD_VERSION=1.64.0)

out/rust1.66.tgz: out/rust1.65.tgz
	$(call build,core,rust,1.66.0,package,--build-arg BUILD_VERSION=1.65.0)

out/rust1.67.tgz: out/rust1.66.tgz
	$(call build,core,rust,1.67.0,package,--build-arg BUILD_VERSION=1.66.0)

out/rust1.68.tgz: out/rust1.67.tgz
	$(call build,core,rust,1.68.0,package,--build-arg BUILD_VERSION=1.67.0)

out/rust1.69.tgz: out/rust1.68.tgz llvm.tgz
	$(call build,core,rust,1.69.0,package,--build-arg BUILD_VERSION=1.68.0 --build-arg LLVM_VERSION=16)

out/rust1.70.tgz: out/rust1.69.tgz
	$(call build,core,rust,1.70.0,package,--build-arg BUILD_VERSION=1.69.0 --build-arg LLVM_VERSION=16)

out/rust1.71.tgz: out/rust1.70.tgz
	$(call build,core,rust,1.71.0,package,--build-arg BUILD_VERSION=1.70.0 --build-arg LLVM_VERSION=16)

out/rust1.72.tgz: out/rust1.71.tgz
	$(call build,core,rust,1.72.0,package,--build-arg BUILD_VERSION=1.71.0 --build-arg LLVM_VERSION=16)

out/rust1.73.tgz: out/rust1.72.tgz
	$(call build,core,rust,1.73.0,package,--build-arg BUILD_VERSION=1.72.0 --build-arg LLVM_VERSION=16)

out/rust.tgz: out/rust1.73.tgz
	$(call build,core,rust,1.74.0,package,--build-arg BUILD_VERSION=1.73.0 --build-arg LLVM_VERSION=16)
