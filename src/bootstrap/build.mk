.PHONY: bootstrap
bootstrap: \
	out/bootstrap.tgz \
	out/stage0.tgz

out/bootstrap.tgz:
	$(call build,bootstrap,bootstrap)

out/stage0.tgz:
	$(call build,bootstrap,stage0)

out/live.tgz: out/stage0.tgz
	$(call build,bootstrap,live)
