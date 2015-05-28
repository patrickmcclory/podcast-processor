#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 infile "
  echo "       $0 infile noisefile"
  exit 1
fi

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

INPUT_FILE=$MEDIA_DIR/$MEDIA_SOURCE
NOISE_FILE=$MEDIA_DIR/$NOISE_PROFILE_FILE


FILE_PATH="/media"

AUDIO_FILE_NAME=$FILE_PATH/raw_audio-$TIMESTAMP.mp3
PROCESSED_FILE_NAME=$FILE_PATH/processed_audio-$TIMESTAMP.mp3

FINAL_VIDEO_FILE_NAME=$FILE_PATH/final_video-$TIMESTAMP.mp4
FINAL_AUDIO_FILE_NAME=$FILE_PATH/final_audio-$TIMESTAMP.mp3

# strip audio

ffmpeg_cmd="ffmpeg -i $INPUT_FILE -b:a ""$AUDIO_RIP_BITRATE""K -vn $AUDIO_FILE_NAME"

echo "********************************************************************************"
echo "Running ffmpeg audio strip Command: "
echo "$ffmpeg_cmd"
echo "********************************************************************************"


normalize_cmd="normalize $AUDIO_FILE_NAME $PROCESSED_FILE_NAME"

if [ "$NOISE_PROFILE_FILE" -eq "" ]; then
normalize_cmd="$normalize_cmd $NOISE_FILE"
fi

echo "********************************************************************************"
echo "Running Normalize Command: "
echo "$normalize_cmd"
echo "********************************************************************************"

eval $normalize_cmd

sudo rm -rf $AUDIO_FILE_NAME

ffmpeg_recombine="ffmpeg -i $INPUT_FILE -i $PROCESSED_FILE_NAME -map 0 -map 1 -codec copy -shortest $FINAL_VIDEO_FILE_NAME"

echo "********************************************************************************"
echo "Running ffmpeg recombine Command: "
echo "$ffmpeg_recombine"
echo "********************************************************************************"

eval $ffmpeg_recombine

lame_cmd="lame -q -b$PODCAST_BITRATE $PROCESSED_FILE_NAME $FINAL_AUDIO_FILE_NAME"

echo "********************************************************************************"
echo "Running lame Command: "
echo "$lame_cmd"
echo "********************************************************************************"

eval $lame_cmd

sudo rm -rf $PROCESSED_FILE_NAME

echo "********************************************************************************"
echo "Final Video output: $FINAL_VIDEO_FILE_NAME"
echo "Final Audio output: $FINAL_AUDIO_FILE_NAME"
echo "********************************************************************************"
