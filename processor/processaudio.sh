#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 infile "
  echo "       $0 infile noisefile"
  exit 1
fi

AUDIO_FILE_NAME=raw_audio.mp3
PROCESSED_FILE_NAME=processed_audio.mp3

# strip audio

ffmpeg -i $1 -b:a 256K -vn $AUDIO_FILE_NAME

sox_cmd="normalize $AUDIO_FILE_NAME $PROCESSED_FILE_NAME"

if [ $# -eq 2 ]; then
sox_cmd="$sox_cmd $2"
fi

eval $sox_cmd

sudo rm -rf $AUDIO_FILE_NAME

ffmpeg -i $1 -i $PROCESSED_FILE_NAME -map 0 -map 1 -codec copy -shortest final_video.mp4

lame -b 128 $PROCESSED_FILE_NAME final_podcast.mp3

sudo rm -rf $PROCESSED_FILE_NAME

echo "********************************************************************************"
echo "Final Video output: final_video.mp4"
echo "Final Audio output: final_podcast.mp4"
echo "********************************************************************************"
