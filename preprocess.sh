#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 directory"
  exit 1
fi

if [ ! -d "$1" ]; then
  echo "Error: $1 is not a directory"
  exit 1
fi

mkdir -p "$1/wavs"

for file in "$1"/*.mp4; do
  filename="${file%.*}"
  ffmpeg -i "$file" -vn -ac 2 "$1/wavs/${filename##*/}.wav"
done

mkdir -p "$1/dataset_raw"

for file in "$1/wavs"/*.wav; do
  filename="${file%.*}"
  ffmpeg -i "$file" -f segment -segment_time 10 -c copy "$1/final_dataset/${filename##*/}_segment_%02d.wav"
done

echo "Done"
