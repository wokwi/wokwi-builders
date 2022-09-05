FROM espressif/idf-rust:esp32c3_1.63.0.2

# Install cargo-generate
USER esp
ENV USER=esp
RUN cargo generate --vcs none --git https://github.com/esp-rs/esp-template --name rust-project --define mcu=esp32c3 --define devcontainer=false \
    && rm rust-project/Cargo.toml
COPY Cargo.toml rust-project/Cargo.toml

# Fetch
COPY fetch.sh /home/esp/
RUN bash fetch.sh

# Copy compilation script
COPY compile.sh /home/esp/
RUN mkdir -p /home/esp/build-in /home/esp/build-out
