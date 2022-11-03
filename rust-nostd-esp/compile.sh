#!/bin/bash

set -e
. /home/esp/export-esp.sh
export CARGO_INCREMENTAL=0
export RUSTC_WRAPPER=$(which sccache)

cd rust-project
mkdir -p output

if [ -f ${HOME}/build-in/main.rs ]; then
    cat ${HOME}/build-in/*.rs >src/*.rs
fi

if [ -f ${HOME}/build-in/Cargo.toml ]; then
    cat ${HOME}/build-in/Cargo.toml >Cargo.toml
fi

cargo build --release --out-dir output -Z unstable-options
python3 -m esptool --chip ${WOKWI_MCU} elf2image --flash_size 4MB output/rust-project -o ${HOME}/build-out/project.bin
cp output/release/rust-project ${HOME}/build-out/project.elf
