#!/bin/bash

set -e
. /home/esp/export-esp.sh
pip3 install esptool

cd rust-project
cargo fetch
cargo build --release