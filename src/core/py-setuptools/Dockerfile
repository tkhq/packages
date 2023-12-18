ARG REGISTRY=local
FROM ${REGISTRY}/python:latest as python
FROM ${REGISTRY}/busybox:latest as busybox

FROM busybox as base
ENV SRC_SITE=https://pypi.io/packages/source/s/setuptools
ENV SRC_VERSION=68.2.2
ENV SRC_HASH=4ac1475276d2f1c48684874089fefcd83bd7162ddaafb81fac866ba0db282a87
COPY --from=python . /

FROM base as fetch
RUN wget ${SRC_SITE}/setuptools-${SRC_VERSION}.tar.gz
RUN echo "${SRC_HASH}  setuptools-${SRC_VERSION}.tar.gz" | sha256sum -c

FROM fetch as build
RUN tar -xzf setuptools-${SRC_VERSION}.tar.gz
WORKDIR setuptools-${SRC_VERSION}
RUN set -eux; \
    python3 setup.py build

FROM build as install
USER 0:0
RUN set -eux; \
    python3 setup.py install --root=/rootfs; \
    find /rootfs -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
