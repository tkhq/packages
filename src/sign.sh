#!/bin/bash
set -eux

# Generate container image signatures in PGP sigstore format

REGISTRY=${1?}
NAME=${2?}

ID=$(docker image ls --format '{{.ID}}' --no-trunc "${REGISTRY}/${NAME}")
DIR=sig/${REGISTRY}/${NAME}@sha256=${ID}
SIGNUM=1

mkdir -p ${DIR}

[ -f ${DIR}/signature-1 ] \
    && LASTSIGNUM=$( \
        find ${DIR} -type f -printf "%f\n" \
        | sort \
        | tail -n1 \
        | sed 's/signature-//' \
    ) \
    && let "SIGNUM=LASTSIGNUM+1"

printf \
    '[{"critical":{"identity":{"docker-reference":"%s/%s"},"image":{"docker-manifest-digest":"%s"},"type":"pgp container image signature"},"optional":null}]' \
    "$REGISTRY" "$NAME" "$ID" \
    | gpg --sign > ${DIR}/signature-${SIGNUM}
