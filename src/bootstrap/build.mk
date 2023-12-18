.PHONY: bootstrap
core: \
	out/gcc.tgz \
	out/musl.tgz \
	out/make.tgz \
	out/binutils.tgz \
	out/busybox.tgz

out/bootstrap.tgz:
	$(call build,bootstrap,bootstrap)

out/musl.tgz: out/bootstrap.tgz
	$(call build,bootstrap,musl)

out/busybox.tgz: out/bootstrap.tgz
	$(call build,bootstrap,busybox)

out/binutils.tgz: out/bootstrap.tgz
	$(call build,bootstrap,binutils)

out/gcc.tgz: out/bootstrap.tgz out/musl.tgz
	$(call build,bootstrap,gcc)

out/make.tgz: out/bootstrap.tgz
	$(call build,bootstrap,make)
