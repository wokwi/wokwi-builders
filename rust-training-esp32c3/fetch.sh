#!/bin/bash

set -e
pip3 install esptool

cd espressif-trainings/intro/hardware-check
cargo fetch
cargo build --release
