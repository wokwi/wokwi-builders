#!/bin/bash

#set -e
#. /home/esp/export-esp.sh
export CARGO_INCREMENTAL=0
export RUSTC_WRAPPER=$(which sccache)
#PROJECT_NAME="rust-project-uno"

echo $WOKWI_MCU
case ${WOKWI_MCU} in
"atmega328p")
    PROJECT_NAME="rust-project-uno"
    ;;
"atmega2560")
    PROJECT_NAME="rust-project-mega"
    ;;

*)
    echo "Missing or invalid WOKWI_MCU environment variable"
    exit 1
    ;;
esac

cd ${PROJECT_NAME}
#mkdir -p output
PROJECT_ROOT="${HOME}/${PROJECT_NAME}"
#PROJECT_NAME_UNDERSCORE=${PROJECT_NAME//-/_}

if [ "$(find ${HOME}/build-in -name '*.rs')" ]; then
    cp ${HOME}/build-in/*.rs src
fi

if [ -f ${HOME}/build-in/Cargo.toml ]; then
    cp ${HOME}/build-in/Cargo.toml Cargo.toml
    sed -i 's/^[[:space:]]*name[[:space:]]*=[[:space:]]*["'"'"']\([^"'"'"']*\)["'"'"']\([[:space:]]*\)$/\nname = "'${PROJECT_NAME}'"/' Cargo.toml
fi

#cargo audit
cargo build --release --out-dir output -Z unstable-options
#python3 -m esptool --chip ${WOKWI_MCU} elf2image --flash_size 4MB ${PROJECT_ROOT}/output/${PROJECT_NAME_UNDERSCORE} -o ${HOME}/build-out/project.bin
#avr-objcopy -O binary ./target/${MCU}/release/${PROJECT_NAME}.elf ${HOME}/build-out/project.bin
avr-objcopy -R .eeprom -O ihex ./target/${MCU}/release/${PROJECT_NAME}.elf  ${HOME}/build-out/project.hex
cp ./target/${MCU}/release/${PROJECT_NAME}.elf ${HOME}/build-out/project.elf
