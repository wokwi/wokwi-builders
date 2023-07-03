# it pulles latest nightly a base image, but because of LLVM bug installes a specifc nightly in the generate step
# -> if resolved can used latest / new stable
# https://github.com/rust-lang/compiler-builtins/issues/523
# we could directly pull that special nightly version but the following problem:
# offical rust container dont have taged container :/
# So two options.
# 1) Use offical nightly rust-lang container and let it install the needed nightly version
# 2) Use instrumentist container - would shrink the image a bit?
#
# I think it would be save to use instrumentist container as they are just retagged versions
# can check here ->
# https://github.com/rust-lang/docker-rust-nightly/issues/3
# https://github.com/instrumentisto/rust-docker-image/blob/5a7de506e39bd8ce6ccda3d55830d333d764b874/nightly/buster/hooks/post_push#L26-L27
# but i opted for the normal latest nightly container currently

#FROM instrumentisto/rust:nightly-bullseye-2022-12-13
FROM rustlang/rust:nightly-bullseye

# Install avr-gcc, binutils and libc - used for linking + creating elf
RUN apt-get update && apt-get install -y avr-libc binutils-avr gcc-avr

RUN useradd -rm -d /home/wokwi wokwi
USER wokwi
WORKDIR /home/wokwi
ENV USER=wokwi

# Check rust version
RUN cargo --version
RUN rustup show

# Install extra crates
# it would be nice if we could get cargo-audit and sccache in some binary form :D this build step take's ages
RUN cargo install cargo-audit cargo-generate sccache --locked

# Generate project templates
RUN cargo generate -a Rahix/avr-hal-template --name rust-project-uno --vcs none --silent -d board="Arduino Uno"
# because WOKWI_MCU cant give us a clear board answer we cant utilize the different setup here
# we would need some env var like WOKWI_BOARD that gives us info what board is used
# the different in the projects is that the nano supports two additional pins in its layout
# we can use the above generated project as a base - but need to change Cargo.toml to use
#
# [dependencies.arduino-hal]
# features = ["arduino-nano"]
#
# this will unforunatly mean a user that opens a project with a nano will trigger a rebuild because the Cargo.toml changed
#RUN cargo generate -a Rahix/avr-hal-template --name rust-project-nano --vcs none --silent -d board="Arduino Nano"
RUN cargo generate -a Rahix/avr-hal-template --name rust-project-mega --vcs none --silent -d board="Arduino Mega 2560"

# Copy utility scripts and setup
COPY compile.sh /home/wokwi/
RUN mkdir -p /home/wokwi/build-in /home/wokwi/build-out

# Prebuild the template project for all targets
RUN WOKWI_MCU=atmega328p ./compile.sh
RUN WOKWI_MCU=atmega2560 ./compile.sh

ENV HEXI_SRC_DIR="/home/wokwi/build-in"
ENV HEXI_SRC_FILES="*(*.rs|Cargo.toml)"
ENV HEXI_BUILD_CMD="bash /home/wokwi/compile.sh"
ENV HEXI_OUT_HEX="/home/wokwi/build-out/project.hex"
ENV HEXI_OUT_ELF="/home/wokwi/build-out/project.elf"
