#!/bin/bash

set -e
. /home/esp/export-esp.sh
export CARGO_INCREMENTAL=0
export RUSTC_WRAPPER=$(which sccache)

case ${WOKWI_MCU} in
    "esp32")
        PROJECT_NAME="rust-project-esp32"
        ;;
    "esp32-c3")
        PROJECT_NAME="rust-project-esp32c3"
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

if [ "$(find ${HOME}/build-in -name '*.rs')" ]; then
    cp ${HOME}/build-in/*.rs src
fi

if [ -f ${HOME}/build-in/Cargo.toml ]; then
    cp ${HOME}/build-in/Cargo.toml Cargo.toml
fi

PROJECT_ROOT="${HOME}/${PROJECT_NAME}"
PROJECT_NAME_UNDERSCORE=${PROJECT_NAME//-/_}
cargo build --release --out-dir output -Z unstable-options
python3 -m esptool --chip ${WOKWI_MCU} elf2image --flash_size 4MB ${PROJECT_ROOT}/output/${PROJECT_NAME_UNDERSCORE} -o ${HOME}/build-out/project.bin
cp output/${PROJECT_NAME_UNDERSCORE} ${HOME}/build-out/project.elf
