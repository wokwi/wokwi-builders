cmake_minimum_required(VERSION 3.13)
include(pico_sdk_import.cmake)
project(wokwi_project C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(PICO_NO_UF2 1)
pico_sdk_init()
AUX_SOURCE_DIRECTORY(src SOURCE_FILES) 
add_executable(wokwi_project
  ${SOURCE_FILES}
)
pico_add_extra_outputs(wokwi_project)
target_link_libraries(
  wokwi_project
  pico_stdlib
  hardware_adc
  hardware_clocks
  hardware_flash
  hardware_i2c
  hardware_interp
  hardware_pio
  hardware_pwm
)
