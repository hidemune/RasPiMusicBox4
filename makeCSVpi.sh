#!/bin/bash

if [ "$1" == "" ] ; then
  musicpath=/home/pi/Music/
else
  musicpath=$1
fi

i=0

sudo rm -f all.csv
IFS='
'
for f in $(sudo -u pi find ${musicpath} -type f -not -path "*/playerSetting/*"); do
  fname="$f"
  ext4=$(echo ${f} | rev 2>/dev/null | cut -c 1-4 | rev 2>/dev/null)
    base=$(basename "$f")
    vol=80
    vstr=$(echo ${f%.*} | rev 2>/dev/null | cut -c 1-5 | rev 2>/dev/null)
    if [[ ${vstr} =~ ^.*\(([0-9]+)\)$ ]]; then
      vol=${BASH_REMATCH[1]}
    fi
    text=`sudo -u pi ffprobe "$f" 2>&1`
    echo "$text"
    tracknumber="000000"$(echo "$f" | awk '{ sub("[^.]*Track ",""); print $0; }')
    num=$(echo ${tracknumber} | rev | cut -c 5-6 | rev)

    artist=$(echo "$text" | grep -m 1 -i " ARTIST " | grep " : " | awk '{ sub("[^.]* : ",""); print $0; }')
    album=$(echo "$text" | grep -m 1 -i " ALBUM " | grep " : " | awk '{ sub("[^.]* : ",""); print $0; }')
    title=$(echo "$text" | grep -m 1 -i " TITLE " | grep " : " | awk '{ sub("[^.]* : ",""); print $0; }')
  
  echo $artist / $album / $title
  if [ "${artist}" == "" ]; then
    artist="-"
  fi
  if [ "${album}" == "" ]; then
    album="-"
  fi
  if [ "${title}" == "" ]; then
    title="$f"
  fi

  sortkey="${num}====="

  echo -e "${sortkey}${fname}\t${artist}\t${album}\t${title}\t${vol}" >> all.csv
  i=$(echo $i+1 | bc)
  if [ $(( $i % 25 )) -eq 0 ]; then
    aplay decision3.wav &
  fi
done

sort all.csv > all_dayly.csv
rm -f all.csv
while read p; do
  echo $(echo "$p" | awk '{ sub("[^.]*=====",""); print $0; }') >> all.csv
done <all_dayly.csv

cp -f all.csv all_dayly.csv
cp -f all.csv all_nightly.csv
sync
