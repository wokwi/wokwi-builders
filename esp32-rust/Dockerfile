FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update \
    && apt-get install -y vim nano git curl gcc ninja-build cmake libudev-dev python3 python3-pip libusb-1.0-0 libssl-dev \
    pkg-config libtinfo5

RUN adduser --disabled-password --gecos "" rust
USER rust
WORKDIR /home/rust

COPY install-rust-toolchain.sh .
RUN ./install-rust-toolchain.sh --extra-crates "ldproxy cargo-generate" --clear-cache "YES" --export-file /home/rust/export-rust.sh

COPY entrypoint.sh /opt/esp/entrypoint.sh
COPY motd /etc/motd

ENTRYPOINT [ "/opt/esp/entrypoint.sh" ]
CMD "/bin/bash"

ENV USER=rust
ENV HOME=/home/rust

# Examples from esp-idf-hal
RUN git clone https://github.com/georgik/esp-idf-hal.git rust-project

# Some patches that should be moved to the tooling
RUN echo '[patch.crates-io] ' >> rust-project/Cargo.toml
RUN echo 'embuild = { git="https://github.com/ivmarkov/embuild.git" }' >> rust-project/Cargo.toml
RUN sed -i -e 's!esp-13.0.0-20211203-aarch64-unknown-linux-gnu/!esp-13.0.0-20211203-aarch64-unknown-linux-gnu/xtensa-esp32-elf-clang/!g' /home/rust/export-rust.sh

RUN pip3 install esptool --user

# Compile esp-idf-hal examples
RUN . /opt/esp/entrypoint.sh \
  && cd rust-project \
  && cargo +esp build --example ledc-simple --release --target xtensa-esp32-espidf

COPY compile.sh /home/rust
