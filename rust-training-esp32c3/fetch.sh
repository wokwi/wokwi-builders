#!/bin/sh

set -ef

export IDF_PATH="/home/esp/.espressif/frameworks/esp-idf"
export IDF_TOOLS_PATH=/home/esp/.espressif
. /home/esp/.espressif/frameworks/esp-idf/export.sh
export ESP_IDF_TOOLS_INSTALL_DIR=fromenv

echo "Compiling $1"

cd /home/esp/std-training/$1

if [ -f cfg.toml.example ]; then
    # Rename file to cfg.toml
    cp cfg.toml.example cfg.toml
    # Replace defaults
    sed -i 's/wifi_ssid = "FBI Surveillance Van"/wifi_ssid = "Wokwi-GUEST"/g' cfg.toml
    sed -i 's/wifi_psk = "hunter2"/wifi_psk = ""/g' cfg.toml
    sed -i 's/mqtt_user = "horse"/mqtt_user = "user"/g' cfg.toml
    sed -i 's/mqtt_pass = "CorrectHorseBatteryStaple"/mqtt_pass = "pass"/g' cfg.toml
    sed -i 's/mqtt_host = "yourpc.local"/mqtt_host = "host"/g' cfg.toml
fi

$HOME/.cargo/bin/cargo build --release
