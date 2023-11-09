FROM library/gcc@sha256:ca38f292fe1ad0933f0122a657f9c644ed1f0a9e1aa336abcc83d420ad487e28 as build

#HACK: actually build this from scratch
RUN set -eux; \
	mkdir -p rootfs/lib; \
	gccMultiarch="$(gcc -print-multiarch)"; \
	set -- \
		/lib/"$gccMultiarch"/libnss*.so.* \
		/lib/"$gccMultiarch"/libm.so.* \
		/lib/"$gccMultiarch"/libpthread*.so.* \
	; \
	while [ "$#" -gt 0 ]; do \
		f="$1"; shift; \
		fn="$(basename "$f")"; \
		if [ -e "rootfs/$fn" ]; then continue; fi; \
		if [ "${f#rootfs/}" = "$f" ]; then \
			if [ "${fn#ld-}" = "$fn" ]; then \
				ln -vL "$f" "rootfs/$fn"; \
			else \
				cp -v "$f" "rootfs/$fn"; \
			fi; \
		fi; \
		ldd="$(ldd "$f" | awk ' \
			$1 ~ /^\// { print $1; next } \
			$2 == "=>" && $3 ~ /^\// { print $3; next } \
		')"; \
		set -- "$@" $ldd; \
	done

FROM scratch
COPY --from=build rootfs/ /
