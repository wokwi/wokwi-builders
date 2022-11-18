FROM alpine:3
RUN apk update
RUN apk add git file 

ENV CC="zig cc -fno-sanitize=all -lc $@"
RUN wget -q https://github.com/marler8997/zigup/releases/download/v2022_08_25/zigup.ubuntu-latest-x86_64.zip && \
    unzip zigup.ubuntu-latest-x86_64.zip -d /usr/bin && \
    chmod +x /usr/bin/zigup && \
    zigup 0.10.0 && echo -e "$(zig cc --version)"

RUN mkdir /src && chown nobody /src
USER nobody
COPY --chown=nobody:nobody test.c /src/test.c
WORKDIR /src
USER root
RUN $CC --target=wasm32-wasi -o /tmp/app.wasm /src/test.c && file /tmp/app.wasm
