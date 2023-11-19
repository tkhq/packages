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
