FROM alpine:3.17
RUN apk update
RUN apk add clang lld git make llvm

RUN git clone https://github.com/CraneStation/wasi-libc.git && \
    cd /wasi-libc && \
    make install INSTALL_DIR=/opt/wasi-libc && \
    rm -rf /wasi-libc

RUN mkdir -p /usr/lib/clang/15.0.6/lib/wasi && \
    wget -O /usr/lib/clang/15.0.6/lib/wasi/libclang_rt.builtins-wasm32.a https://github.com/jedisct1/libclang_rt.builtins-wasm32.a/blob/master/precompiled/libclang_rt.builtins-wasm32.a?raw=true

RUN mkdir /src && chown nobody /src
USER nobody
COPY --chown=nobody:nobody test.c /src/test.c
WORKDIR /src
RUN clang --target=wasm32-unknown-wasi --sysroot /opt/wasi-libc -nostartfiles -Wl,--import-memory -Wl,--no-entry -Wl,--export-all -o /tmp/app.wasm /src/test.c
