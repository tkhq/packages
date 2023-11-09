ARG GCC_IMAGE=library/gcc@sha256:ca38f292fe1ad0933f0122a657f9c644ed1f0a9e1aa336abcc83d420ad487e28
#FROM ocirep/busybox:latest as busybox
FROM library/busybox:latest as busybox
FROM ocirep/bash:latest as bash

FROM ${GCC_IMAGE} as stage1
ENV GO_SITE=https://dl.google.com/go
ENV GO_VERSION=1.4-bootstrap-20171003
ENV GO_HASH=f4ff5b5eb3a3cae1c993723f3eab519c5bae18866b5e5f96fe1102f0cb5c3e52
ENV GOOS=linux
ENV GOROOT_FINAL="/opt/go-stage1"
ENV GOROOT="${GOROOT_FINAL}"
ENV GOBIN="${GOROOT_FINAL}/bin"
ENV CGO_ENABLED=0
RUN wget ${GO_SITE}/go${GO_VERSION}.tar.gz
RUN echo "${GO_HASH} go${GO_VERSION}.tar.gz" | sha256sum -c
RUN tar -xzf go${GO_VERSION}.tar.gz
RUN cd go/src \
    && ./make.bash
RUN cd go \
    && mkdir -p ${GOROOT_FINAL} \
    && cp -R bin lib pkg src ${GOROOT_FINAL}

FROM busybox as stage2
COPY --from=stage1 /opt/go-stage1 /opt/go-stage1
COPY --from=bash bash /bin/bash
ENV GO_VERSION=1.19.11
ENV GO_HASH=e25c9ab72d811142b7f41ff6da5165fec2d1be5feec3ef2c66bc0bdecb431489
ENV GOROOT_BOOTSTRAP=/opt/go-stage1
ENV GO_SITE=https://storage.googleapis.com/golang
ENV GOOS=linux
ENV GOROOT_FINAL=/opt/go-stage2
ENV GOROOT="${GOROOT_FINAL}"
ENV GOBIN="${GOROOT_FINAL}/bin"
ENV GO11MODULE=off
ENV CGO_ENABLED=0
RUN wget ${GO_SITE}/go${GO_VERSION}.src.tar.gz
RUN echo "${GO_HASH} go${GO_VERSION}.src.tar.gz" | sha256sum -c
RUN tar -xvzf go${GO_VERSION}.src.tar.gz
RUN cd go/src \
    && /bin/bash make.bash

RUN cd go \
    && mkdir -p ${GOROOT_FINAL} \
    && cp -R bin lib pkg src ${GOROOT_FINAL}


FROM busybox as stage3
COPY --from=stage2 /opt/go-stage2 /opt/go-stage2
COPY --from=bash bash /bin/bash
ENV GO_VERSION=1.21.4
ENV GO_HASH=47b26a83d2b65a3c1c1bcace273b69bee49a7a7b5168a7604ded3d26a37bd787
ENV GOROOT_BOOTSTRAP=/opt/go-stage2
ENV GO_SITE=https://storage.googleapis.com/golang
ENV GOOS=linux
ENV GOPROXY=off
ENV GOTOOLCHAIN=local
ENV GOFLAGS=-mod=vendor
ENV GOROOT_FINAL="/opt/go"
ENV GOROOT=/opt/go-stage2
ENV GOBIN="${GOROOT_FINAL}/bin"
ENV GO11MODULE=on
ENV CGO_ENABLED=0
RUN wget ${GO_SITE}/go${GO_VERSION}.src.tar.gz
RUN echo "${GO_HASH} go${GO_VERSION}.src.tar.gz" | sha256sum -c
RUN tar -xvzf go${GO_VERSION}.src.tar.gz
RUN cd go/src \
    && ./make.bash
RUN cd go \
    && mkdir -p ${GOROOT_FINAL} \
    && cp -R bin lib pkg src ${GOROOT_FINAL}

FROM scratch
COPY --from=stage3 /opt/go /
USER 100:100
ENTRYPOINT ["/bin/go"]
CMD ["version"]
