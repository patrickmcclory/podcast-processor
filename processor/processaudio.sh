#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 infile "
  echo "       $0 infile noisefile"
  exit 1
fi

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

AUDIO_FILE_NAME=raw_audio-$TIMESTAMP.mp3
PROCESSED_FILE_NAME=processed_audio-$TIMESTAMP.mp3

FINAL_VIDEO_FILE_NAME=final_video-$TIMESTAMP.mp4
FINAL_AUDIO_FILE_NAME=final_audio-$TIMESTAMP.mp4

# strip audio

ffmpeg -i $1 -b:a $AUDIO_RIP_BITRATEK -vn $AUDIO_FILE_NAME

normalize_cmd="normalize $AUDIO_FILE_NAME $PROCESSED_FILE_NAME"

if [ $# -eq 2 ]; then
normalize_cmd="$normalize_cmd $2"
fi

eval $normalize_cmd

sudo rm -rf $AUDIO_FILE_NAME

ffmpeg -i $1 -i $PROCESSED_FILE_NAME -map 0 -map 1 -codec copy -shortest $FINAL_VIDEO_FILE_NAME

lame -b $PODCAST_BITRATE $PROCESSED_FILE_NAME $FINAL_AUDIO_FILE_NAME

sudo rm -rf $PROCESSED_FILE_NAME

echo "********************************************************************************"
echo "Final Video output: $FINAL_VIDEO_FILE_NAME"
echo "Final Audio output: $FINAL_AUDIO_FILE_NAME"
echo "********************************************************************************"
