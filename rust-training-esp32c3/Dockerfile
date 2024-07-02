# Base image
FROM espressif/rust-std-training

USER esp
ENV USER=esp

RUN git clone https://github.com/esp-rs/std-training.git std-training \
    && rm -rf std-training/book

ENV IDF_TOOLS_PATH=/home/esp/.espressif
RUN echo "source /home/esp/.espressif/frameworks/esp-idf/export.sh > /dev/null 2>&1" >> ~/.bashrc
ENV PATH=${PATH}:/home/esp/.cargo/bin

COPY sdkconfig.defaults /home/esp/
COPY cfg.toml /home/esp/
COPY compile.sh /home/esp/
COPY fetch.sh /home/esp/

RUN mkdir -p /home/esp/build-in /home/esp/build-out

RUN WOKWI_MCU=esp32-c3 ./fetch.sh advanced/button-interrupt
RUN WOKWI_MCU=esp32-c3 ./fetch.sh advanced/i2c-driver
RUN WOKWI_MCU=esp32-c3 ./fetch.sh advanced/i2c-sensor-reading
RUN WOKWI_MCU=esp32-c3 ./fetch.sh intro/hardware-check
RUN WOKWI_MCU=esp32-c3 ./fetch.sh intro/http-client
RUN WOKWI_MCU=esp32-c3 ./fetch.sh intro/http-server
RUN WOKWI_MCU=esp32-c3 ./fetch.sh intro/mqtt/exercise

ENV HEXI_SRC_DIR="/home/esp/build-in"
ENV HEXI_SRC_FILES="*.rs"
ENV HEXI_BUILD_CMD="bash /home/esp/compile.sh"
ENV HEXI_OUT_HEX="/home/esp/build-out/project.bin"
ENV HEXI_OUT_ELF="/home/esp/build-out/project.elf"
