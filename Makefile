out/gcc.oci.tgz:
	docker build -f packages/gcc/Dockerfile -t ocirep/gcc .

out/bash.oci.tgz:
	docker build -f packages/bash/Dockerfile -t ocirep/bash .

out/busybox.oci.tgz:
	docker build -f packages/busybox/Dockerfile -t ocirep/busybox .

out/go.oci.tgz:
	docker build -f packages/go/Dockerfile -t ocirep/go .
