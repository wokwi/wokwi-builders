# Base image
FROM espressif/rust-std-training
WORKDIR /root
RUN git clone https://github.com/ferrous-systems/espressif-trainings.git espressif-trainings \
    && rm -rf espressif-trainings/book \
    && rm espressif-trainings/intro/hardware-check/Cargo.toml

ENV IDF_TOOLS_PATH=/root/.espressif
RUN echo "source /root/.espressif/frameworks/esp-idf/export.sh > /dev/null 2>&1" >> ~/.bashrc
ENV PATH=${PATH}:/root/.cargo/bin

COPY Cargo.toml espressif-trainings/intro/hardware-check/Cargo.toml
COPY sdkconfig.defaults espressif-trainings/intro/hardware-check/sdkconfig.defaults
COPY cfg.toml espressif-trainings/intro/hardware-check/cfg.toml

# Fetch
COPY fetch.sh /root/
RUN bash fetch.sh

# Copy compilation script
COPY compile.sh /root/
RUN mkdir -p /root/build-in /root/build-out
