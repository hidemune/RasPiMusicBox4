#!/bin/bash

volume=$2
effect=$3

echo Play : 「"$1"」vol: ${volume}

#if [ "$(xdpyinfo 2>/dev/null)" == "" ]; then
#Audio only

  ext4=$(echo $1 | rev | cut -c 1-4 | rev)
  if [ "${ext4}" = ".m4a" ]; then
    yes | ffmpeg -i "$1" /run/tmp.wav
    echo "Upsampling : 192k 24bit"
    AUDIODRIVER=alsa play /run/tmp.wav --replay-gain track -r 192k -b 24 -q --buffer 50000 $effect &
  elif [ "${ext4}" = ".mp4" ]; then
    yes | ffmpeg -i "$1" /run/tmp.wav
    echo "Upsampling : 192k 24bit"
    AUDIODRIVER=alsa play /run/tmp.wav --replay-gain track -r 192k -b 24 -q --buffer 50000 $effect &
  elif [ "${ext4}" = ".m4v" ]; then
    yes | ffmpeg -i "$1" /run/tmp.wav
    echo "Upsampling : 192k 24bit"
    AUDIODRIVER=alsa play /run/tmp.wav --replay-gain track -r 192k -b 24 -q --buffer 50000 $effect &
  elif [ "${ext4}" = ".wav" ]; then
#    touch /run/tmp.wav
#    sudo chmod 777 /run/tmp.wav
#    sudo -u pi cp -f "$1" /run/tmp.wav
#    echo "Upsampling : 192k 24bit"
#    AUDIODRIVER=alsa play /run/tmp.wav --replay-gain track -r 192k -b 24 -q --buffer 50000 $effect &
    echo "Upsampling : 192k 24bit"
    AUDIODRIVER=alsa play "$f" --replay-gain track -r 192k -b 24 -q --buffer 50000 $effect &
  elif [ "${ext4}" = ".mp3" ]; then
    rate=`file "$1" | sed 's/.*, \(.*\)kHz.*/\1/' | tr -d " " `
    rate2=$(echo "$rate * 1000" | bc | sed s/\.[0-9,]*$//g) 
    echo Rate : $rate2
    #if [ $rate2 -lt 50000 ]; then
      echo "re-sampling : 192k 24bit"
      AUDIODRIVER=alsa play "$1" --replay-gain track -r 192k -b 24 -q --buffer 50000 $effect &
    #else
    #  AUDIODRIVER=alsa play "$1" -q --buffer 70000 $effect &
    #fi
  elif [ "${ext4}" = "flac" ]; then
    rate=0$(metaflac --show-sample-rate "$1" 2>/dev/null)
    echo Rate : $rate
    if [ $rate -lt 50000 ]; then
      echo "re-sampling : 192k 24bit"
      AUDIODRIVER=alsa play "$1" --replay-gain track -r 192k -b 24 -q --buffer 50000 $effect &
    else
      AUDIODRIVER=alsa play "$1" --replay-gain track -q --buffer 70000 $effect &
    fi
  fi
  
#else
#Video mode

#  sudo -u pi cvlc --play-and-exit "$1" &
#fi

echo Player started.
