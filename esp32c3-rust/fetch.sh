#!/bin/sh

set -e
. /home/esp/export-esp.sh

cd rust-project
cargo fetch
cargo build --release