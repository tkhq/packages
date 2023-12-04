export SOURCE_DATE_EPOCH = 0

out/bootstrap.oci.tgz:
	docker build -t imgrep/bootstrap --output type=oci,dest=$@ packages/bootstrap

out/musl.oci.tgz: \
	out/bootstrap.oci.tgz
	docker build -t imgrep/musl --output type=oci,dest=$@ packages/musl

out/busybox.oci.tgz: \
	out/bootstrap.oci.tgz
	docker build -t imgrep/busybox --output type=oci,dest=$@ packages/busybox

out/binutils.oci.tgz: \
	out/bootstrap.oci.tgz \
	out/musl.oci.tgz
	docker build -t imgrep/binutils --output type=oci,dest=$@ packages/binutils

out/linux-headers.oci.tgz:
	docker build -t imgrep/linux-headers --output type=oci,dest=$@ packages/linux-headers

out/gcc.oci.tgz: \
	out/bootstrap.oci.tgz \
	out/musl.oci.tgz
	docker build -t imgrep/gcc --output type=oci,dest=$@ packages/gcc

out/make.oci.tgz: \
	out/bootstrap.oci.tgz \
	out/musl.oci.tgz
	docker build -t imgrep/make --output type=oci,dest=$@ packages/make

out/ca-certificates.oci.tgz:
	docker build -t imgrep/ca-certificates --output type=oci,dest=$@ packages/ca-certificates

out/bash.oci.tgz: \
	out/gcc.oci.tgz
	docker build -t imgrep/bash --output type=oci,dest=$@ packages/bash

out/openssl.oci.tgz: \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/linux-headers.oci.tgz \
	out/musl.oci.tgz
	docker build -t imgrep/openssl --output type=oci,dest=$@ packages/openssl

out/go.oci.tgz: \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/bash.oci.tgz \
	out/musl.oci.tgz
	docker build -t imgrep/go --output type=oci,dest=$@ packages/go

out/perl.oci.tgz: \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/make.oci.tgz \
	out/musl.oci.tgz
	docker build -t imgrep/perl --output type=oci,dest=$@ packages/perl

out/curl.oci.tgz: \
	out/gcc.oci.tgz \
	out/musl.oci.tgz \
	out/busybox.oci.tgz \
	out/make.oci.tgz \
	out/binutils.oci.tgz \
	out/openssl.oci.tgz \
	out/ca-certificates.oci.tgz
	docker build -t imgrep/curl --output type=oci,dest=$@ packages/curl

out/python.oci.tgz: \
	out/gcc.oci.tgz \
	out/perl.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/openssl.oci.tgz \
	out/make.oci.tgz \
	out/musl.oci.tgz
	docker build -t imgrep/python --output type=oci,dest=$@ packages/python

out/ninja.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/openssl.oci.tgz \
	out/python.oci.tgz
	docker build -t imgrep/ninja --output type=oci,dest=$@ packages/ninja

out/cmake.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/ninja.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/linux-headers.oci.tgz
	docker build -t imgrep/cmake --output type=oci,dest=$@ packages/cmake

out/py-setuptools.oci.tgz: \
	out/busybox.oci.tgz \
	out/python.oci.tgz
	docker build -t imgrep/py-setuptools --output type=oci,dest=$@ packages/py-setuptools

out/zlib.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz
	docker build -t imgrep/zlib --output type=oci,dest=$@ packages/zlib

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
	docker build -t imgrep/llvm --output type=oci,dest=$@ packages/llvm

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
	docker build -t imgrep/llvm13 --output type=oci,dest=$@ packages/llvm13

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
	docker build -t imgrep/rust --output type=oci,dest=$@ packages/rust

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
