ARG REGISTRY=local
FROM ${REGISTRY}/go:latest as go
FROM ${REGISTRY}/busybox:latest as busybox 
FROM ${REGISTRY}/ca-certificates:latest as ca-certificates

FROM busybox as base
ENV VERSION=1.6.0-beta4
ENV SRC_SITE=https://github.com/opentofu/opentofu/archive/refs/tags
ENV SRC_HASH=b14f151839d90d06f95ba4257be159857606daf522d99e9285ddb248f814393f
RUN echo ${SRC_SITE}/${VERSION}.tar.gz

FROM base as fetch
COPY --from=go . /
COPY --from=ca-certificates . /

RUN set -eux; \
    wget ${SRC_SITE}/v${VERSION}.tar.gz; \
    echo "${SRC_HASH}  v${VERSION}.tar.gz" | sha256sum -c; 

FROM fetch as build
RUN tar -xvf v${VERSION}.tar.gz
WORKDIR opentofu-${VERSION}
ENV PWD=/home/user/opentofu-${VERSION}
ENV GOPATH=${PWD}/cache/go
ENV GOCACHE=${PWD}/cache/
ENV GOWORK=off
ENV GOPROXY=https://proxy.golang.org,direct
ENV GOSUMDB=sum.golang.org

ENV CGO_ENABLED=0
ENV GOHOSTOS=linux
ENV GOHOSTARCH=amd64
ENV GOFLAGS=-trimpath 
RUN mkdir -p ${GOPATH}
RUN go build -o bin/tofu ./cmd/tofu

from build as install
USER 0:0
RUN mkdir -p /rootfs/usr/bin/
RUN cp bin/tofu /rootfs/usr/bin/

FROM scratch as package
COPY --from=install /rootfs/ /
ENTRYPOINT ["/usr/bin/tofu"]
CMD ["--version"]