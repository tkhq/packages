FROM alpine@sha256:eece025e432126ce23f223450a0326fbebde39cdf496a85d8c016293fc851978 as seed

FROM seed as fetch
RUN set -ex; \
    apk update; \
    apk add gcc g++ libc-dev make linux-headers patch
RUN find / \
    \( -name sys \
        -o -name proc \
        -o -name dev \
        -o -path /etc/resolv.conf \
        -o -path /etc/hosts \
    \) \
    -prune \
    -o -type f \
    -exec touch -hcd "@0" "{}" +

FROM fetch as package
