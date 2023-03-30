#!/bin/sh

rm -f build

if [ "$WOKWI_BOARD" == "rp2040:rp2040:rpipicow" ]; then
  ln -s build_pico_w build
  cd build_pico_w
else
  ln -s build_pico build
  cd build_pico
fi

cmake .. && make -j4
