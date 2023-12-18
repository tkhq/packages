ARG REGISTRY=local
FROM ${REGISTRY}/busybox:latest as base

FROM base as install
USER 0:0
COPY cacert.pem /rootfs/etc/ssl/certs/ca-certificates.crt
RUN find /rootfs -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
