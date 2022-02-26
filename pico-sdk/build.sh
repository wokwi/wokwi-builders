#!/bin/sh
docker buildx build --platform linux/amd64,linux/arm64 -t wokwi/builder-pico-sdk:1.3.0 -t wokwi/builder-pico-sdk:latest --push .
