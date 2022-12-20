#!/bin/sh

# depends on `yt-dlp` and `ffmpeg`
# yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" https://www.youtube.com/watch?v=r6sGWTCMz2k
# ffmpeg -i 'Pure Fourier series animation montage [-qgreAUpPwM].mp4' -vf palettegen palette.png

start_time=04:40
duration=30
palette="/data/projects/mournfully/palette.png" # must be absolute path (not sure why)
filters="fps=24,scale=720:-1:flags=lanczos"

ffmpeg -v warning -ss $start_time -t $duration -i $1 -vf "$filters,palettegen" -y $palette
ffmpeg -v warning -ss $start_time -t $duration -i $1 -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $2

# mv 'Pure Fourier series animation montage [-qgreAUpPwM].mp4' 'source.mp4'
# ./convert-mp4-to-gif.sh source.mp4 fourier-series-compressed.gif
