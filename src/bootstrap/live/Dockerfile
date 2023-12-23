ARG REGISTRY=local
ARG VERSION=55ad47acd764a909e0f337bce322abd346d963fa
ARG SRC_SITE=https://codeload.github.com/fosslinux/live-bootstrap/legacy.tar.gz
ARG SRC_HASH=4f0f9103a1a333b1174ca16e584e7a3c849a56383018e1ced175033292b24014
FROM debian@sha256:bac353db4cc04bc672b14029964e686cd7bad56fe34b51f432c1a1304b9928da as debian
FROM ${REGISTRY}/stage0 as stage0

FROM debian as fetch
ARG VERSION
ENV VERSION=${VERSION}
ARG SRC_SITE
ENV SRC_SITE=${SRC_SITE}
ARG SRC_HASH
ENV SRC_HASH=${SRC_HASH}
RUN apt update && apt install -y curl gcc
RUN set -eux; \
    curl ${SRC_SITE}/${VERSION} -o live-bootstrap.tar.gz; \
    echo "${SRC_HASH}  live-bootstrap.tar.gz" | sha256sum -c; \
    tar -xvf live-bootstrap.tar.gz; \
    mv fosslinux-live-bootstrap-* live-bootstrap
WORKDIR live-bootstrap
RUN ./download-distfiles.sh
RUN set -eux; \
    mkdir -p /rootfs; \
    mv steps distfiles seed/* /rootfs/
RUN cat <<EOF > /rootfs/steps/bootstrap.cfg
FORCE_TIMESTAMPS=False
CHROOT=False
CHROOT_ONLY_SYSA=False
UPDATE_CHECKSUMS=False
JOBS=2
INTERNAL_CI=None
BARE_METAL=True
DISK=sdb
KERNEL_BOOTSTRAP=True
BUILD_KERNELS=False
EOF

FROM busybox as build
COPY --from=stage0 / .
COPY --from=fetch /rootfs .
ENV ARCH_DIR=x86
ENV ARCH=x86
RUN ["/x86/bin/kaem","--verbose","--strict","--file","./after.kaem"]
