#!/bin/bash

set -e
. /home/esp/export-esp.sh

cd espressif-trainings/intro/hardware-check
if [ -f ${HOME}/build-in/main.rs ]; then
    cat ${HOME}/build-in/main.rs > src/main.rs
fi

if [ -f ${HOME}/build-in/lib.rs ]; then
    cat ${HOME}/build-in/lib.rs > src/lib.rs
fi

if [ -f ${HOME}/build-in/imc42670p.rs ]; then
    cat ${HOME}/build-in/imc42670p.rs > src/imc42670p.rs
fi
cargo build --offline --release
python3 -m esptool --chip ${WOKWI_MCU} elf2image --flash_size 4MB target/riscv32imc-esp-espidf/release/hardware-check -o ${HOME}/build-out/project.bin
cp target/riscv32imc-esp-espidf/release/hardware-check ${HOME}/build-out/project.elf