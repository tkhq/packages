export SOURCE_DATE_EPOCH = 0

out/bootstrap.oci.tgz:
	docker build -t ocirep/bootstrap --output type=oci,dest=$@ packages/bootstrap

out/gcc.oci.tgz: \
	out/bootstrap.oci.tgz
	docker build -t ocirep/gcc --output type=oci,dest=$@ packages/gcc

out/glibc.oci.tgz: \
	out/gcc.oci.tgz
	docker build -t ocirep/glibc --output type=oci,dest=$@ packages/glibc

out/bash.oci.tgz: \
	out/gcc.oci.tgz \
	out/glibc.oci.tgz
	docker build -t ocirep/bash --output type=oci,dest=$@ packages/bash

out/busybox.oci.tgz: \
	out/gcc.oci.tgz \
	out/glibc.oci.tgz
	docker build -t ocirep/busybox --output type=oci,dest=$@ packages/busybox

out/go.oci.tgz: \
	out/gcc.oci.tgz \
	out/glibc.oci.tgz \
	out/busybox.oci.tgz \
	out/bash.oci.tgz
	docker build -t ocirep/go --output type=oci,dest=$@ packages/go
