#!/bin/bash

set -e
. /home/esp/export-esp.sh
export ESP_IDF_TOOLS_INSTALL_DIR=global

case ${WOKWI_MCU} in
"esp32")
    PROJECT_NAME="rust-project-esp32"
    ;;
"esp32-c3")
    PROJECT_NAME="rust-project-esp32c3"
    ;;
"esp32-c6")
    PROJECT_NAME="rust-project-esp32c6"
    ;;
"esp32-s2")
    PROJECT_NAME="rust-project-esp32s2"
    ;;
"esp32-s3")
    PROJECT_NAME="rust-project-esp32s3"
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

cargo build --release --out-dir output -Z unstable-options
cargo audit
espflash save-image --chip ${WOKWI_MCU_NO_DASH} --flash-size 4mb ${PROJECT_ROOT}/output/${PROJECT_NAME} ${HOME}/build-out/project.bin
cp output/${PROJECT_NAME} ${HOME}/build-out/project.elf
