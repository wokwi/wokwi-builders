#!/bin/bash

set -e
. /home/esp/export-esp.sh

case ${WOKWI_MCU} in
"esp32")
    PROJECT_NAME="rust-project-esp32"
    TARGET="xtensa-esp32-none-elf"
    ;;
"esp32-c3")
    PROJECT_NAME="rust-project-esp32c3"
    TARGET="riscv32imc-unknown-none-elf"
    rm ${PROJECT_NAME}/.cargo/config.toml
    cp ${HOME}/config.toml ${PROJECT_NAME}/.cargo/config.toml
    ;;
"esp32-c6")
    PROJECT_NAME="rust-project-esp32c6"
    TARGET="riscv32imac-unknown-none-elf"
    ;;
"esp32-h2")
    PROJECT_NAME="rust-project-esp32h2"
    TARGET="riscv32imac-unknown-none-elf"
    ;;
"esp32-s2")
    PROJECT_NAME="rust-project-esp32s2"
    TARGET="xtensa-esp32s2-none-elf"
    ;;
"esp32-s3")
    PROJECT_NAME="rust-project-esp32s3"
    TARGET="xtensa-esp32s3-none-elf"
    ;;
*)
    echo "Missing or invalid WOKWI_MCU environment variable"
    exit 1
    ;;
esac

cd ${PROJECT_NAME}
mkdir -p output
PROJECT_ROOT="${HOME}/${PROJECT_NAME}"
WOKWI_MCU_NO_DASH="${WOKWI_MCU//-/}"

if [ "$(find ${HOME}/build-in -name '*.rs')" ]; then
    cp ${HOME}/build-in/*.rs src
fi

if [ -f ${HOME}/build-in/Cargo.toml ]; then
    cp ${HOME}/build-in/Cargo.toml Cargo.toml
    rnamer -n ${PROJECT_NAME}
fi

cargo audit
cargo build --release
espflash save-image --chip ${WOKWI_MCU_NO_DASH} --flash-size 4mb target/${TARGET}/release/${PROJECT_NAME} ${HOME}/build-out/project.bin
cp target/${TARGET}/release/${PROJECT_NAME} ${HOME}/build-out/project.elf
