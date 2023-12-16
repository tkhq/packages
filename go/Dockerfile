ARG REGISTRY=local
ARG BUSYBOX_VERSION=latest
FROM ${REGISTRY}/bash:latest as bash
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/busybox:${BUSYBOX_VERSION} as busybox

FROM busybox as base
ENV GOOS=linux
ENV CGO_ENABLED=0
ENV VERSION=1.21.4
ENV SRC_SITE=https://storage.googleapis.com/golang
ENV SRC_HASH=e25c9ab72d811142b7f41ff6da5165fec2d1be5feec3ef2c66bc0bdecb431489
ENV VERSION_BOOTSTRAP_2=1.19.11
ENV SRC_SITE_BOOTSTRAP_2=https://storage.googleapis.com/golang
ENV SRC_HASH_BOOTSTRAP_2=e25c9ab72d811142b7f41ff6da5165fec2d1be5feec3ef2c66bc0bdecb431489
ENV VERSION_BOOTSTRAP_1=1.4-bootstrap-20171003
ENV SRC_SITE_BOOTSTRAP_1=https://dl.google.com/go
ENV SRC_HASH_BOOTSTRAP_1=f4ff5b5eb3a3cae1c993723f3eab519c5bae18866b5e5f96fe1102f0cb5c3e52
COPY --from=gcc . /
COPY --from=gcc . /
COPY --from=bash . /
COPY --from=musl . /
RUN rm /bin/ar
COPY --from=binutils . /

FROM base as fetch
RUN set -eux; \
    wget ${SRC_SITE_BOOTSTRAP_1}/go${VERSION_BOOTSTRAP_1}.tar.gz; \
    echo "${SRC_HASH_BOOTSTRAP_1}  go${VERSION_BOOTSTRAP_1}.tar.gz" | sha256sum -c; \
    wget ${SRC_SITE_BOOTSTRAP_2}/go${VERSION_BOOTSTRAP_2}.src.tar.gz; \
    echo "${SRC_HASH_BOOTSTRAP_2}  go${VERSION_BOOTSTRAP_2}.src.tar.gz" | sha256sum -c; \
    wget ${SRC_SITE}/go${VERSION}.src.tar.gz; \
    echo "${SRC_HASH}  go${VERSION}.src.tar.gz" | sha256sum -c

FROM fetch as build
ENV GOROOT_FINAL=/home/user/go-bootstrap-1
ENV GOROOT=${GOROOT_FINAL}
ENV DEST=${GOROOT_FINAL}
ENV GOBIN=${GOROOT_FINAL}/bin
RUN set -eux; \
    tar -xzf go${VERSION_BOOTSTRAP_1}.tar.gz; \
    mv go go-bootstrap-1-src
WORKDIR go-bootstrap-1-src
RUN set -eux; \
    cd src; \
    bash make.bash; \
    cd ..; \
    mkdir -p ${DEST}; \
    cp -R bin lib pkg src ${DEST}
ENV GO11MODULE=off
ENV GOROOT_BOOTSTRAP=/home/user/go-bootstrap-1
ENV GOROOT_FINAL=/home/user/go-bootstrap-2
ENV GOROOT=${GOROOT_FINAL}
ENV DEST=${GOROOT_FINAL}
ENV GOBIN=${GOROOT_FINAL}/bin
RUN set -eux; \
    tar -xzf go${VERSION_BOOTSTRAP_2}.tar.gz; \
    mv go go-bootstrap-2-src
WORKDIR go-bootstrap-2-src
RUN set -eux; \
    cd src; \
    bash make.bash; \
    cd ..; \
    mkdir -p ${DEST}; \
    cp -R bin lib pkg src ${DEST}
ENV GOPROXY=off
ENV GOTOOLCHAIN=local
ENV GOFLAGS=-mod=vendor
ENV GO11MODULE=on
ENV GOROOT_BOOTSTRAP=/home/user/go-bootstrap-2
ENV GOROOT_FINAL="/lib/go"
ENV GOBIN=${GOROOT_FINAL}/bin
ENV GOROOT=/home/user/go-bootstrap-2
RUN set -eux; \
    tar -xzf go${VERSION}.src.tar.gz; \
    mv go go-src
WORKDIR go-src
RUN set -eux; \
    cd src; \
    bash make.bash; \
    cd ..; \

FROM build as install
USER 0:0
RUN set -eux; \
    mkdir -p /rootfs; \
    cp -R bin lib pkg src /rootfs; \
    find /rootfs -exec touch -hcd "@0" "{}" +

FROM base as test
COPY --from=install /rootfs /
ADD test.go .
RUN set -eux; \
    go build test.go; \
    ./test | grep "Success"

FROM scratch as package
COPY --from=install /rootfs /
USER 100:100
ENTRYPOINT ["/bin/go"]
CMD ["version"]
