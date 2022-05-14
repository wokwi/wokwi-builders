#!/bin/sh

. "$HOME/.cargo/env"
. "$HOME/.espressif/frameworks/esp-idf/export.sh"
. "$HOME/export-rust.sh"

set -e

case ${WOKWI_MCU} in
    "esp32")
      TOOLCHAIN="+esp"
      TARGET="xtensa-esp32-espidf"
      ARCHITECTURE="xtensa"
      ;;
    "esp32-s2")
      TOOLCHAIN="+esp"
      TARGET="xtensa-esp32s2-espidf"
      ARCHITECTURE="xtensa"
      ;;
    "esp32-s3")
      TOOLCHAIN="+esp"
      TARGET="xtensa-esp32s3-espidf"
      ARCHITECTURE="xtensa"
      ;;
    "esp32-c3")
      TOOLCHAIN=""
      TARGET="riscv32imc-esp-espidf"
      ARCHITECTURE="riscv"
      ;;
    *) # unknown
      echo "Environment variable WOKWI_MCU not set."
      echo "Available values esp32, esp32-s2, esp32-s3, esp32-c3"
      exit 1
      ;;
esac

echo "Configuration of ${WOKWI_MCU}"
echo " - TARGET    = ${TARGET}"
echo " - TOOLCHAIN = ${TOOLCHAIN}"

cd ~/rust-project-${ARCHITECTURE}
if [ -f ${HOME}/build-in/main.rs ]; then
  cat ${HOME}/build-in/main.rs > examples/ledc-simple.rs
fi
cargo ${TOOLCHAIN} build --example ledc-simple --release --target ${TARGET}
python3 -m esptool --chip ${WOKWI_MCU} elf2image --flash_size 4MB target/${TARGET}/release/examples/ledc-simple -o ${HOME}/build-out/project.bin
cp target/${TARGET}/release/examples/ledc-simple ${HOME}/build-out/project.elf