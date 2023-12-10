export SOURCE_DATE_EPOCH = 0
export REGISTRY := local
export BUILDER := $(shell which docker)

define build
	${BUILDER} \
		build \
		-t $(REGISTRY)/$(1):$(2) \
		--build-arg REGISTRY=$(REGISTRY) \
		--target $(3) \
		--output type=oci,dest=$@ \
		$(1)
endef

out/bootstrap.oci.tgz:
	$(call build,bootstrap)

out/musl.oci.tgz: \
	out/bootstrap.oci.tgz
	$(call build,musl)

out/busybox.oci.tgz: \
	out/bootstrap.oci.tgz
	$(call build,busybox)

out/binutils.oci.tgz: \
	out/bootstrap.oci.tgz \
	out/musl.oci.tgz
	$(call build,binutils)

out/linux-headers.oci.tgz:
	$(call build,linux-headers)

out/gcc.oci.tgz: \
	out/bootstrap.oci.tgz \
	out/musl.oci.tgz
	$(call build,gcc)

out/make.oci.tgz: \
	out/bootstrap.oci.tgz \
	out/musl.oci.tgz
	$(call build,make)

out/ca-certificates.oci.tgz:
	$(call build,ca-certificates)

out/bash.oci.tgz: \
	out/gcc.oci.tgz
	$(call build,bash)

out/m4.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz
	$(call build,m4)

out/autoconf.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/perl.oci.tgz \
	out/m4.oci.tgz
	$(call build,autoconf)

out/automake.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/perl.oci.tgz \
	out/autoconf.oci.tgz \
	out/m4.oci.tgz
	$(call build,automake)

out/sed.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz
	$(call build,sed)

out/libtool.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/bash.oci.tgz \
	out/sed.oci.tgz \
	out/m4.oci.tgz
	$(call build,libtool)

out/pkgconf.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/libtool.oci.tgz
	$(call build,pkgconf)

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
	$(call build,libxml2)

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
	$(call build,libunwind)

out/openssl.oci.tgz: \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/linux-headers.oci.tgz \
	out/musl.oci.tgz
	$(call build,openssl)

out/go.oci.tgz: \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/bash.oci.tgz \
	out/musl.oci.tgz
	$(call build,go)

out/perl.oci.tgz: \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/make.oci.tgz \
	out/musl.oci.tgz
	$(call build,perl)

out/curl.oci.tgz: \
	out/gcc.oci.tgz \
	out/musl.oci.tgz \
	out/busybox.oci.tgz \
	out/make.oci.tgz \
	out/binutils.oci.tgz \
	out/openssl.oci.tgz \
	out/ca-certificates.oci.tgz
	$(call build,curl)

out/python.oci.tgz: \
	out/gcc.oci.tgz \
	out/perl.oci.tgz \
	out/binutils.oci.tgz \
	out/busybox.oci.tgz \
	out/openssl.oci.tgz \
	out/make.oci.tgz \
	out/musl.oci.tgz
	$(call build,python)

out/ninja.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/openssl.oci.tgz \
	out/python.oci.tgz
	$(call build,ninja)

out/cmake.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/ninja.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz \
	out/linux-headers.oci.tgz
	$(call build,cmake)

out/py-setuptools.oci.tgz: \
	out/busybox.oci.tgz \
	out/python.oci.tgz
	$(call build,py-setuptools)

out/zlib.oci.tgz: \
	out/busybox.oci.tgz \
	out/gcc.oci.tgz \
	out/binutils.oci.tgz \
	out/musl.oci.tgz \
	out/make.oci.tgz
	$(call build,zlib)

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
	$(call build,llvm)

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
	$(call build,llvm13)

out/rust1.54.oci.tgz: \
	out/gcc.oci.tgz \
	out/bash.oci.tgz \
	out/zlib.oci.tgz \
	out/python.oci.tgz \
	out/py-setuptools.oci.tgz \
	out/curl.oci.tgz \
	out/perl.oci.tgz \
	out/libunwind.oci.tgz \
	out/llvm13.oci.tgz \
	out/binutils.oci.tgz \
	out/cmake.oci.tgz \
	out/make.oci.tgz \
	out/busybox.oci.tgz \
	out/musl.oci.tgz
	$(call build,rust,1.54.0,bootstrap)

out/rust1.55.oci.tgz: out/rust1.54.oci.tgz
	$(call build,rust,1.55.0)

test:
	docker build -t $(REGISTRY)/test-c tests/c
	docker build -t $(REGISTRY)/test-go tests/go
	docker build -t $(REGISTRY)/test-perl tests/perl
	@printf "\nOcirep Test Suite\n"
	@printf "go -> "
	@docker run -i $(REGISTRY)/test-go | grep Success
	@printf "c -> "
	@docker run -i $(REGISTRY)/test-c | grep Success
	@printf "perl -> "
	@docker run -i $(REGISTRY)/test-perl | grep Success
