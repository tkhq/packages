ARG LIBSTD_IMAGE=ocirep:rust-libstd-musl
ARG LIBMUSL_IMAGE=ocirep:libmusl
ARG LIBPCSCLITE_IMAGE=ocirep:libpcsclite-static

FROM ocirep:rust as build

COPY --from=${LIBSTD_IMAGE} . lib
COPY --from=${LIBMUSL_IMAGE} . lib
COPY --from=${LIBPCSCLITE_IMAGE} . lib
COPY . .

ENV PCSC_LIB_DIR='./lib'
ENV PCSC_LIB_NAME='static=pcsclite'
ENV RUSTFLAGS='-L lib -C target-feature=+crt-static'
RUN cargo build --target x86_64-unknown-linux-musl --release

FROM scratch
COPY --from=build target/release/pcsc_demo .
