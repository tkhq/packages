FROM ocirep/busybox as build
COPY . .
RUN set -eux; \
  mkdir -p $HOME/rootfs/etc; \
  echo "nogroup:*:100:nobody" > ~/rootfs/etc/group; \
  echo "nobody:*:100:100:::" > ~/rootfs/etc/passwd; \
  cp main.pl $HOME/rootfs/

FROM scratch
COPY --from=build --chown=100:100 /home/user/rootfs /
COPY --from=ocirep/perl . /
USER 100:100
ENTRYPOINT ["/usr/bin/perl"]
CMD ["/main.pl"]
