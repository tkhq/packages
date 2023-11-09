FROM buildpack-deps@sha256:8465175ca53f8f2e756d069658b3f353bb3732926b1f33f34332cfbf597ad0c0 as build

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends flex
