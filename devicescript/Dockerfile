FROM node:18-alpine

RUN adduser -h /app -D wokwi

RUN npm i -g @devicescript/cli@latest

USER wokwi
WORKDIR /app
RUN devs init
RUN devs bundle --board esp32c3_bare src/main.ts

# TODO: support other boards, e.g.:
#RUN devs bundle --board esp32_devkit_c src/main.ts
#RUN devs bundle --board esp32s2_bare src/main.ts
#RUN devs bundle --board esp32c3_rust_devkit src/main.ts
#RUN devs bundle --board esp32s3_devkit_m src/main.ts
#RUN devs bundle --board pico src/main.ts

ENV HOME="/app"
ENV HEXI_SRC_DIR="/app/build-in"
ENV HEXI_SRC_FILES="*.ts"
ENV HEXI_BUILD_CMD="cp /app/build-in/*.ts src/ && devs bundle --board esp32c3_bare src/main.ts"
ENV HEXI_OUT_HEX="/app/.devicescript/bin/bundle-devicescript-esp32c3-esp32c3_bare-0x0.bin"
ENV HEXI_OUT_ELF="dummy"