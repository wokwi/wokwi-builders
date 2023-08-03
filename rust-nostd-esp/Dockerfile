FROM espressif/idf-rust:all_1.71.0.1

USER esp
ENV USER=esp

# Install extra crates
RUN cargo install cargo-audit && \
    GENERATE_VERSION=$(git ls-remote --refs --sort="version:refname" --tags "https://github.com/cargo-generate/cargo-generate" | cut -d/ -f3- | tail -n1)  && \
    curl -L "https://github.com/cargo-generate/cargo-generate/releases/latest/download/cargo-generate-${GENERATE_VERSION}-x86_64-unknown-linux-gnu.tar.gz" -o "${HOME}/.cargo/bin/cargo-generate.tar.gz" && \
    tar xf "${HOME}/.cargo/bin/cargo-generate.tar.gz" -C ${HOME}/.cargo/bin && \
    chmod u+x "${HOME}/.cargo/bin/cargo-generate" && \
    curl -L "https://github.com/SergioGasquez/rnamer/releases/latest/download/rnamer-x86_64-unknown-linux-gnu" -o "${HOME}/.cargo/bin/rnamer" && \
    chmod u+x "${HOME}/.cargo/bin/rnamer"

# Generate project templates
RUN cargo generate --vcs none esp-rs/esp-template --name rust-project-esp32 -d mcu=esp32 -d advanced=false
RUN cargo generate --vcs none esp-rs/esp-template --name rust-project-esp32s2 -d mcu=esp32s2 -d advanced=false
RUN cargo generate --vcs none esp-rs/esp-template --name rust-project-esp32s3 -d mcu=esp32s3 -d advanced=false
RUN cargo generate --vcs none esp-rs/esp-template --name rust-project-esp32c3 -d mcu=esp32c3 -d advanced=false

# Add alloc to the build-std property
RUN find . -name "config.toml" -type f -exec sed -i 's/build-std = \["core"\]/build-std = \["alloc", "core"\]/g' {} +

# Copy utility scripts and setup
COPY compile.sh /home/esp/
RUN mkdir -p /home/esp/build-in /home/esp/build-out
RUN pip3 install esptool

# Prebuild the template project for all targets, to test the container.
# We remove the target directory to reduce the image size.
RUN WOKWI_MCU=esp32 ./compile.sh && rm -rf rust-project-esp32/target
RUN WOKWI_MCU=esp32-c3 ./compile.sh && rm -rf rust-project-esp32c3/target
RUN WOKWI_MCU=esp32-s2 ./compile.sh && rm -rf rust-project-esp32s2/target
RUN WOKWI_MCU=esp32-s3 ./compile.sh && rm -rf rust-project-esp32s3/target

COPY test.sh /home/esp/
COPY Cargo.toml /home/esp/build-in/


ENV HOME="/home/esp"
ENV HEXI_SRC_DIR="/home/esp/build-in"
ENV HEXI_SRC_FILES="*(*.rs|Cargo.toml)"
ENV HEXI_BUILD_CMD="bash /home/esp/compile.sh"
ENV HEXI_OUT_HEX="/home/esp/build-out/project.bin"
ENV HEXI_OUT_ELF="/home/esp/build-out/project.elf"
