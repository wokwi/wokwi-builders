FROM sergiogasquez/esp-rs-env:wokwi

# Examples from esp-idf-hal
RUN git clone https://github.com/esp-rs/esp-idf-hal.git rust-project

# Copy compilation script
COPY compile.sh /home/esp/

ENV IDF_TOOLS_PATH=/home/esp/.espressif
# Compile esp-idf-hal examples
RUN cd rust-project \
    && export WOKWI_MCU="esp32" \
    && bash /home/esp/compile.sh \
    && export WOKWI_MCU="esp32-c3" \
    && bash /home/esp/compile.sh \
    && export WOKWI_MCU="esp32-s2" \
    && bash /home/esp/compile.sh \
    && rm /home/esp/rust-project/build-out/project.bin