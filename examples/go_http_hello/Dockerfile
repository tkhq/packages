ARG GO_IMAGE=ocirep:go
FROM ${GO_IMAGE} as build
COPY . .
RUN cargo build main.go

ARG CA_IMAGE=ocirep:ca-certificates
FROM scratch
COPY --from=${CA_IMAGE} /
COPY --from=build main .
