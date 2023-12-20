#!/bin/bash

set -e

echo $WOKWI_MCU

source /opt/esp/idf/export.sh

case ${WOKWI_MCU} in
"esp32")
    MCU="esp32"
    ;;
"esp32-c3")
    MCU="esp32c3"
    ;;
"esp32-c6")
    MCU="esp32c6"
    ;;
"esp32-h2")
    MCU="esp32h2"
    ;;
"esp32-s2")
    MCU="esp32s2"
    ;;
"esp32-s3")
    MCU="esp32s3"
    ;;
*)
    echo "Missing or invalid WOKWI_MCU environment variable"
    exit 1
    ;;
esac

PROJECT_NAME="esp-project-${MCU}"
PROJECT_ROOT="${HOME}/${PROJECT_NAME}"

if [ ! -e ${PROJECT_ROOT} ]; then
    cp -R ${HOME}/esp-project-template ${PROJECT_ROOT}
    cd $PROJECT_ROOT
    idf.py set-target ${MCU}
fi

cd $PROJECT_ROOT

if [ "$(find ${HOME}/build-in -name '*.c')" ]; then
   cp ${HOME}/build-in/*.c main/src
fi
if [ "$(find ${HOME}/build-in -name '*.h')" ]; then
   cp ${HOME}/build-in/*.h main/src
fi

idf.py build 1>&2

rm -f main/src/*

cp ./build/wokwi-project.bin ${HOME}/build-out/project.bin
cp ./build/wokwi-project.elf ${HOME}/build-out/project.elf
