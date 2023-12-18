out/curl.tgz: \
	out/gcc.tgz \
	out/musl.tgz \
	out/busybox.tgz \
	out/make.tgz \
	out/binutils.tgz \
	out/openssl.tgz \
	out/ca-certificates.tgz
	$(call build,tools,curl)
