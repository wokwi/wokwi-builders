#!/bin/sh

. "$HOME/.cargo/env"
. "$HOME/.espressif/frameworks/esp-idf-v4.4/export.sh"
. "$HOME/export-rust.sh"

set -e

case ${WOKWI_MCU} in
    "esp32")
      TOOLCHAIN="+esp"
      TARGET="xtensa-esp32-espidf"
      ;;
    "esp32-s2")
      TOOLCHAIN="+esp"
      TARGET="xtensa-esp32s2-espidf"
      ;;
    "esp32-s3")
      TOOLCHAIN="+esp"
      TARGET="xtensa-esp32s3-espidf"
      ;;
    "esp32-c3")
      TOOLCHAIN=""
      TARGET="riscv32imc-esp-espidf"
      ;;
    *) # unknown
      echo "Environment variable WOKWI_MCU not set."
      echo "Available values esp32, esp32-s2, esp32-c3"
      exit 1
      ;;
esac

echo "Configuration of ${WOKWI_MCU}"
echo " - TARGET    = ${TARGET}"
echo " - TOOLCHAIN = ${TOOLCHAIN}"

cd ~/rust-project
mkdir -p build-out

if [ -f build-in/main.rs ]; then
  cat build-in/main.rs > examples/ledc-simple.rs
fi
pip3 install esptool
cargo ${TOOLCHAIN} build --example ledc-simple --release --target ${TARGET}
python3 -m esptool --chip ${WOKWI_MCU} elf2image --flash_size 4MB target/${TARGET}/release/examples/ledc-simple -o build-out/project.bin