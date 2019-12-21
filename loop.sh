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
  # CANCEL !
  if [ -f /var/lib/tomcat8/webapps/ROOT/cancel ] ; then
    rm /var/lib/tomcat8/webapps/ROOT/cancel
    #trap 'wait $PID' EXIT
    echo CANCEL !!
    sudo killall play
    sudo kill -9 `pgrep vlc`
    break
  fi
  # Volume set
  if [ -f /var/lib/tomcat8/webapps/ROOT/volume ] ; then
    vol=`cat /var/lib/tomcat8/webapps/ROOT/volume`
    #echo VOLUME : ${vol}
    ./volume.sh ${vol}
  fi

  #echo Sleep-B
  sleep 1
done