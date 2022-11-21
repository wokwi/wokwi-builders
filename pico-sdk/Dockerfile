FROM alpine:3.16

# Install toolchain
RUN apk update && \
    apk upgrade && \
    apk add git \
            python3 \
            py3-pip \
            cmake \
            build-base \
            libusb-dev \
            bsd-compat-headers \
            newlib-arm-none-eabi \
            gcc-arm-none-eabi
RUN adduser -D wokwi

USER wokwi
WORKDIR /home/wokwi
ENV PICO_SDK_PATH=/home/wokwi/pico-sdk
RUN git clone -b 1.4.0 --depth 1 https://github.com/raspberrypi/pico-sdk.git && cd pico-sdk && git submodule update --init --depth 1

COPY --chown=wokwi:wokwi project project/
WORKDIR /home/wokwi/project/build
RUN cmake .. && make -j4

ENV HEXI_SRC_DIR="/home/wokwi/project/src"
ENV HEXI_BUILD_CMD="cmake .. && make -j4"
ENV HEXI_OUT_HEX="/home/wokwi/project/build/wokwi_project.hex"
ENV HEXI_OUT_ELF="/home/wokwi/project/build/wokwi_project.elf"
