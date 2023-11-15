FROM ocirep/busybox as build
COPY --from=ocirep/gcc . /
COPY --from=ocirep/musl . /
COPY --from=ocirep/binutils . /
COPY . .
RUN set -eux; \
  gcc main.c -static -o main; \
  mkdir -p $HOME/rootfs/etc; \
  echo "nogroup:*:100:nobody" > ~/rootfs/etc/group; \
  echo "nobody:*:100:100:::" > ~/rootfs/etc/passwd; \
  cp main $HOME/rootfs/

FROM scratch
COPY --from=build --chown=100:100 /home/user/rootfs /
USER 100:100
ENTRYPOINT ["/main"]
