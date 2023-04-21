FROM espressif/idf-rust:all_1.68.0.0

USER esp
ENV USER=esp

# Install extra crates
RUN cargo install cargo-audit cargo-generate sccache

# Generate project templates
RUN cargo generate --vcs none esp-rs/esp-idf-template cargo --name rust-project-esp32 -d mcu=esp32 -d defaults=true
RUN cargo generate --vcs none esp-rs/esp-idf-template cargo --name rust-project-esp32s2 -d mcu=esp32s2 -d defaults=true
RUN cargo generate --vcs none esp-rs/esp-idf-template cargo --name rust-project-esp32s3 -d mcu=esp32s3 -d defaults=true
RUN cargo generate --vcs none esp-rs/esp-idf-template cargo --name rust-project-esp32c3 -d mcu=esp32c3 -d defaults=true

# Copy utility scripts and setup
COPY compile.sh /home/esp/
RUN mkdir -p /home/esp/build-in /home/esp/build-out
RUN pip3 install esptool

# Prebuild the template project for all targets
RUN WOKWI_MCU=esp32 ./compile.sh
RUN WOKWI_MCU=esp32-c3 ./compile.sh
RUN WOKWI_MCU=esp32-s2 ./compile.sh
RUN WOKWI_MCU=esp32-s3 ./compile.sh

ENV HOME="/home/esp"
ENV HEXI_SRC_DIR="/home/esp/build-in"
ENV HEXI_BUILD_CMD="bash /home/esp/compile.sh"
ENV HEXI_OUT_HEX="/home/esp/build-out/project.bin"
ENV HEXI_OUT_ELF="/home/esp/build-out/project.elf"
