FROM espressif/idf-rust:esp32s3_v4.4_1.66.0.0

# Install cargo-generate
USER esp
ENV USER=esp
RUN cargo generate --vcs none --git https://github.com/esp-rs/esp-idf-template cargo --name rust-project --define mcu=esp32s3 --define espidfver=v4.4 --define std=true --define devcontainer=false --define hal="Yes (default features)" \
    && rm rust-project/Cargo.toml
COPY Cargo.toml rust-project/Cargo.toml

# Fetch
COPY fetch.sh /home/esp/
RUN bash fetch.sh

# Copy compilation script
COPY compile.sh /home/esp/
RUN mkdir -p /home/esp/build-in /home/esp/build-out

EXPOSE 8080
ENV HOME="/home/esp"
ENV HEXI_SRC_DIR="/home/esp/build-in"
ENV HEXI_BUILD_CMD="bash /home/esp/compile.sh"
ENV HEXI_OUT_HEX="/home/esp/build-out/project.bin"
ENV HEXI_OUT_ELF="/home/esp/build-out/project.elf"
COPY --from=wokwi/mini-hexi /wokwi-hexi /wokwi-hexi
CMD /wokwi-hexi
