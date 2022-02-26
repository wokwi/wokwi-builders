cmake_minimum_required(VERSION 3.13)
include(pico_sdk_import.cmake)
project(wokwi_project C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
pico_sdk_init()
add_executable(wokwi_project
  src/main.c
)
pico_add_extra_outputs(wokwi_project)
target_link_libraries(wokwi_project pico_stdlib)
