FROM alpine:3.16
RUN apk update
RUN adduser -D wokwi
COPY project /project

RUN wget -q https://github.com/marler8997/zigup/releases/download/v2022_08_25/zigup.ubuntu-latest-x86_64.zip && \
    unzip zigup.ubuntu-latest-x86_64.zip -d /usr/bin && \
    chmod +x /usr/bin/zigup && \
    zigup 0.10.0

RUN chown wokwi /project/src/lib.zig && chmod o+w /project

WORKDIR /project

RUN zig build -Drelease-small

# Wokwi builder configuration:
ENV HEXI_SRC_DIR="/project/src"
ENV HEXI_BUILD_CMD="zig build -Drelease-small"
ENV HEXI_OUT_HEX="/project/zig-out/lib/chip_zig.wasm"
ENV HEXI_OUT_ELF="/project/zig-out/lib/chip_zig.wasm"
