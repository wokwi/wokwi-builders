cmake_minimum_required(VERSION 3.5)
set(EXTRA_COMPONENT_DIRS $ENV{GOLIOTH_SDK_PATH}/components)
include($ENV{IDF_PATH}/tools/cmake/project.cmake)
project(wokwi_project)
