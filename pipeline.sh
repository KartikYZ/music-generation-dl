#!/bin/bash

model_dir=$1
output_name=$2
source=$3

# Downloading the song
rm demucs/original.mp3
yt-dlp --extract-audio --audio-format mp3 -o demucs/"original.mp3" $source

# Separating into individual components
eval "$(conda shell.zsh hook)"
conda activate demucs
python3 separate.py
conda deactivate
# Now the stems should be located in demucs_separated/htdemucs/original/*.mp3

# Check if the model dir is set up correctly 
num_pth_files=$(find "$model_dir" -maxdepth 1 -type f -name "*.pth" | wc -l)

if test "$num_pth_files" -gt 1; then
    echo "More than one .pth file exists in $model_dir"
    exit 1
fi
if ! test -e "$model_dir"/config.json; then
    echo "No config.json files exist in $model_dir"
    exit 1
fi

# Run the vocals through the provided model
conda activate so-vits-svc-fork
rm ./vocals.out.mp3
svc infer -m "$model_dir"/*.pth -c "$model_dir"/config.json demucs_separated/htdemucs/original/vocals.mp3 -o ./vocals.out.mp3
conda deactivate

# Combine new vocals with separated components
demucs_path="demucs_separated/htdemucs/original/"
rm ./final.mp3
# ffmpeg -i vocals.out.mp3 -i $demucs_path/other.mp3 -i $demucs_path/drums.mp3 -i $demucs_path/bass.mp3 -filter_complex "[0:a][1:a][2:a][3:a]amix=inputs=4:duration=longest" final.mp3
# The command below adjust the volume of the vocal track and then combines.
ffmpeg -i vocals.out.mp3 -i $demucs_path/other.mp3 -i $demucs_path/drums.mp3 -i $demucs_path/bass.mp3 -filter_complex "[0:a]volume=1.5[a];[a][1:a][2:a][3:a]amix=inputs=4:duration=longest" Outputs/"$output_name".mp3


# Remove the trash lol
rm so_vits_svc_fork.log
