#!/bin/bash

set -e
. /home/esp/export-esp.sh
cd rust-project
if [ -f ${HOME}/build-in/main.rs ]; then
    cat ${HOME}/build-in/main.rs >src/main.rs
fi
cargo build --offline --release
python3 -m esptool --chip ${WOKWI_MCU} elf2image --flash_size 4MB target/xtensa-esp32s2-none-elf/release/rust-project -o ${HOME}/build-out/project.bin
cp target/xtensa-esp32s2-none-elf/release/rust-project ${HOME}/build-out/project.elf
