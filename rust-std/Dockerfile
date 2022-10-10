FROM espressif/idf-rust:all_v4.4_1.64.0.0
ARG MCU=esp32


USER esp
ENV USER=esp
RUN cargo generate --vcs none --git https://github.com/esp-rs/esp-idf-template cargo --name rust-project --define mcu=${MCU} --define espidfver=v4.4 --define std=true --define devcontainer=false

# Copy compilation script
COPY compile.sh /home/esp/
RUN mkdir -p /home/esp/build-in /home/esp/build-out

# Fetch
COPY fetch.sh /home/esp/
RUN bash fetch.sh

# Install sccacahe
RUN cargo install sccache
# TO BE MODIFIED WITH URL
ENV SCCACHE_REDIS="redis://[:<passwd>@]<hostname>[:port][/<db>]"

EXPOSE 8080
ENV HOME="/home/esp"
ENV HEXI_SRC_DIR="/home/esp/build-in"
ENV HEXI_BUILD_CMD="bash /home/esp/compile.sh"
ENV HEXI_OUT_HEX="/home/esp/build-out/project.bin"
ENV HEXI_OUT_ELF="/home/esp/build-out/project.elf"
COPY --from=wokwi/mini-hexi /wokwi-hexi /wokwi-hexi
CMD /wokwi-hexi
