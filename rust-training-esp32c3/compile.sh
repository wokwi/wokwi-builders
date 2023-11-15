#!/bin/bash

set -e

export IDF_TOOLS_PATH=/home/esp/.espressif
. /home/esp/.espressif/frameworks/esp-idf/export.sh
export ESP_IDF_TOOLS_INSTALL_DIR=fromenv

if [ -f ${HOME}/build-in/Cargo.toml ]; then
    PROJECT_NAME=$(awk -F= '/name/ {gsub(/^[[:space:]]+|['\''"]|[[:space:]]+$/,"",$2); print $2}' ${HOME}/build-in/Cargo.toml)
    case ${PROJECT_NAME} in
    "button-interrupt")
        PROJECT_PATH="advanced/button-interrupt"
        ;;
    "i2c-driver")
        PROJECT_PATH="advanced/i2c-driver"
        ;;
    "i2c-sensor-reading")
        PROJECT_PATH="advanced/i2c-sensor-reading"
        ;;
    "hardware-check")
        PROJECT_PATH="intro/hardware-check"
        ;;
    "http-client")
        PROJECT_PATH="intro/http-client"
        ;;
    "http-server")
        PROJECT_PATH="intro/http-server"
        ;;
    "mqtt")
        PROJECT_PATH="intro/mqtt/exercise"
        ;;
    *)
        echo "Missing or invalid Cargo.toml file"
        exit 1
        ;;
    esac
    cd std-training/${PROJECT_PATH}
    cp ${HOME}/build-in/Cargo.toml Cargo.toml
fi

if [[ ${PROJECT_PATH} == *"intro"* ]]; then
    cp /home/esp/cfg.toml .
fi

if [ "$(find ${HOME}/build-in -name '*.rs')" ]; then
    cp ${HOME}/build-in/*.rs src
fi

cargo build --release
espflash save-image --chip esp32c3 --flash-size 4mb target/riscv32imc-esp-espidf/release/${PROJECT_NAME} ${HOME}/build-out/project.bin
cp target/riscv32imc-esp-espidf/release/${PROJECT_NAME} ${HOME}/build-out/project.elf
