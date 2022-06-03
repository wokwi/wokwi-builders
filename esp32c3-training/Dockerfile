FROM debian:bullseye-slim
ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ARG CONTAINER_USER=esp
ARG CONTAINER_GROUP=esp
ARG NIGHTLY_VERSION=nightly-2022-03-10
ARG ESP_IDF_VERSION=release/v4.4
ARG ESP_BOARD=esp32c3

RUN apt-get update \
    && apt-get install -y git curl ninja-build clang libudev-dev \
    python3 python3-pip libusb-1.0-0 libssl-dev pkg-config libtinfo5 \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

RUN adduser --disabled-password --gecos "" ${CONTAINER_USER}
USER ${CONTAINER_USER}
WORKDIR /home/${CONTAINER_USER}
ENV USER=${CONTAINER_USER}

ENV PATH=${PATH}:$HOME/.cargo/bin

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- \
    --default-toolchain ${NIGHTLY_VERSION} -y --profile minimal \
    && $HOME/.cargo/bin/rustup component add rust-src --toolchain ${NIGHTLY_VERSION} \
    && $HOME/.cargo/bin/rustup target add riscv32i-unknown-none-elf

RUN $HOME/.cargo/bin/cargo install cargo-espflash espmonitor ldproxy
RUN mkdir -p ${HOME}/.espressif/frameworks/ \
    && git clone --branch ${ESP_IDF_VERSION} -q --depth 1 --shallow-submodules \
    --recursive https://github.com/espressif/esp-idf.git \
    ${HOME}/.espressif/frameworks/esp-idf \
    && python3 ${HOME}/.espressif/frameworks/esp-idf/tools/idf_tools.py install cmake \
    && ${HOME}/.espressif/frameworks/esp-idf/install.sh ${ESP_BOARD} \
    && rm -rf .espressif/dist \
    && rm -rf .espressif/frameworks/esp-idf/docs \
    && rm -rf .espressif/frameworks/esp-idf/examples \
    && rm -rf .espressif/frameworks/esp-idf/tools/esp_app_trace \
    && rm -rf .espressif/frameworks/esp-idf/tools/test_idf_size

RUN git clone -b feature/devcontainer https://github.com/SergioGasquez/espressif-trainings.git espressif-trainings \
    && rm -rf espressif-trainings/book \
    && rm espressif-trainings/intro/hardware-check/Cargo.toml
COPY Cargo.toml espressif-trainings/intro/hardware-check/Cargo.toml

# Fetch
COPY fetch.sh /home/esp/
RUN bash fetch.sh

# Copy compilation script
COPY compile.sh /home/esp/
RUN mkdir -p /home/esp/build-in /home/esp/build-out

RUN echo "[hardware-check]" > espressif-trainings/intro/hardware-check/cfg.toml \
    && echo "wifi_ssid = \"Wokwi-GUEST\"" >> espressif-trainings/intro/hardware-check/cfg.toml \
    && echo "wifi_psk = \"\"" >> espressif-trainings/intro/hardware-check/cfg.toml \
    && echo "mqtt_user = \"\"" >> espressif-trainings/intro/hardware-check/cfg.toml \
    && echo "mqtt_pass = \"\"" >> espressif-trainings/intro/hardware-check/cfg.toml \
    && echo "mqtt_host = \"broker.mqttdashboard.com\"" >> espressif-trainings/intro/hardware-check/cfg.toml
