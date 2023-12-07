export SOURCE_DATE_EPOCH = 0

out/bootstrap.oci.tgz:
	docker build -t distrust/bootstrap --output type=oci,dest=$@ bootstrap

out/musl.oci.tgz: \
	out/bootstrap.oci.tgz
	docker build -t distrust/musl --output type=oci,dest=$@ musl

out/busybox.oci.tgz: \
	out/bootstrap.oci.tgz
	docker build -t distrust/busybox --output type=oci,dest=$@ busybox

out/binutils.oci.tgz: \
	out/bootstrap.oci.tgz \
	out/musl.oci.tgz
	docker build -t distrust/binutils --output type=oci,dest=$@ binutils

out/linux-headers.oci.tgz:
	docker build -t distrust/linux-headers --output type=oci,dest=$@ linux-headers

out/gcc.oci.tgz: \
	out/bootstrap.oci.tgz \
	out/musl.oci.tgz
	docker build -t distrust/gcc --output type=oci,dest=$@ gcc

out/make.oci.tgz: \
	out/bootstrap.oci.tgz \
	out/musl.oci.tgz
	docker build -t distrust/make --output type=oci,dest=$@ make

out/ca-certificates.oci.tgz:
	docker build -t distrust/ca-certificates --output type=oci,dest=$@ ca-certificates

out/bash.oci.tgz: \
	out/gcc.oci.tgz
	docker build -t distrust/bash --output type=oci,dest=$@ bash

out/m4.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz
	docker build -t distrust/m4 --output type=oci,dest=$@ m4

out/autoconf.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/perl.oci.tgz \
	out/m4.oci.tgz
	docker build -t distrust/autoconf --output type=oci,dest=$@ autoconf

out/automake.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/perl.oci.tgz \
	out/autoconf.oci.tgz \
	out/m4.oci.tgz
	docker build -t distrust/automake --output type=oci,dest=$@ automake

out/sed.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz
	docker build -t distrust/sed --output type=oci,dest=$@ sed

out/libtool.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/bash.oci.tgz \
	out/sed.oci.tgz \
	out/m4.oci.tgz
	docker build -t distrust/libtool --output type=oci,dest=$@ libtool

out/pkgconf.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/libtool.oci.tgz
	docker build -t distrust/pkgconf --output type=oci,dest=$@ pkgconf

out/libxml2.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/bash.oci.tgz \
	out/python.oci.tgz \
	out/sed.oci.tgz \
	out/m4.oci.tgz \
	out/autoconf.oci.tgz \
	out/automake.oci.tgz \
	out/pkgconf.oci.tgz \
	out/libtool.oci.tgz
	docker build -t distrust/libxml2 --output type=oci,dest=$@ libxml2

out/libunwind.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/bash.oci.tgz \
	out/autoconf.oci.tgz \
	out/automake.oci.tgz \
	out/libtool.oci.tgz
	docker build -t distrust/libunwind --output type=oci,dest=$@ libunwind

out/openssl.oci.tgz: \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/linux-headers.oci.tgz \
	out/musl.oci.tgz
	docker build -t distrust/openssl --output type=oci,dest=$@ openssl

out/go.oci.tgz: \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/bash.oci.tgz \
	out/musl.oci.tgz
	docker build -t distrust/go --output type=oci,dest=$@ go

out/perl.oci.tgz: \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/make.oci.tgz \
	out/musl.oci.tgz
	docker build -t distrust/perl --output type=oci,dest=$@ perl

out/curl.oci.tgz: \
	out/gcc.oci.tgz \
	out/musl.oci.tgz \
	out/busybox.oci.tgz \
	out/make.oci.tgz \
	out/binutils.oci.tgz \
	out/openssl.oci.tgz \
	out/ca-certificates.oci.tgz
	docker build -t distrust/curl --output type=oci,dest=$@ curl

out/python.oci.tgz: \
	out/gcc.oci.tgz \
	out/perl.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/openssl.oci.tgz \
	out/make.oci.tgz \
	out/musl.oci.tgz
	docker build -t distrust/python --output type=oci,dest=$@ python

out/ninja.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/openssl.oci.tgz \
	out/python.oci.tgz
	docker build -t distrust/ninja --output type=oci,dest=$@ ninja

out/cmake.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/ninja.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/linux-headers.oci.tgz
	docker build -t distrust/cmake --output type=oci,dest=$@ cmake

out/py-setuptools.oci.tgz: \
	out/busybox.oci.tgz \
	out/python.oci.tgz
	docker build -t distrust/py-setuptools --output type=oci,dest=$@ py-setuptools

out/zlib.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz
	docker build -t distrust/zlib --output type=oci,dest=$@ zlib

out/llvm.oci.tgz: \
	out/gcc.oci.tgz \
	out/python.oci.tgz \
	out/py-setuptools.oci.tgz \
	out/perl.oci.tgz \
	out/binutils.oci.tgz \
	out/cmake.oci.tgz \
	out/ninja.oci.tgz \
	out/busybox.oci.tgz \
	out/musl.oci.tgz
	docker build -t distrust/llvm --output type=oci,dest=$@ llvm

out/llvm13.oci.tgz: \
	out/gcc.oci.tgz \
	out/python.oci.tgz \
	out/py-setuptools.oci.tgz \
	out/perl.oci.tgz \
	out/binutils.oci.tgz \
	out/cmake.oci.tgz \
	out/ninja.oci.tgz \
	out/busybox.oci.tgz \
	out/musl.oci.tgz
	docker build -t distrust/llvm13 --output type=oci,dest=$@ llvm13

out/rust.oci.tgz: \
	out/gcc.oci.tgz \
	out/bash.oci.tgz \
	out/zlib.oci.tgz \
	out/python.oci.tgz \
	out/binutils.oci.tgz \
	out/cmake.oci.tgz \
	out/make.oci.tgz \
	out/busybox.oci.tgz \
	out/musl.oci.tgz
	docker build -t distrust/rust --output type=oci,dest=$@ rust

test:
	docker build -t distrust/test-c tests/c
	docker build -t distrust/test-go tests/go
	docker build -t distrust/test-perl tests/perl
	@printf "\nOcirep Test Suite\n"
	@printf "go -> "
	@docker run -i distrust/test-go | grep Success
	@printf "c -> "
	@docker run -i distrust/test-c | grep Success
	@printf "perl -> "
	@docker run -i distrust/test-perl | grep Success
