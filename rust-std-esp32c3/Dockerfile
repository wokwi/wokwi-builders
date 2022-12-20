FROM espressif/idf-rust:esp32c3_v4.4_latest

# Install cargo-generate
USER esp
ENV USER=esp
RUN cargo generate --vcs none --git https://github.com/esp-rs/esp-idf-template cargo --name rust-project --define mcu=esp32c3 --define espidfver=v4.4 --define std=true --define devcontainer=false \
    && rm rust-project/Cargo.toml
COPY Cargo.toml rust-project/Cargo.toml
ADD assets rust-project/assets


# Fetch
COPY fetch.sh /home/esp/
RUN bash fetch.sh

# Copy compilation script
COPY compile.sh /home/esp/
RUN mkdir -p /home/esp/build-in /home/esp/build-out
