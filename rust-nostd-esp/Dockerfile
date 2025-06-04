FROM espressif/idf-rust:all_1.86.0.0

USER esp
ENV USER=esp

# Install extra crates
RUN cargo install cargo-audit && \
    curl -L "https://github.com/esp-rs/esp-generate/releases/latest/download/esp-generate-x86_64-unknown-linux-gnu" -o "${HOME}/.cargo/bin/esp-generate" && \
    chmod u+x "${HOME}/.cargo/bin/esp-generate" && \
    curl -L "https://github.com/SergioGasquez/rnamer/releases/latest/download/rnamer-x86_64-unknown-linux-gnu" -o "${HOME}/.cargo/bin/rnamer" && \
    chmod u+x "${HOME}/.cargo/bin/rnamer"

# Generate project templates
RUN esp-generate --headless --chip=esp32 -o log rust-project-esp32
RUN esp-generate --headless --chip=esp32c3 -o log rust-project-esp32c3
RUN esp-generate --headless --chip=esp32c6 -o log rust-project-esp32c6
RUN esp-generate --headless --chip=esp32h2 -o log rust-project-esp32h2
RUN esp-generate --headless --chip=esp32s2 -o log rust-project-esp32s2
RUN esp-generate --headless --chip=esp32s3 -o log rust-project-esp32s3

# Copy utility scripts and setup
COPY compile.sh /home/esp/

RUN mkdir -p /home/esp/build-in /home/esp/build-out

# Prebuild the template project for all targets, to test the container.
# We remove the target directory to reduce the image size.
RUN WOKWI_MCU=esp32 ./compile.sh && rm -rf rust-project-esp32/target
RUN WOKWI_MCU=esp32-c3 ./compile.sh && rm -rf rust-project-esp32c3/target
RUN WOKWI_MCU=esp32-c6 ./compile.sh && rm -rf rust-project-esp32c6/target
RUN WOKWI_MCU=esp32-h2 ./compile.sh && rm -rf rust-project-esp32h2/target
RUN WOKWI_MCU=esp32-s2 ./compile.sh && rm -rf rust-project-esp32s2/target
RUN WOKWI_MCU=esp32-s3 ./compile.sh && rm -rf rust-project-esp32s3/target

ENV HOME="/home/esp"
ENV HEXI_SRC_DIR="/home/esp/build-in"
ENV HEXI_SRC_FILES="*(*.rs|Cargo.toml)"
ENV HEXI_BUILD_CMD="bash /home/esp/compile.sh"
ENV HEXI_OUT_HEX="/home/esp/build-out/project.bin"
ENV HEXI_OUT_ELF="/home/esp/build-out/project.elf"
