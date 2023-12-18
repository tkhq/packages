out/libxml2.tgz: \
	out/busybox.tgz \
	out/gcc.tgz \
	out/binutils.tgz \
	out/musl.tgz \
	out/make.tgz \
	out/bash.tgz \
	out/python.tgz \
	out/sed.tgz \
	out/m4.tgz \
	out/autoconf.tgz \
	out/automake.tgz \
	out/pkgconf.tgz \
	out/libtool.tgz
	$(call build,libs,libxml2)

out/ca-certificates.tgz:
	$(call build,libs,ca-certificates)
