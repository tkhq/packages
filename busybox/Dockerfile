ARG REGISTRY=local
FROM ${REGISTRY}/bootstrap as bootstrap

FROM bootstrap as base
ENV SRC_SITE=https://busybox.net/downloads
ENV SRC_VERSION=1.35.0
ENV SRC_HASH=faeeb244c35a348a334f4a59e44626ee870fb07b6884d68c10ae8bc19f83a694
ENV SRC_FILE=busybox-${SRC_VERSION}.tar.bz2
ENV KCONFIG_NOTIMESTAMP=1

FROM base as fetch
RUN set -eux; \
    wget ${SRC_SITE}/${SRC_FILE}
    echo "${SRC_HASH}  ${SRC_FILE}" | sha256sum -c

FROM fetch as build
RUN tar -xjf ${SRC_FILE}
WORKDIR busybox-${SRC_VERSION}
RUN set -eux; \
	setConfs=' \
		CONFIG_AR=y \
		CONFIG_FEATURE_AR_CREATE=y \
		CONFIG_FEATURE_AR_LONG_FILENAMES=y \
		CONFIG_LAST_SUPPORTED_WCHAR=0 \
		CONFIG_STATIC=y \
	'; \
	unsetConfs=' \
		CONFIG_FEATURE_SYNC_FANCY \
		CONFIG_FEATURE_HAVE_RPC \
		CONFIG_FEATURE_INETD_RPC \
		CONFIG_FEATURE_UTMP \
		CONFIG_FEATURE_WTMP \
	'; \
	make defconfig; \
	for conf in $unsetConfs; do \
		sed -i \
			-e "s!^$conf=.*\$!# $conf is not set!" \
			.config; \
	done; \
	for confV in $setConfs; do \
		conf="${confV%=*}"; \
		sed -i \
			-e "s!^$conf=.*\$!$confV!" \
			-e "s!^# $conf is not set\$!$confV!" \
			.config; \
		if ! grep -q "^$confV\$" .config; then \
			echo "$confV" >> .config; \
		fi; \
	done; \
	make oldconfig; \
	for conf in $unsetConfs; do \
		! grep -q "^$conf=" .config; \
	done; \
	for confV in $setConfs; do \
		grep -q "^$confV\$" .config; \
	done; \
    make

FROM build as install
USER 0:0
RUN set -eux; \
    mkdir -p /rootfs/bin; \
    cp busybox /rootfs/bin; \
    cd /rootfs; \
    mkdir -p home/user var/tmp etc tmp lib bin; \
    /bin/busybox --install -s bin; \
    echo "user:x:1000:" > etc/group; \
    echo "user:x:1000:1000::/home/user:/bin/sh" > etc/passwd; \
    ln -sT /lib lib64; \
    chown -R 1000:1000 /rootfs/home/user /tmp /var/tmp; \
    find . -exec touch -hcd "@0" "{}" +

FROM scratch as package
COPY --from=install /rootfs /
WORKDIR /home/user
USER 1000:1000
ENTRYPOINT ["/bin/sh"]
ENV TZ=UTC
ENV LANG=C.UTF-8
ENV SOURCE_DATE_EPOCH=1
ENV KCONFIG_NOTIMESTAMP=1
ENV PS1="busybox$ "
