FROM espressif/idf-rust:all_v4.4_1.64.0.0

USER esp
ENV USER=esp
RUN cargo generate --vcs none --git https://github.com/esp-rs/esp-template --name rust-project  --vcs none --silent -d mcu=${WOKWI_MCU}  -d devcontainer=false -d alloc=false

# Copy compilation script
COPY compile.sh /home/esp/
RUN mkdir -p /home/esp/build-in /home/esp/build-out

# Fetch
COPY fetch.sh /home/esp/
RUN bash fetch.sh

# Install sccacahe
RUN cargo install sccache
ENV SCCACHE_REDIS=${REDIST_URL}
