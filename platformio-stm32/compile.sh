#!/bin/bash

OUTPUT_DIR="/home/wokwi/project/output"

# Extract the pnum from the board specification, convert it to lowercase
REGEX='[:,]pnum=([a-zA-Z0-9_]+)'
[[ "$WOKWI_BOARD" =~ $REGEX ]]
ENV=${BASH_REMATCH[1],,}

export PLATFORMIO_DEFAULT_ENVS="$ENV"
rm -rf /home/wokwi/project/.pio/build/$ENV/firmware.*

if [ "$WOKWI_DEBUG_BUILD" == "1" ]; then
  pio debug
else
  pio run
fi

mkdir -p "$OUTPUT_DIR"
cp /home/wokwi/project/.pio/build/$ENV/firmware.* $OUTPUT_DIR 2>>/dev/null
