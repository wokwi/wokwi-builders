FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y git curl python3 xz-utils bzip2
WORKDIR /opt
RUN curl -L https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2023-07-31/oss-cad-suite-linux-x64-20230731.tgz | tar zxf -
RUN git clone --depth 1 https://github.com/emscripten-core/emsdk.git
WORKDIR /opt/emsdk
RUN ./emsdk install latest && ./emsdk activate latest

RUN adduser --disabled-password --gecos "" wokwi
USER wokwi
ENV PATH="/opt/oss-cad-suite/bin:${PATH}"
ADD --chown=wokwi project /home/wokwi/project
WORKDIR /home/wokwi/project
RUN ./compile.sh

# Wokwi builder configuration:
ENV HEXI_SRC_DIR="/home/wokwi/project/src"
ENV HEXI_BUILD_CMD="/home/wokwi/project/compile.sh"
ENV HEXI_OUT_HEX="/home/wokwi/project/wokwi.wasm"
ENV HEXI_OUT_ELF="/home/wokwi/project/wokwi.wasm"
