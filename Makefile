export SOURCE_DATE_EPOCH = 0

out/bootstrap.oci.tgz:
	docker build -t imgrep/bootstrap --output type=oci,dest=$@ bootstrap

out/musl.oci.tgz: \
	out/bootstrap.oci.tgz
	docker build -t imgrep/musl --output type=oci,dest=$@ musl

out/busybox.oci.tgz: \
	out/bootstrap.oci.tgz
	docker build -t imgrep/busybox --output type=oci,dest=$@ busybox

out/binutils.oci.tgz: \
	out/bootstrap.oci.tgz \
	out/musl.oci.tgz
	docker build -t imgrep/binutils --output type=oci,dest=$@ binutils

out/linux-headers.oci.tgz:
	docker build -t imgrep/linux-headers --output type=oci,dest=$@ linux-headers

out/gcc.oci.tgz: \
	out/bootstrap.oci.tgz \
	out/musl.oci.tgz
	docker build -t imgrep/gcc --output type=oci,dest=$@ gcc

out/make.oci.tgz: \
	out/bootstrap.oci.tgz \
	out/musl.oci.tgz
	docker build -t imgrep/make --output type=oci,dest=$@ make

out/ca-certificates.oci.tgz:
	docker build -t imgrep/ca-certificates --output type=oci,dest=$@ ca-certificates

out/bash.oci.tgz: \
	out/gcc.oci.tgz
	docker build -t imgrep/bash --output type=oci,dest=$@ bash

out/m4.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz
	docker build -t imgrep/m4 --output type=oci,dest=$@ m4

out/autoconf.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/perl.oci.tgz \
	out/m4.oci.tgz
	docker build -t imgrep/autoconf --output type=oci,dest=$@ autoconf

out/automake.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/perl.oci.tgz \
	out/autoconf.oci.tgz \
	out/m4.oci.tgz
	docker build -t imgrep/automake --output type=oci,dest=$@ automake

out/sed.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz
	docker build -t imgrep/sed --output type=oci,dest=$@ sed

out/libtool.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/bash.oci.tgz \
	out/sed.oci.tgz \
	out/m4.oci.tgz
	docker build -t imgrep/libtool --output type=oci,dest=$@ libtool

out/pkgconf.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/libtool.oci.tgz
	docker build -t imgrep/pkgconf --output type=oci,dest=$@ pkgconf

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
	docker build -t imgrep/libxml2 --output type=oci,dest=$@ libxml2

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
	docker build -t imgrep/libunwind --output type=oci,dest=$@ libunwind

out/openssl.oci.tgz: \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/linux-headers.oci.tgz \
	out/musl.oci.tgz
	docker build -t imgrep/openssl --output type=oci,dest=$@ openssl

out/go.oci.tgz: \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/bash.oci.tgz \
	out/musl.oci.tgz
	docker build -t imgrep/go --output type=oci,dest=$@ go

out/perl.oci.tgz: \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/make.oci.tgz \
	out/musl.oci.tgz
	docker build -t imgrep/perl --output type=oci,dest=$@ perl

out/curl.oci.tgz: \
	out/gcc.oci.tgz \
	out/musl.oci.tgz \
	out/busybox.oci.tgz \
	out/make.oci.tgz \
	out/binutils.oci.tgz \
	out/openssl.oci.tgz \
	out/ca-certificates.oci.tgz
	docker build -t imgrep/curl --output type=oci,dest=$@ curl

out/python.oci.tgz: \
	out/gcc.oci.tgz \
	out/perl.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/openssl.oci.tgz \
	out/make.oci.tgz \
	out/musl.oci.tgz
	docker build -t imgrep/python --output type=oci,dest=$@ python

out/ninja.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/openssl.oci.tgz \
	out/python.oci.tgz
	docker build -t imgrep/ninja --output type=oci,dest=$@ ninja

out/cmake.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/ninja.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/linux-headers.oci.tgz
	docker build -t imgrep/cmake --output type=oci,dest=$@ cmake

out/py-setuptools.oci.tgz: \
	out/busybox.oci.tgz \
	out/python.oci.tgz
	docker build -t imgrep/py-setuptools --output type=oci,dest=$@ py-setuptools

out/zlib.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz
	docker build -t imgrep/zlib --output type=oci,dest=$@ zlib

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
	docker build -t imgrep/llvm --output type=oci,dest=$@ llvm

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
	docker build -t imgrep/llvm13 --output type=oci,dest=$@ llvm13

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
	docker build -t imgrep/rust --output type=oci,dest=$@ rust

test:
	docker build -t imgrep/test-c tests/c
	docker build -t imgrep/test-go tests/go
	docker build -t imgrep/test-perl tests/perl
	@printf "\nOcirep Test Suite\n"
	@printf "go -> "
	@docker run -i imgrep/test-go | grep Success
	@printf "c -> "
	@docker run -i imgrep/test-c | grep Success
	@printf "perl -> "
	@docker run -i imgrep/test-perl | grep Success
