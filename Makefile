export REGISTRY := local
export PLATFORM := linux/amd64
export BUILDER := $(shell which docker)
export SOURCE_DATE_EPOCH = 0
clean_logs := $(shell rm *.log 2>&1 >/dev/null || :)

DEFAULT_GOAL := default
.PHONY: default
default: all
.PHONY: all
all: \
	bootstrap.tgz \
	gcc.tgz \
	busybox.tgz \
	binutils.tgz \
	musl.tgz \
	make.tgz \
	bash.tgz \
	zlib.tgz \
	perl.tgz \
	linux-headers.tgz \
	openssl.tgz \
	python.tgz \
	py-setuptools.tgz \
	ca-certificates.tgz \
	curl.tgz \
	m4.tgz \
	autoconf.tgz \
	automake.tgz \
	sed.tgz \
	libtool.tgz \
	libunwind.tgz \
	ninja.tgz \
	cmake.tgz \
	libxml2 \
	llvm13.tgz \
	rust1.54.tgz \
	llvm.tgz \
	rust1.55.tgz

bootstrap.tgz:
	$(call build,bootstrap)

musl.tgz: bootstrap.tgz
	$(call build,musl)

busybox.tgz: bootstrap.tgz
	$(call build,busybox)

binutils.tgz: bootstrap.tgz
	$(call build,binutils)

gcc.tgz: \
	bootstrap.tgz \
	musl.tgz
	$(call build,gcc)

make.tgz: bootstrap.tgz
	$(call build,make)

ca-certificates.tgz:
	$(call build,ca-certificates)

bash.tgz: \
	busybox.tgz \
	gcc.tgz \
	binutils.tgz \
	musl.tgz \
	make.tgz
	$(call build,bash)

m4.tgz: \
	busybox.tgz \
	gcc.tgz \
	binutils.tgz \
	musl.tgz \
	make.tgz
	$(call build,m4)

perl.tgz: \
	gcc.tgz \
	binutils.tgz \
	busybox.tgz \
	make.tgz \
	musl.tgz
	$(call build,perl)

autoconf.tgz: \
	busybox.tgz \
	gcc.tgz \
	binutils.tgz \
	musl.tgz \
	make.tgz \
	perl.tgz \
	m4.tgz
	$(call build,autoconf,,fetch)
	$(call build,autoconf)

automake.tgz: \
	busybox.tgz \
	gcc.tgz \
	binutils.tgz \
	musl.tgz \
	make.tgz \
	perl.tgz \
	autoconf.tgz \
	m4.tgz
	$(call build,automake)

sed.tgz: \
	busybox.tgz \
	gcc.tgz \
	binutils.tgz \
	musl.tgz \
	make.tgz
	$(call build,sed)

libtool.tgz: \
	busybox.tgz \
	gcc.tgz \
	binutils.tgz \
	musl.tgz \
	make.tgz \
	bash.tgz \
	sed.tgz \
	m4.tgz
	$(call build,libtool)

pkgconf.tgz: \
	busybox.tgz \
	gcc.tgz \
	binutils.tgz \
	musl.tgz \
	make.tgz \
	libtool.tgz
	$(call build,pkgconf)

libxml2.tgz: \
	busybox.tgz \
	gcc.tgz \
	binutils.tgz \
	musl.tgz \
	make.tgz \
	bash.tgz \
	python.tgz \
	sed.tgz \
	m4.tgz \
	autoconf.tgz \
	automake.tgz \
	pkgconf.tgz \
	libtool.tgz
	$(call build,libxml2)

libunwind.tgz: \
	busybox.tgz \
	gcc.tgz \
	binutils.tgz \
	musl.tgz \
	make.tgz \
	bash.tgz \
	autoconf.tgz \
	automake.tgz \
	libtool.tgz
	$(call build,libunwind)

linux-headers.tgz:
	$(call build,linux-headers)

openssl.tgz: \
	gcc.tgz \
	binutils.tgz \
	busybox.tgz \
	linux-headers.tgz \
	musl.tgz
	$(call build,openssl)

go.tgz: \
	gcc.tgz \
	binutils.tgz \
	busybox.tgz \
	bash.tgz \
	musl.tgz
	$(call build,go)

curl.tgz: \
	gcc.tgz \
	musl.tgz \
	busybox.tgz \
	make.tgz \
	binutils.tgz \
	openssl.tgz \
	ca-certificates.tgz
	$(call build,curl)

