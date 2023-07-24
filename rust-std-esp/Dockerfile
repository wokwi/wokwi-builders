FROM espressif/idf-rust:all_1.71.0.1

USER esp
ENV USER=esp

# Install extra crates
RUN cargo install cargo-audit cargo-generate --locked

# Generate project templates
RUN cargo generate --vcs none esp-rs/esp-idf-template cargo --name rust-project-esp32 -d mcu=esp32 -d advanced=false
RUN cargo generate --vcs none esp-rs/esp-idf-template cargo --name rust-project-esp32s2 -d mcu=esp32s2 -d advanced=false
RUN cargo generate --vcs none esp-rs/esp-idf-template cargo --name rust-project-esp32s3 -d mcu=esp32s3 -d advanced=false
RUN cargo generate --vcs none esp-rs/esp-idf-template cargo --name rust-project-esp32c3 -d mcu=esp32c3 -d advanced=false

# Copy utility scripts and setup
COPY compile.sh /home/esp/
ADD assets /home/esp/assets
RUN mkdir -p /home/esp/build-in /home/esp/build-out
RUN pip3 install esptool

# Prebuild the template project for all targets - currently disabled to reduce the image size.
# We remove the target directory to reduce the image size.
RUN WOKWI_MCU=esp32 ./compile.sh && rm -rf rust-project-esp32/target
RUN WOKWI_MCU=esp32-c3 ./compile.sh && rm -rf rust-project-esp32c3/target
RUN WOKWI_MCU=esp32-s2 ./compile.sh && rm -rf rust-project-esp32s2/target
RUN WOKWI_MCU=esp32-s3 ./compile.sh && rm -rf rust-project-esp32s3/target

ENV HOME="/home/esp"
ENV HEXI_SRC_DIR="/home/esp/build-in"
ENV HEXI_SRC_FILES="*(*.rs|Cargo.toml)"
ENV HEXI_BUILD_CMD="bash /home/esp/compile.sh"
ENV HEXI_OUT_HEX="/home/esp/build-out/project.bin"
ENV HEXI_OUT_ELF="/home/esp/build-out/project.elf"
