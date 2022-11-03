FROM espressif/idf-rust:all_1.64.0.0

USER esp
ENV USER=esp
RUN cargo generate --vcs none --git https://github.com/esp-rs/esp-template --name rust-project  --vcs none --silent -d mcu=${WOKWI_MCU}  -d devcontainer=false -d alloc=false

# Copy compilation script
COPY compile.sh /home/esp/
RUN mkdir -p /home/esp/build-in /home/esp/build-out

# Fetch
COPY fetch.sh /home/esp/
RUN bash fetch.sh

# Install sccacahe
RUN cargo install sccache
ENV SCCACHE_REDIS=${REDIST_URL}


EXPOSE 8080
ENV HOME="/home/esp"
ENV HEXI_SRC_DIR="/home/esp/build-in"
ENV HEXI_BUILD_CMD="bash /home/esp/compile.sh"
ENV HEXI_OUT_HEX="/home/esp/build-out/project.bin"
ENV HEXI_OUT_ELF="/home/esp/build-out/project.elf"

