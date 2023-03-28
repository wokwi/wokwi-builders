# Base image
FROM espressif/rust-std-training
USER esp
ENV USER=esp
RUN git clone https://github.com/ferrous-systems/espressif-trainings.git espressif-trainings \
    && rm -rf espressif-trainings/book \
    && rm espressif-trainings/intro/hardware-check/Cargo.toml

ENV IDF_TOOLS_PATH=/home/esp/.espressif
RUN echo "source /home/esp/.espressif/frameworks/esp-idf/export.sh > /dev/null 2>&1" >> ~/.bashrc
ENV PATH=${PATH}:/home/esp/.cargo/bin

COPY Cargo.toml espressif-trainings/intro/hardware-check/Cargo.toml
COPY sdkconfig.defaults espressif-trainings/intro/hardware-check/sdkconfig.defaults
COPY cfg.toml espressif-trainings/intro/hardware-check/cfg.toml

# Fetch
COPY fetch.sh /home/esp/
RUN bash fetch.sh

# Copy compilation script
COPY compile.sh /home/esp/
RUN mkdir -p /home/esp/build-in /home/esp/build-out

ENV HEXI_SRC_DIR="/home/esp/build-in"
ENV HEXI_BUILD_CMD="bash /home/esp/compile.sh"
ENV HEXI_OUT_HEX="/home/esp/build-out/project.bin"
ENV HEXI_OUT_ELF="/home/esp/build-out/project.elf"
