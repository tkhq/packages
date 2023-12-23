out/curl.tgz: \
	out/gcc.tgz \
	out/musl.tgz \
	out/busybox.tgz \
	out/make.tgz \
	out/binutils.tgz \
	out/openssl.tgz \
	out/ca-certificates.tgz
	$(call build,tools,curl)

out/tofu.tgz: \
	out/busybox.tgz \
	out/go.tgz
	$(call build,tools,tofu)