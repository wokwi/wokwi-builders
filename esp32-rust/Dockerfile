FROM sergiogasquez/esp-rs-env:wokwi

# Examples from esp-idf-hal
RUN git clone https://github.com/esp-rs/esp-idf-hal.git rust-project

RUN pip3 install esptool --user

COPY compile.sh /home/esp

# Compile esp-idf-hal examples
RUN cd rust-project \
 && export WOKWI_MCU="esp32-c3" \
 && /home/esp/compile.sh \
 && export WOKWI_MCU="esp32" \
 && /home/esp/compile.sh \
 && rm /home/esp/rust-project/build-out/project.bin