python.tgz: \
	gcc.tgz \
	perl.tgz \
	binutils.tgz \
	busybox.tgz \
	openssl.tgz \
	make.tgz \
	musl.tgz
	$(call build,python)

ninja.tgz: \
	busybox.tgz \
	gcc.tgz \
	binutils.tgz \
	musl.tgz \
	make.tgz \
	openssl.tgz \
	python.tgz
	$(call build,ninja)

cmake.tgz: \
	busybox.tgz \
	gcc.tgz \
	binutils.tgz \
	ninja.tgz \
	musl.tgz \
	make.tgz \
	linux-headers.tgz
	$(call build,cmake)

py-setuptools.tgz: \
	busybox.tgz \
	python.tgz
	$(call build,py-setuptools)

zlib.tgz: \
	busybox.tgz \
	gcc.tgz \
	binutils.tgz \
	musl.tgz \
	make.tgz
	$(call build,zlib)

llvm13.tgz: \
	gcc.tgz \
	python.tgz \
	py-setuptools.tgz \
	perl.tgz \
	binutils.tgz \
	cmake.tgz \
	ninja.tgz \
	busybox.tgz \
	musl.tgz
	$(call build,llvm,13.0.1)

llvm.tgz: \
	gcc.tgz \
	python.tgz \
	py-setuptools.tgz \
	perl.tgz \
	binutils.tgz \
	cmake.tgz \
	ninja.tgz \
	busybox.tgz \
	musl.tgz
	$(call build,llvm)

rust1.54.tgz: \
	gcc.tgz \
	bash.tgz \
	zlib.tgz \
	python.tgz \
	py-setuptools.tgz \
	curl.tgz \
	perl.tgz \
	libunwind.tgz \
	llvm13.tgz \
	binutils.tgz \
	cmake.tgz \
	make.tgz \
	busybox.tgz \
	musl.tgz
	$(call build,rust,1.54.0,bootstrap-package)

rust1.55.tgz: rust1.54.tgz
	$(call build,rust,1.55.0,package,--build-arg BUILD_VERSION=1.54.0)

# Build package with chosen $(BUILDER)
# Supported BUILDERs: docker
# Usage: $(call build,$(NAME),$(VERSION),$(TARGET),$(EXTRA_ARGS))
# Notes:
# - Packages are expected to use the following layer names in order:
#   - "fetch": [optional] obtain any artifacts from the internet.
#   - "build": [optional] do any required build work
#   - "package": [required] scratch layer exporting artifacts for distribution
#   - "test": [optional] define any tests
# - Packages may prefix layer names with "text-" if more than one is desired
# - VERSION will be set as a build-arg if defined, otherwise it is "latest"
# - TARGET defaults to "package"
# - EXTRA_ARGS will be blindly injected
# - packages may also define a "test" layer
#  TODO:
# - try to disable networking on fetch layers with something like:
#   $(if $(filter fetch,$(lastword $(subst -, ,$(TARGET)))),,--network=none)
# - actually output OCI files for each build (vs plain tar)
# - output manifest.txt of all tar/digest hashes for an easy git diff
# - support buildah and podman
define build
	$(eval NAME := $(1))
	$(eval VERSION := $(if $(2),$(2),latest))
	$(eval TARGET := $(if $(3),$(3),package))
	$(eval EXTRA_ARGS := $(if $(4),$(4),))
	$(eval BUILD_CMD := \
		SOURCE_DATE_EPOCH=1 \
		$(BUILDER) \
			build \
			-t $(REGISTRY)/$(NAME):$(VERSION) \
			--build-arg REGISTRY=$(REGISTRY) \
			--platform $(PLATFORM) \
			--progress=plain \
			$(if $(filter latest,$(VERSION)),,--build-arg VERSION=$(VERSION)) \
			--target $(TARGET) \
			$(EXTRA_ARGS) \
			$(NAME) \
	)
	$(eval TIMESTAMP := $(shell TZ=GMT date +"%Y-%m-%dT%H:%M:%SZ"))
	echo $(TIMESTAMP) $(BUILD_CMD) >> build.log
	$(BUILD_CMD)
	$(if $(filter package,$(TARGET)),$(BUILDER) save $(REGISTRY)/$(NAME):$(VERSION),)
endef
