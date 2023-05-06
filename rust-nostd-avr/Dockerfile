
# because of LLVM bug uses specifc nightly -> if resolved can used latest / new stable
# https://github.com/rust-lang/compiler-builtins/issues/523
# because official rust-lang container dont support tagging using instrumentist
# it is one to one the official rust-len container,just retagged, to check -> 
# https://github.com/rust-lang/docker-rust-nightly/issues/3
# https://github.com/instrumentisto/rust-docker-image/blob/5a7de506e39bd8ce6ccda3d55830d333d764b874/nightly/buster/hooks/post_push#L26-L27
#FROM instrumentisto/rust:nightly-bullseye-2022-12-13
FROM rustlang/rust:nightly-bullseye
# Install avr-gcc, binutils and libc - used for linking + creating elf
RUN apt-get update && apt-get install -y avr-libc binutils-avr gcc-avr

#RUN adduser -D wokwi
RUN useradd -rm -d /home/wokwi wokwi
USER wokwi
WORKDIR /home/wokwi
ENV USER=wokwi
ENV MCU="avr-atmega328p"

# Check rust version
RUN cargo --version
RUN rustup show

# Install extra crates
#RUN cargo install cargo-audit cargo-generate sccache
RUN cargo install cargo-generate

# Install cargo-fmt (the template needs it)
#RUN rustup component add rustfmt

# Generate project templates
RUN cargo generate -a Rahix/avr-hal-template --name rust-project-uno --vcs none -d board="Arduino Uno"
RUN cargo generate -a Rahix/avr-hal-template --name rust-project-nano --vcs none -d board="Arduino Nano"
RUN cargo generate -a Rahix/avr-hal-template --name rust-project-mega --vcs none -d board="Arduino Mega"
#RUN cargo generate -a esp-rs/esp-template --name rust-project-esp32 --vcs none --silent -d mcu=esp32 -d defaults=true
#RUN cargo generate -a esp-rs/esp-template --name rust-project-esp32s2 --vcs none --silent -d mcu=esp32s2 -d defaults=true
#RUN cargo generate -a esp-rs/esp-template --name rust-project-esp32s3 --vcs none --silent -d mcu=esp32s3 -d defaults=true
#RUN cargo generate -a esp-rs/esp-template --name rust-project-esp32c3 --vcs none --silent -d mcu=esp32c3 -d defaults=true

# Add alloc to the build-std property
#RUN find . -name "config.toml" -type f -exec sed -i 's/build-std = \["core"\]/build-std = \["alloc", "core"\]/g' {} +

# Copy utility scripts and setup
COPY compile.sh /home/wokwi/
RUN mkdir -p /home/wokwi/build-in /home/wokwi/build-out
#RUN pip3 install esptool

# Prebuild the template project for all targets
#RUN WOKWI_MCU=uno ./compile.sh
RUN WOKWI_MCU=atmega328p ./compile.sh
RUN WOKWI_MCU=atmega2560 ./compile.sh
#RUN WOKWI_MCU=esp32-s2 ./compile.sh
#RUN WOKWI_MCU=esp32-s3 ./compile.sh
#ENV WOKWI_MCU=uno
ENV HEXI_SRC_DIR="/home/wokwi/build-in"
ENV HEXI_BUILD_CMD="bash /home/wokwi/compile.sh"
ENV HEXI_OUT_HEX="/home/wokwi/build-out/project.hex"
ENV HEXI_OUT_ELF="/home/wokwi/build-out/project.elf"

EXPOSE 8080
ENV HEXI_LOGGER="stdout"
COPY --from=wokwi/mini-hexi /wokwi-hexi /wokwi-hexi
CMD /wokwi-hexi
