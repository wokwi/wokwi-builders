FROM espressif/idf:v5.3.1

RUN useradd -rm -d /home/wokwi wokwi
USER wokwi
WORKDIR /home/wokwi
ENV USER=wokwi

# Copy utility scripts and setup
COPY compile.sh /home/wokwi/
ADD project /home/wokwi/esp-project-template
RUN mkdir -p /home/wokwi/build-in /home/wokwi/build-out

ENV HEXI_SRC_DIR="/home/wokwi/build-in"
ENV HEXI_BUILD_CMD="bash /home/wokwi/compile.sh"
ENV HEXI_OUT_HEX="/home/wokwi/build-out/project.bin"
ENV HEXI_OUT_ELF="/home/wokwi/build-out/project.elf"
RUN WOKWI_MCU=esp32 ./compile.sh
RUN WOKWI_MCU=esp32-s2 ./compile.sh
RUN WOKWI_MCU=esp32-s3 ./compile.sh
RUN WOKWI_MCU=esp32-c3 ./compile.sh
RUN WOKWI_MCU=esp32-c6 ./compile.sh
RUN WOKWI_MCU=esp32-h2 ./compile.sh
RUN WOKWI_MCU=esp32-p4 ./compile.sh
