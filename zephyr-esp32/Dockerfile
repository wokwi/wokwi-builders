FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt update \
  && apt install -y --no-install-recommends git cmake ninja-build gperf \
  ccache dfu-util device-tree-compiler wget \
  python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
  make gcc gcc-multilib g++-multilib libsdl2-dev \
  && pip3 install wheel west

RUN adduser --disabled-password --gecos "" wokwi
USER wokwi
WORKDIR /home/wokwi

RUN west init -m https://github.com/zephyrproject-rtos/zephyr --mr zephyr-v3.0.0 ~/zephyrproject
WORKDIR /home/wokwi/zephyrproject/
RUN west update --narrow && west espressif update
RUN pip3 install -r ~/zephyrproject/zephyr/scripts/requirements.txt
RUN west espressif install

ENV ZEPHYR_TOOLCHAIN_VARIANT=espressif
ENV HOME=/home/wokwi
ENV ESPRESSIF_TOOLCHAIN_PATH="$HOME/.espressif/tools/zephyr"
ENV PATH="$PATH:$ESPRESSIF_TOOLCHAIN_PATH/bin"
ENV IDF_PATH="$HOME/zephyrproject/modules/hal/espressif"

WORKDIR /home/wokwi/zephyrproject/zephyr
COPY esp32-wokwi.dts samples/basic/blinky/app.overlay
RUN west build -b esp32 samples/basic/blinky -p
