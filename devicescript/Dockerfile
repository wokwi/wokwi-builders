FROM node:18-alpine

RUN adduser -h /app -D wokwi

RUN npm i -g @devicescript/cli@latest

USER wokwi
WORKDIR /app
RUN devs init

ADD compile.sh /app

RUN devs bundle --board esp32c3_bare src/main.ts
RUN devs bundle --board pico src/main.ts

# TODO: support other boards, e.g.:
#RUN devs bundle --board esp32_devkit_c src/main.ts
#RUN devs bundle --board esp32s2_bare src/main.ts
#RUN devs bundle --board esp32c3_rust_devkit src/main.ts
#RUN devs bundle --board esp32s3_devkit_m src/main.ts

ENV HOME="/app"
ENV HEXI_SRC_DIR="/app/build-in"
ENV HEXI_SRC_FILES="*.ts"
ENV HEXI_BUILD_CMD="./compile.sh"
ENV HEXI_OUT_HEX="/app/.devicescript/bin/output.bin"
ENV HEXI_OUT_ELF="dummy"
