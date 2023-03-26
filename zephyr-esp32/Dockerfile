FROM ghcr.io/beriberikix/zephyr-xtensa-espressif_esp32:v3.3.0-0.16.0sdk

RUN apt update \
  && apt install -y --no-install-recommends python3-pip \
  && pip3 install pyserial

RUN adduser --disabled-password --gecos "" wokwi
USER wokwi
WORKDIR /home/wokwi

RUN west init --mr zephyr-v3.3.0 ~/zephyrproject
WORKDIR /home/wokwi/zephyrproject/
RUN west update --narrow
RUN west blobs fetch hal_espressif

WORKDIR /home/wokwi/zephyrproject/zephyr
COPY esp32-wokwi.dts samples/basic/blinky/app.overlay
RUN west build -b esp32 samples/basic/blinky -p

# Wokwi builder configuration:
ENV HEXI_SRC_DIR="/home/wokwi/zephyrproject/zephyr/samples/basic/blinky/src"
ENV HEXI_BUILD_CMD="west build -b esp32 samples/basic/blinky -p"
ENV HEXI_OUT_HEX="/home/wokwi/zephyrproject/zephyr/build/zephyr/zephyr.bin"
ENV HEXI_OUT_ELF="/home/wokwi/zephyrproject/zephyr/build/zephyr/zephyr.elf"
