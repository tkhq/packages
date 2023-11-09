ARG GCC_IMAGE=library/gcc@sha256:ca38f292fe1ad0933f0122a657f9c644ed1f0a9e1aa336abcc83d420ad487e28

FROM ${GCC_IMAGE} as build
ENV SOURCE_SITE=https://busybox.net/downloads
ENV SOURCE_VERSION=1.36.1
ENV SOURCE_HASH=b8cc24c9574d809e7279c3be349795c5d5ceb6fdf19ca709f80cde50e47de314
RUN wget ${SOURCE_SITE}/busybox-${SOURCE_VERSION}.tar.bz2
RUN echo "${SOURCE_HASH} busybox-${SOURCE_VERSION}.tar.bz2" | sha256sum -c
RUN tar -xjf busybox-${SOURCE_VERSION}.tar.bz2
WORKDIR busybox-${SOURCE_VERSION}
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
	done

RUN make
RUN cp busybox /

FROM scratch
COPY --from=build busybox /
RUN ["/busybox","mkdir","/bin"]
RUN ["/busybox","--install","-s","/bin"]
RUN echo "user:x:1000:" > /etc/group
RUN echo "user:x:1000:1000::/home/user:/bin/sh" > /etc/passwd
RUN mkdir -p /home/user /tmp /lib
RUN ln -sT /lib /lib64
RUN chown -R 1000:1000 /home/user /tmp
WORKDIR /home/user
USER 1000:1000
ENTRYPOINT ["/bin/sh"]
