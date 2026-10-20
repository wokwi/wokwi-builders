#!/bin/sh

rm -f build

case "$WOKWI_BOARD" in
  rp2040:rp2040:rpipicow) BUILD_DIR=build_pico_w ;;
  rp2040:rp2040:rpipico2) BUILD_DIR=build_pico2 ;;
  rp2040:rp2040:rpipico2w) BUILD_DIR=build_pico2_w ;;
  *) BUILD_DIR=build_pico ;;
esac

ln -s $BUILD_DIR build
cd $BUILD_DIR

cmake .. && make -j4
