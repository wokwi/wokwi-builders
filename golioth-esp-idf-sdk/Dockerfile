FROM espressif/idf:release-v4.4

RUN useradd -ms /bin/bash wokwi

USER wokwi
WORKDIR /home/wokwi
ENV IDF_PATH=/opt/esp/idf

RUN git clone --recursive https://github.com/golioth/golioth-esp-idf-sdk.git && \
    cd golioth-esp-idf-sdk && \
    git submodule update --init --recursive

COPY --chown=wokwi:wokwi project project/
WORKDIR /home/wokwi/project
ENV GOLIOTH_SDK_PATH=/home/wokwi/golioth-esp-idf-sdk

RUN . /opt/esp/entrypoint.sh && idf.py build
