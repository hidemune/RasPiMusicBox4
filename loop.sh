#!/bin/bash

#unclutter -idle 0.5 -root -visible &

volume=90
./volume.sh 90

jstest /dev/input/js0 > /run/js0.txt &

while true :
do
  # Joypad : Next mode
  if [ -e /dev/input/js0 ] ; then
    #input
    #echo input !
    inp=$(tail -n1 /run/js0.txt)
    echo ... > /run/js0.txt
    if [ "$(echo $inp | grep ' 0: 32767')" != "" ];then
      echo Next !
      sudo killall play
      sudo kill -9 `pgrep vlc`
    elif [ "$(echo $inp | grep ' 0:-32767')" != "" ];then
      echo Prev !
      echo `echo "$(cat ./preNum) - 1" | bc` > preNum
      sudo killall play
      sudo kill -9 `pgrep vlc`
    elif [ "$(echo $inp | grep ' 1: 32767')" != "" ];then
      #Volume down
      volume=$(echo "$volume - 5" | bc)
      if [ $volume -lt 50 ]; then
        volume=50
      fi
      ./volume.sh ${volume}
    elif [ "$(echo $inp | grep ' 1:-32767')" != "" ];then
      #Volume up
      volume=$(echo "$volume + 5" | bc)
      if [ $volume -gt 100 ]; then
        volume=100
      fi
      ./volume.sh ${volume}
    fi
    mode=1 #RANDOM:1
    if [[ $(pgrep play || pgrep vlc) ]]; then
      :
    else
      echo Next Shell !
      ./next.sh
    fi
  else
    # No Joydad : Random mode
    mode=1 #RANDOM:1
    if [[ $(pgrep play || pgrep vlc) ]]; then
      :
    else
      echo Random Shell !
      ./random.sh
    fi
  fi

  #echo Sleep-B
  sleep 1
done