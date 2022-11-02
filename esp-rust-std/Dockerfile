FROM espressif/idf-rust:all_v4.4_1.64.0.0

USER esp
ENV USER=esp
RUN cargo generate --vcs none --git https://github.com/esp-rs/esp-idf-template cargo --name rust-project --define mcu=${WOKWI_MCU} --define espidfver=v4.4 --define std=true --define devcontainer=false

# Copy compilation script
COPY compile.sh /home/esp/
RUN mkdir -p /home/esp/build-in /home/esp/build-out

# Fetch
COPY fetch.sh /home/esp/
RUN bash fetch.sh

# Install sccacahe
RUN cargo install sccache
ENV SCCACHE_REDIS=${REDIST_URL}
