FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get upgrade -y\
  && apt-get -y install wget git \
  && apt-get -y install cmake gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential python3.9 \
  && useradd -ms /bin/bash pico

USER pico
WORKDIR /home/pico
ENV PICO_SDK_PATH=/home/pico/pico-sdk
RUN git clone -b 1.4.0 --depth 1 https://github.com/raspberrypi/pico-sdk.git && cd pico-sdk && git submodule update --init --depth 1

COPY --chown=pico:pico project project/
WORKDIR /home/pico/project/build
RUN cmake .. && make -j4
