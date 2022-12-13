#!/bin/bash
yosys -p "read_verilog src/wokwi.v; write_cxxrtl src/wokwi_cxxrtl.h" || exit 1
source /opt/emsdk/emsdk_env.sh
emcc -O3 -std=c++14 -I `yosys-config --datdir`/include -Isrc main.cpp --no-entry -sERROR_ON_UNDEFINED_SYMBOLS=0 -sINITIAL_MEMORY=128kb -sALLOW_MEMORY_GROWTH -sTOTAL_STACK=64kb -o wokwi.wasm
