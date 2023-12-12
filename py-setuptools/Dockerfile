ARG REGISTRY=local
FROM ${REGISTRY}/busybox:latest as busybox
FROM ${REGISTRY}/python:latest as python

FROM busybox as build
ENV SRC_SITE=https://pypi.io/packages/source/s/setuptools
ENV SRC_VERSION=68.2.2
ENV SRC_HASH=4ac1475276d2f1c48684874089fefcd83bd7162ddaafb81fac866ba0db282a87
RUN wget ${SRC_SITE}/setuptools-${SRC_VERSION}.tar.gz
RUN echo "${SRC_HASH}  setuptools-${SRC_VERSION}.tar.gz" | sha256sum -c
RUN tar -xzf setuptools-${SRC_VERSION}.tar.gz
WORKDIR setuptools-${SRC_VERSION}
COPY --from=python . /
RUN set -eux; \
    python3 setup.py build; \
    python3 setup.py install --root=/home/user/rootfs; \
    ls -Rlah /home/user/rootfs

FROM scratch as package
COPY --from=build /home/user/rootfs /
