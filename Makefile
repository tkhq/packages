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

out/bash.oci.tgz: \
	out/gcc.oci.tgz
	docker build -t ocirep/bash --output type=oci,dest=$@ packages/bash

out/go.oci.tgz: \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/bash.oci.tgz \
	out/musl.oci.tgz
	docker build -t ocirep/go --output type=oci,dest=$@ packages/go
