ARG VERSION=1.6.0
ARG SRC_SITE=https://github.com/oriansj/stage0-posix/releases/download
ARG SRC_HASH=9260ff69278366e5c056af7b8c436b74773eaa1330a0c6a6b8ab1b5f92e5065c
FROM alpine@sha256:51b67269f354137895d43f3b3d810bfacd3945438e94dc5ac55fdac340352f48 as apline
FROM debian@sha256:bac353db4cc04bc672b14029964e686cd7bad56fe34b51f432c1a1304b9928da as debian
FROM archlinux@sha256:1f83ba0580a15cd6ad1d02d62ad432ddc940f53f07d0e39c8982d6c9c74e53e0 as archlinux

FROM debian as build1
ARG VERSION
ENV VERSION=${VERSION}
ARG SRC_SITE
ENV SRC_SITE=${SRC_SITE}
ARG SRC_HASH
ENV SRC_HASH=${SRC_HASH}
RUN apt update && apt install -y wget gcc
RUN set -eux; \
    wget ${SRC_SITE}/Release_${VERSION}/stage0-posix-${VERSION}.tar.gz; \
    echo "${SRC_HASH}  stage0-posix-${VERSION}.tar.gz" | sha256sum -c; \
    tar -xf stage0-posix-${VERSION}.tar.gz
WORKDIR stage0-posix-${VERSION}
RUN bootstrap-seeds/POSIX/AMD64/kaem-optional-seed
RUN mv AMD64/bin /rootfs/
WORKDIR /rootfs
RUN sha256sum * > hashes.txt

FROM archlinux as build2
ARG VERSION
ENV VERSION=${VERSION}
ARG SRC_SITE
ENV SRC_SITE=${SRC_SITE}
ARG SRC_HASH
ENV SRC_HASH=${SRC_HASH}
RUN pacman -Sy --noconfirm wget gcc
RUN set -eux; \
    wget ${SRC_SITE}/Release_${VERSION}/stage0-posix-${VERSION}.tar.gz; \
    echo "${SRC_HASH}  stage0-posix-${VERSION}.tar.gz" | sha256sum -c; \
    tar -xf stage0-posix-${VERSION}.tar.gz
WORKDIR stage0-posix-${VERSION}
RUN bootstrap-seeds/POSIX/AMD64/kaem-optional-seed
RUN mv AMD64/bin /rootfs/
WORKDIR /rootfs
RUN sha256sum * > hashes.txt

FROM alpine as build3
ARG VERSION
ENV VERSION=${VERSION}
ARG SRC_SITE
ENV SRC_SITE=${SRC_SITE}
ARG SRC_HASH
ENV SRC_HASH=${SRC_HASH}
RUN apk add wget gcc
RUN set -eux; \
    wget ${SRC_SITE}/Release_${VERSION}/stage0-posix-${VERSION}.tar.gz; \
    echo "${SRC_HASH}  stage0-posix-${VERSION}.tar.gz" | sha256sum -c; \
    tar -xf stage0-posix-${VERSION}.tar.gz
WORKDIR stage0-posix-${VERSION}
RUN bootstrap-seeds/POSIX/AMD64/kaem-optional-seed
RUN mv AMD64/bin /rootfs/
WORKDIR /rootfs
RUN sha256sum * > hashes.txt

FROM scratch as compare
COPY --from=build1 /rootfs/ /a
COPY --from=build2 /rootfs/ /b
COPY --from=build3 /rootfs/ /c

FROM compare as test1
WORKDIR /a
RUN ["/a/sha256sum","-c","/a/hashes.txt"]
WORKDIR /b
RUN ["/a/sha256sum","-c","/a/hashes.txt"]
WORKDIR /c
RUN ["/a/sha256sum","-c","/a/hashes.txt"]

FROM compare as test2
WORKDIR /a
RUN ["/b/sha256sum","-c","/b/hashes.txt"]
WORKDIR /b
RUN ["/b/sha256sum","-c","/b/hashes.txt"]
WORKDIR /c
RUN ["/b/sha256sum","-c","/b/hashes.txt"]

FROM compare as test3
WORKDIR /a
RUN ["/c/sha256sum","-c","/c/hashes.txt"]
WORKDIR /b
RUN ["/c/sha256sum","-c","/c/hashes.txt"]
WORKDIR /c
RUN ["/c/sha256sum","-c","/c/hashes.txt"]

FROM scratch as package
COPY --from=build1 /rootfs /
