#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 infile "
  echo "       $0 infile noisefile"
  exit 1
fi

AUDIO_FILE_NAME=standalone_audio.mp3
PROCESSED_FILE_NAME=processed_audio.mp3

# strip audio

ffmpeg -i $1 -b:a 256K -vn $AUDIO_FILE_NAME

sox_cmd="normalize $AUDIO_FILE_NAME $PROCESSED_FILE_NAME"

if [ $# -eq 2 ]; then
sox_cmd="$sox_cmd $2"
fi

eval $sox_cmd
