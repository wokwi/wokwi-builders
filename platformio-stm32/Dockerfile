FROM ubuntu:22.04

RUN apt-get update && apt-get install -y python3 python3-venv curl
RUN adduser --disabled-password --gecos "" wokwi
USER wokwi

# Install PlatformIO Core (CLI)
WORKDIR /home/wokwi
RUN python3 -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"

ADD --chown=wokwi project /home/wokwi/project
ENV PATH=$PATH:/home/wokwi/.platformio/penv/bin
WORKDIR /home/wokwi/project
RUN pio run

