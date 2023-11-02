ARG GO_IMAGE=ocirep:go
FROM ${GO_IMAGE} as build
COPY . .
RUN \
  go build main.go \
  && mkdir -p rootfs/etc \
  && echo "nogroup:*:100:nobody" > ~/rootfs/etc/group \
  && echo "nobody:*:100:100:::" > ~/rootfs/etc/passwd \
  && cp main rootfs/

ARG CA_IMAGE=ocirep:ca-certificates
FROM scratch
COPY --from=${CA_IMAGE} /
COPY --from=build --chown=100:100 rootfs /
USER 100:100
EXPOSE 8080
ENTRYPOINT main
