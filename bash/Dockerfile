ARG REGISTRY=local
from ${REGISTRY}/bootstrap as bootstrap

FROM bootstrap as build
ENV SOURCE_SITE=https://ftp.gnu.org/gnu/bash
ENV SOURCE_VERSION=5.2.15
ENV SOURCE_HASH=13720965b5f4fc3a0d4b61dd37e7565c741da9a5be24edc2ae00182fc1b3588c
RUN wget ${SOURCE_SITE}/bash-${SOURCE_VERSION}.tar.gz
RUN echo "${SOURCE_HASH} bash-${SOURCE_VERSION}.tar.gz" | sha256sum -c
RUN tar -xzf bash-${SOURCE_VERSION}.tar.gz
WORKDIR bash-${SOURCE_VERSION}
RUN set -eux; \
    ./configure \
        --prefix=/usr \
        --enable-static-link; \
    make DESTDIR=/home/user/rootfs
RUN make install DESTDIR=/home/user/rootfs

FROM scratch
COPY --from=build /home/user/rootfs /
