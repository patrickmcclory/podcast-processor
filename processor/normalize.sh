#!/bin/sh

if [ $# -lt 2 ]; then
  echo "Usage: $0 infile outfile"
  echo "       $0 infile outfile noisefile"
  exit 1
fi

SOX_CMD="sox −−show−progress $1 $2"

if [ $# -eq 3 ]; then
  sox "$3" -n noiseprof noise.prof
  SOX_CMD="$SOX_CMD noisered noise.prof 0.21"
fi

SOX_CMD="$SOX_CMD highpass 100"
SOX_CMD="$SOX_CMD norm"
SOX_CMD="$SOX_CMD compand 0.05,0.2 6:-54,-90,-36,-36,-24,-24,0,-12 0 -90 0.1"
SOX_CMD="$SOX_CMD vad -T 0.6 -p 0.2 -t 5"
SOX_CMD="$SOX_CMD fade 0.1"
SOX_CMD="$SOX_CMD reverse"
SOX_CMD="$SOX_CMD vad -T 0.6 -p 0.2 -t 5"
SOX_CMD="$SOX_CMD fade 0.1"
SOX_CMD="$SOX_CMD reverse"
SOX_CMD="$SOX_CMD norm -0.5"

echo "********************************************************************************"
echo "Running command: "
echo "$SOX_CMD"
echo "********************************************************************************"

eval "$SOX_CMD"

#if [ $# -eq 3 ]; then
#  rm -rf noise.prof
#fi
