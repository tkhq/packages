ARG REGISTRY=local
ARG BUSYBOX_VERSION=latest
FROM ${REGISTRY}/bash:latest as bash
FROM ${REGISTRY}/gcc:latest as gcc
FROM ${REGISTRY}/binutils:latest as binutils
FROM ${REGISTRY}/musl:latest as musl
FROM ${REGISTRY}/busybox:${BUSYBOX_VERSION} as base
ENV GOOS=linux
ENV CGO_ENABLED=0
COPY --from=gcc . /
COPY --from=bash . /
COPY --from=musl . /
RUN rm /bin/ar
COPY --from=binutils . /

FROM base as build-stage1
ENV GO_SITE=https://dl.google.com/go
ENV GO_VERSION=1.4-bootstrap-20171003
ENV GO_HASH=f4ff5b5eb3a3cae1c993723f3eab519c5bae18866b5e5f96fe1102f0cb5c3e52
ENV GOROOT_FINAL=/home/user/go-stage1
ENV GOROOT=${GOROOT_FINAL}
ENV DEST=${GOROOT_FINAL}
ENV GOBIN=${GOROOT_FINAL}/bin
RUN wget ${GO_SITE}/go${GO_VERSION}.tar.gz
RUN echo "${GO_HASH}  go${GO_VERSION}.tar.gz" | sha256sum -c
RUN tar -xzf go${GO_VERSION}.tar.gz
WORKDIR go
RUN set -eux; \
    cd src; \
    bash make.bash; \
    cd ..; \
    mkdir -p ${DEST}; \
    cp -R bin lib pkg src ${DEST}

FROM base as build-stage2
COPY --from=build-stage1 /home/user/go-stage1 go-stage1
ENV GO_VERSION=1.19.11
ENV GO_HASH=e25c9ab72d811142b7f41ff6da5165fec2d1be5feec3ef2c66bc0bdecb431489
ENV GO_SITE=https://storage.googleapis.com/golang
ENV GO11MODULE=off
ENV GOROOT_BOOTSTRAP=/home/user/go-stage1
ENV GOROOT_FINAL=/home/user/go-stage2
ENV GOROOT=${GOROOT_FINAL}
ENV DEST=${GOROOT_FINAL}
ENV GOBIN=${GOROOT_FINAL}/bin
RUN wget ${GO_SITE}/go${GO_VERSION}.src.tar.gz
RUN echo "${GO_HASH}  go${GO_VERSION}.src.tar.gz" | sha256sum -c
RUN tar -xvzf go${GO_VERSION}.src.tar.gz
WORKDIR go
RUN set -eux; \
    cd src; \
    bash make.bash; \
    cd ..; \
    mkdir -p ${DEST}; \
    cp -R bin lib pkg src ${DEST}

FROM base as build
COPY --from=build-stage2 /home/user/go-stage2 go-stage2
ENV GO_VERSION=1.21.4
ENV GO_HASH=47b26a83d2b65a3c1c1bcace273b69bee49a7a7b5168a7604ded3d26a37bd787
ENV GO_SITE=https://storage.googleapis.com/golang
ENV GOPROXY=off
ENV GOTOOLCHAIN=local
ENV GOFLAGS=-mod=vendor
ENV GO11MODULE=on
ENV GOROOT_BOOTSTRAP=/home/user/go-stage2
ENV GOROOT_FINAL="/lib/go"
ENV GOBIN=${GOROOT_FINAL}/bin
ENV GOROOT=/home/user/go-stage2
ENV DEST=/home/user/rootfs
RUN wget ${GO_SITE}/go${GO_VERSION}.src.tar.gz
RUN echo "${GO_HASH}  go${GO_VERSION}.src.tar.gz" | sha256sum -c
RUN tar -xvzf go${GO_VERSION}.src.tar.gz
WORKDIR go
RUN set -eux; \
    cd src; \
    bash make.bash; \
    cd ..; \
    mkdir -p ${DEST}; \
    cp -R bin lib pkg src ${DEST}

FROM base as test
COPY --from=build /home/user/rootfs /
ADD test.go .
RUN set -eux; \
    go build test.go; \
    ./test | grep "Success"

FROM scratch as package
COPY --from=build /home/user/rootfs /
USER 100:100
ENTRYPOINT ["/bin/go"]
CMD ["version"]
