ARG GO_VERSION=1.21.3
ARG GO_HASH=186f2b6f8c8b704e696821b09ab2041a5c1ee13dcbc3156a13adcf75931ee488
ARG GO_STAGE2_VERSION=1.19.11
ARG GO_STAGE2_HASH=f4ff5b5eb3a3cae1c993723f3eab519c5bae18866b5e5f96fe1102f0cb5c3e52
ARG GO_SOURCE_SITE = https://dl.google.com/go
ARG GO_BOOTSTRAP_SOURCE = go${GO_BOOTSTRAP_VERSION}
ARG BUSYBOX_IMAGE=ocirep:busybox
ARG GCC_IMAGE=ocirep:gcc

# build go bootstrap stage 1 with gcc
FROM ${BUSYBOX_IMAGE} as stage1
ENV GOOS=linux
ENV GOROOT_FINAL="lib/go-${GO_STAGE1_VERSION}"
ENV GOROOT="${GOROOT_FINAL}"
ENV GOBIN="${GOROOT_FINAL}/bin"
ENV CGO_ENABLED=0
COPY --from=${GCC_IMAGE} / /
RUN wget ${GO_SOURCE_SITE}/${GO_STAGE1_VERSION}.tar.gz
RUN echo "${GO_STAGE1_HASH} ${GO_STAGE1_VERSION}.tar.gz" | sha256sum -c
RUN tar -xvzf ${GO_STAGE1_VERSION}.tar.gz
RUN env -C go ./make.bash
RUN \
    mkdir -p lib/go-${GO_STAGE1_VERSION} \
    && cp bin lib pkg src lib/go-${GO_STAGE1_VERSION}

# build go bootstrap stage 2 with go bootstrap stage 1
FROM ${BUSYBOX_IMAGE} as stage2
ENV GOOS=linux
ENV GOROOT_FINAL="lib/go-${GO_STAGE2_VERSION}"
ENV GOROOT="${GOROOT_FINAL}"
ENV GOBIN="${GOROOT_FINAL}/bin"
ENV GO11MODULE=off
ENV CGO_ENABLED=0
RUN wget ${GO_SOURCE_SITE}/${GO_STAGE2_VERSION}.tar.gz
RUN echo "${GO_STAGE2_HASH} ${GO_STAGE2_VERSION}.tar.gz" | sha256sum -c
COPY --from=stage1 lib /
RUN tar -xvzf ${GO_STAGE2_VERSION}.tar.gz
RUN env -C go ./make.bash
RUN \
    mkdir -p lib/go-${GO_STAGE1_VERSION} \
    && cp bin lib pkg src lib/go-${GO_STAGE1_VERSION}

# build target go with go bootstrap stage 2
FROM ${BUSYBOX_IMAGE} as stage3
ENV GOOS=linux
ENV GOPROXY=off
ENV GOTOOLCHAIN=local
ENV GOFLAGS=-mod=vendor
ENV GOROOT_FINAL="lib/go"
ENV GOROOT="${GOROOT_FINAL}"
ENV GOBIN="${GOROOT_FINAL}/bin"
ENV GO11MODULE=on
ENV CGO_ENABLED=0
RUN wget ${GO_SOURCE_SITE}/${GO_VERSION}.tar.gz
RUN echo "${GO_HASH} ${GO_VERSION}.tar.gz" | sha256sum -c
COPY --from=stage2 lib /
RUN tar -xvzf ${GO_VERSION}.tar.gz
RUN env -C go ./make.bash
RUN \
    mkdir -p lib/go \
    && cp bin lib pkg src lib/go

FROM scratch
COPY --from=stage3 lib /
