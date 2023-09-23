FROM alpine:3.18
RUN apk update
RUN apk add clang lld git make llvm

RUN git clone https://github.com/CraneStation/wasi-libc.git && \
    cd /wasi-libc && \
    make install INSTALL_DIR=/opt/wasi-libc && \
    rm -rf /wasi-libc

RUN mkdir -p /usr/lib/llvm16/lib/clang/16/lib/wasi/ && \
    wget -O /usr/lib/llvm16/lib/clang/16/lib/wasi/libclang_rt.builtins-wasm32.a https://github.com/jedisct1/libclang_rt.builtins-wasm32.a/blob/master/precompiled/llvm-15-to-16/libclang_rt.builtins-wasm32.a?raw=true

RUN mkdir /src && chown nobody /src
USER nobody
COPY --chown=nobody:nobody test.c /src/test.c
WORKDIR /src
RUN clang --target=wasm32-unknown-wasi --sysroot /opt/wasi-libc -nostartfiles -Wl,--no-entry -Wl,--export-all -o /tmp/app.wasm /src/test.c

ENV HEXI_SRC_DIR="/src"
ENV HEXI_BUILD_CMD="clang --target=wasm32-unknown-wasi --sysroot /opt/wasi-libc -nostartfiles -Wl,--export-table -Wl,--no-entry -Werror -o /tmp/app.wasm /src/app.c"
ENV HEXI_OUT_HEX="/tmp/app.wasm"
ENV HEXI_OUT_ELF="/tmp/app.elf"
