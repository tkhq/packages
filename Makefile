export REGISTRY := local
export PLATFORM := linux/amd64
export BUILDER := $(shell which docker)
clean_logs := $(shell rm *.log 2>&1 >/dev/null || :)

include src/macros.mk
include src/bootstrap/build.mk
include src/core/build.mk
include src/libs/build.mk
include src/tools/build.mk

DEFAULT_GOAL := default
.PHONY: default
default: bootstrap core

out/graph.svg: Makefile
	$(MAKE) -Bnd | make2graph | dot -Tsvg -o graph.svg
