# Base image
ARG VARIANT=bullseye-slim
FROM debian:${VARIANT}
ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
# Arguments
ARG CONTAINER_USER=esp
ARG CONTAINER_GROUP=esp
ARG NIGHTLY_TOOLCHAIN_VERSION=nightly-2022-03-10
ARG XTENSA_TOOLCHAIN_VERSION=1.63.0.2
ARG ESP_BOARD=esp32c3
ARG INSTALL_RUST_TOOLCHAIN=install-rust-toolchain.sh
# The following variable must also be present during container run time:
ENV ESP_IDF_VERSION=v4.4.1
# Install dependencies
RUN apt-get update \
    && apt-get install -y git curl gcc clang ninja-build libudev-dev unzip xz-utils \
    python3 python3-pip python3-venv libusb-1.0-0 libssl-dev pkg-config libtinfo5  libpython2.7 \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts
# Set user
RUN adduser --disabled-password --gecos "" ${CONTAINER_USER}
USER ${CONTAINER_USER}
WORKDIR /home/${CONTAINER_USER}
# Install rust toolchain(s), extra crates and esp-idf.
ENV PATH=${PATH}:/home/${CONTAINER_USER}/.cargo/bin
ADD --chown=${CONTAINER_USER}:${CONTAINER_GROUP} \
    https://github.com/esp-rs/rust-build/releases/download/v${XTENSA_TOOLCHAIN_VERSION}/${INSTALL_RUST_TOOLCHAIN} \
    ${INSTALL_RUST_TOOLCHAIN}
RUN chmod a+x ${INSTALL_RUST_TOOLCHAIN} \
    && ./${INSTALL_RUST_TOOLCHAIN} \
    --extra-crates "ldproxy" \
    --build-target "${ESP_BOARD}" \
    --nightly-version "${NIGHTLY_TOOLCHAIN_VERSION}" \
    --esp-idf-version "${ESP_IDF_VERSION}" \
    --minified-esp-idf "YES" \
    --export-file  ${HOME}/export-esp.sh

# Activate ESP-IDF and Xtensa Rust toolchain environment
RUN echo "source ${HOME}/export-esp.sh" >> ~/.bashrc

RUN git clone https://github.com/ferrous-systems/espressif-trainings.git espressif-trainings \
    && rm -rf espressif-trainings/book \
    && rm espressif-trainings/intro/hardware-check/Cargo.toml

COPY Cargo.toml espressif-trainings/intro/hardware-check/Cargo.toml

# Fetch
COPY fetch.sh /home/esp/
RUN bash fetch.sh

# Copy compilation script
COPY compile.sh /home/esp/
RUN mkdir -p /home/esp/build-in /home/esp/build-out
