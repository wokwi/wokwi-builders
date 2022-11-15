FROM espressif/idf-rust:all_1.64.0.0

USER esp
ENV USER=esp

# Install sccacahe
RUN cargo install sccache

# Generate project templates
RUN cargo generate --vcs none --git https://github.com/esp-rs/esp-template --name rust-project-esp32 --vcs none --silent -d mcu=esp32 -d devcontainer=false -d alloc=true
RUN cargo generate --vcs none --git https://github.com/esp-rs/esp-template --name rust-project-esp32s2 --vcs none --silent -d mcu=esp32s2 -d devcontainer=false -d alloc=true
RUN cargo generate --vcs none --git https://github.com/esp-rs/esp-template --name rust-project-esp32s3 --vcs none --silent -d mcu=esp32s3 -d devcontainer=false -d alloc=true
RUN cargo generate --vcs none --git https://github.com/esp-rs/esp-template --name rust-project-esp32c3 --vcs none --silent -d mcu=esp32c3 -d devcontainer=false -d alloc=true

# Copy utility scripts and setup
COPY compile.sh fetch.sh /home/esp/
RUN bash fetch.sh && mkdir -p /home/esp/build-in /home/esp/build-out

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
