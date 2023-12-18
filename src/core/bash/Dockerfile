ARG REGISTRY=local
from ${REGISTRY}/binutils as binutils
from ${REGISTRY}/gcc as gcc
from ${REGISTRY}/musl as musl
from ${REGISTRY}/make as make
from ${REGISTRY}/busybox as busybox

FROM busybox as base
ENV SRC_SITE=https://ftp.gnu.org/gnu/bash
ENV SRC_VERSION=5.2.21
ENV SRC_HASH=c8e31bdc59b69aaffc5b36509905ba3e5cbb12747091d27b4b977f078560d5b8
ENV SRC_FILE=bash-${SRC_VERSION}.tar.gz

FROM base as fetch
RUN set -eux; \
    wget ${SRC_SITE}/${SRC_FILE}; \
    echo "${SRC_HASH}  ${SRC_FILE}" | sha256sum -c

FROM fetch as build
RUN tar -xzf ${SRC_FILE}
WORKDIR bash-${SRC_VERSION}
COPY --from=gcc . /
COPY --from=binutils . /
COPY --from=make . /
COPY --from=musl . /
RUN set -eux; \
    mkdir -p /home/user/rootfs/lib; \
    ./configure \
        --build=x86_64-unknown-linux-musl \
        --host=x86_64-unknown-linux-musl \
        --prefix=/usr \
        --bindir=/bin \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --disable-nls \
        --enable-readline \
        --without-curses \
        --without-bash-malloc; \
    make

FROM build as install
USER 0:0
RUN make DESTDIR=/rootfs install
COPY --from=musl /usr/lib/libc.so /rootfs/lib/ld-musl-x86_64.so.1
RUN find /rootfs -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
ENTRYPOINT ["/bin/bash"]
CMD ["--version"]
