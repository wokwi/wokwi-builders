#!/bin/sh

set -e
export IDF_TOOLS_PATH=/home/esp/.espressif
. "$HOME/.cargo/env"
. /home/esp/.espressif/frameworks/esp-idf/export.sh

cd espressif-trainings/intro/hardware-check
cargo fetch
cargo build --release