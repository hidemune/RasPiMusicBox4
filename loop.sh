#!/bin/bash

#unclutter -idle 0.5 -root -visible &

volume=80
./volume.sh 80

while true :
do
  # to RANDOM
  if [ -f /dev/input/js0 ] ; then
    :
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