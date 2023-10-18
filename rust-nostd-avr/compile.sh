#!/bin/bash

#ENV MCU="avr-atmega328p"
echo $WOKWI_MCU
case ${WOKWI_MCU} in
"atmega328p")
    PROJECT_NAME="rust-project-uno"
    MCU="avr-atmega328p"
    ;;
"atmega2560")
    PROJECT_NAME="rust-project-mega"
    MCU="avr-atmega2560"
    ;;

*)
    echo "Missing or invalid WOKWI_MCU environment variable"
    exit 1
    ;;
esac

cd ${PROJECT_NAME}
PROJECT_ROOT="${HOME}/${PROJECT_NAME}"

if [ "$(find ${HOME}/build-in -name '*.rs')" ]; then
    cp ${HOME}/build-in/*.rs src
fi

if [ -f ${HOME}/build-in/Cargo.toml ]; then
    cp ${HOME}/build-in/Cargo.toml Cargo.toml
    sed -i 's/^[[:space:]]*name[[:space:]]*=[[:space:]]*["'"'"']\([^"'"'"']*\)["'"'"']\([[:space:]]*\)$/\nname = "'${PROJECT_NAME}'"/' Cargo.toml
fi

cargo audit
cargo build --release --out-dir output -Z unstable-options
avr-objcopy -R .eeprom -O ihex ./target/${MCU}/release/${PROJECT_NAME}.elf ${HOME}/build-out/project.hex
cp ./target/${MCU}/release/${PROJECT_NAME}.elf ${HOME}/build-out/project.elf
