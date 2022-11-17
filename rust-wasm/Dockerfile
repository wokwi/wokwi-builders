FROM alpine:3.16
RUN apk update
RUN apk add rust cargo rust-wasm
RUN adduser -D wokwi
COPY project /project

RUN chown wokwi /project/src/lib.rs && chmod o+w /project

WORKDIR /project
USER wokwi
RUN cargo build --target wasm32-unknown-unknown --release

# Wokwi builder configuration:
ENV HEXI_SRC_DIR="/project/src"
ENV HEXI_BUILD_CMD="cargo build --target wasm32-unknown-unknown --release --offline"
ENV HEXI_OUT_HEX="/project/target/wasm32-unknown-unknown/release/chip_rust.wasm"
ENV HEXI_OUT_ELF="/project/target/wasm32-unknown-unknown/release/chip_rust.wasm"
