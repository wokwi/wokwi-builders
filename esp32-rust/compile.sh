#!/bin/sh

cd rust-project
cat build-in/main.rs > examples/ledc-simple.rs && \
cargo +esp build --example ledc-simple --release --target xtensa-esp32-espidf && \
python3 -m esptool --chip esp32 elf2image --flash_size 4MB target/xtensa-esp32-espidf/release/examples/ledc-simple -o build-out/project.bin
