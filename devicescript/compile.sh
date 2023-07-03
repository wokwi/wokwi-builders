#!/bin/sh

case "$WOKWI_BOARD" in
"esp32:esp32:esp32doit-devkit-v1")
    DEVICESCRIPT_BOARD="esp32_devkit_c"
    DEVICESCRIPT_BIN="bundle-devicescript-esp32-esp32_devkit_c-0x1000.bin"
    ;;
"esp32:esp32:esp32c3")
    DEVICESCRIPT_BOARD="esp32c3_bare"
    DEVICESCRIPT_BIN="bundle-devicescript-esp32c3-esp32c3_bare-0x0.bin"
    ;;
"pipico")
    DEVICESCRIPT_BOARD="pico"
    DEVICESCRIPT_BIN="bundle-devicescript-rp2040-pico.uf2"
    ;;
*)
    >&2 echo "Unsupported wokwi board: $WOKWI_BOARD"
    exit 1
    ;;
esac

rm -rf /app/.devicescript/bin
cp /app/build-in/*.ts src/
devs bundle --no-colors --board ${DEVICESCRIPT_BOARD} src/main.ts
cp /app/.devicescript/bin/${DEVICESCRIPT_BIN} /app/.devicescript/bin/output.bin
