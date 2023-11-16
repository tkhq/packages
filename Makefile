export SOURCE_DATE_EPOCH = 0

out/bootstrap.oci.tgz:
	docker build -t ocirep/bootstrap --output type=oci,dest=$@ packages/bootstrap

out/musl.oci.tgz: \
	out/bootstrap.oci.tgz
	docker build -t ocirep/musl --output type=oci,dest=$@ packages/musl

out/busybox.oci.tgz: \
	out/bootstrap.oci.tgz
	docker build -t ocirep/busybox --output type=oci,dest=$@ packages/busybox

out/binutils.oci.tgz: \
	out/bootstrap.oci.tgz \
	out/musl.oci.tgz
	docker build -t ocirep/musl --output type=oci,dest=$@ packages/musl

out/linux-headers.oci.tgz: \
	docker build -t ocirep/linux-headers --output type=oci,dest=$@ packages/linux-heades

out/gcc.oci.tgz: \
	out/bootstrap.oci.tgz \
	out/musl.oci.tgz
	docker build -t ocirep/gcc --output type=oci,dest=$@ packages/gcc

out/make.oci.tgz: \
	out/bootstrap.oci.tgz \
	out/musl.oci.tgz
	docker build -t ocirep/make --output type=oci,dest=$@ packages/make

out/bash.oci.tgz: \
	out/gcc.oci.tgz
	docker build -t ocirep/bash --output type=oci,dest=$@ packages/bash

out/openssl.oci.tgz: \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/musl.oci.tgz
	docker build -t ocirep/openssl --output type=oci,dest=$@ packages/openssl

out/go.oci.tgz: \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/bash.oci.tgz \
	out/musl.oci.tgz
	docker build -t ocirep/go --output type=oci,dest=$@ packages/go

out/perl.oci.tgz: \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/musl.oci.tgz
	docker build -t ocirep/perl --output type=oci,dest=$@ packages/perl

out/python.oci.tgz: \
	out/gcc.oci.tgz \
	out/perl.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/openssl.oci.tgz \
	out/make.oci.tgz \
	out/musl.oci.tgz
	docker build -t ocirep/python --output type=oci,dest=$@ packages/python

test:
	docker build -t ocirep/test-c tests/c
	docker build -t ocirep/test-go tests/go
	docker build -t ocirep/test-python tests/python
	docker build -t ocirep/test-perl tests/perl

	@printf "\nOcirep Test Suite\n"
	@printf "go -> "
	@docker run -i ocirep/test-go | grep Success
	@printf "c -> "
	@docker run -i ocirep/test-c | grep Success
	@printf "perl -> "
	@docker run -i ocirep/test-perl | grep Success
	@printf "python -> "
	@docker run -i ocirep/test-python | grep Success
