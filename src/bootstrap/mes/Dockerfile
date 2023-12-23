ARG REGISTRY=local
ARG VERSION=0.26
ARG SRC_SITE=https://gitlab.com/janneke/mes/-/archive/
ARG SRC_HASH=f0750704013b7d7ec1ca19cf06b6cf28cdcf5581317386006cef074ed368b205
FROM ${REGISTRY}/stage0 as stage0
FROM busybox@sha256:ba76950ac9eaa407512c9d859cea48114eeff8a6f12ebaa5d32ce79d4a017dd8 as busybox

FROM busybox as fetch
ARG VERSION
ENV VERSION=${VERSION}
ARG SRC_SITE
ENV SRC_SITE=${SRC_SITE}
ARG SRC_HASH
ENV SRC_HASH=${SRC_HASH}
RUN set -eux; \
    wget ${SRC_SITE}/v${VERSION}/mes-v${VERSION}.tar.gz -O mes.tgz; \
    echo "${SRC_HASH}  mes.tgz" > mes.sha256
COPY --from=stage0 / /stage0
RUN ls -lah /stage0

FROM stage0 as build
ARG SRC_HASH
ENV SRC_HASH=${SRC_HASH}
ARG VERSION
ENV VERSION=${VERSION}
COPY --from=fetch /mes.tgz mes.tgz
COPY --from=fetch /mes.sha256 mes.sha256
RUN ["/sha256sum","-c","mes.sha256"]
RUN ["/ungz","--file","mes.tgz","--output","mes.tar"]
RUN ["/untar","--verbose","--non-strict","--file","mes.tar"]
WORKDIR mes-v${VERSION}
RUN ["/M2-Planet","--debug","--architecture","amd64","-f","src/mes.c"]
