#!/bin/bash

#unclutter -idle 0.5 -root -visible &

volume=90
./volume.sh 90

jstest /dev/input/js0 > /run/js0.txt &

while true :
do
  # to RANDOM
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
      ./volume.sh ${vol}
    elif [ "$(echo $inp | grep ' 1:-32767')" != "" ];then
      #Volume up
      volume=$(echo "$volume + 5" | bc)
      if [ $volume -gt 100 ]; then
        volume=100
      fi
      ./volume.sh ${vol}
    fi
    mode=1 #RANDOM:1
    if [[ $(pgrep play || pgrep vlc) ]]; then
      :
    else
      echo Next Shell !
      ./next.sh
    fi
  else
    mode=1 #RANDOM:1
    if [[ $(pgrep play || pgrep vlc) ]]; then
      :
    else
      echo Random Shell !
      ./random.sh
    fi
  fi
  
  # STOP !
  if [ -f /var/lib/tomcat8/webapps/ROOT/stop ] ; then
    #trap 'wait $PID' EXIT
    echo STOP !!!
    sudo killall play
    sudo kill -9 `pgrep vlc`
    exit 0
  fi

  #echo Sleep-B
  sleep 1
done