#!/bin/bash

rm -f /var/lib/tomcat8/webapps/ROOT/start

sudo cp *.csv /var/lib/tomcat8/webapps/ROOT/
sudo chmod 777 /var/lib/tomcat8/webapps/ROOT/*.csv

#unclutter -idle 0.5 -root -visible &

./getIpAddress.sh

while true :
do
  if [ -e /var/lib/tomcat8/webapps/ROOT/start ] ; then
    break
  fi
  sleep 1
done

mode=0
volume=90
./volume.sh 90

jstest /dev/input/js0 > /run/js0.txt &

while true :
do

  # CANCEL !
  if [ -f /var/lib/tomcat8/webapps/ROOT/cancel ] ; then
    sudo rm -f /var/lib/tomcat8/webapps/ROOT/cancel
    #trap 'wait $PID' EXIT
    echo CANCEL !!
    sudo killall play
    sudo kill -9 `pgrep vlc`
  fi
  # Volume set
  if [ -f /var/lib/tomcat8/webapps/ROOT/volume ] ; then
    vol=`cat /var/lib/tomcat8/webapps/ROOT/volume`
    #echo VOLUME : ${vol}
    ./volume.sh ${vol}
  fi
  # STOP !
  if [ -f /var/lib/tomcat8/webapps/ROOT/stop ] ; then
    #trap 'wait $PID' EXIT
    sudo rm -f /var/lib/tomcat8/webapps/ROOT/stop
    echo STOP !!!
    sudo killall play
    sudo kill -9 `pgrep vlc`
    exit 0
  fi
  
  # QUE(Yoyaku) !
  lslst=(`ls /var/lib/tomcat8/webapps/ROOT/que* 2>/dev/null`)
  if [ ${#lslst[*]} -gt 0 ] ; then
    # QUE
    if [ $mode -le 1 ]; then
      mode=2 #QUE:2
      if [[ $(pgrep play || pgrep vlc) ]]; then
        echo Next Queue !
        sudo killall play
        sudo kill -9 `pgrep vlc`
        # Play Queue !
        qfiles=(`ls /var/lib/tomcat8/webapps/ROOT/que* -1 2>/dev/null`)
        if [ "`sed -n 4P ${qfiles[0]}`" == "" ]; then
          sudo echo "`sed -n 1P ${qfiles[0]}`" > /var/lib/tomcat8/webapps/ROOT/nowplay
        else
          sudo echo `sed -n 4P ${qfiles[0]}` > /var/lib/tomcat8/webapps/ROOT/nowplay
        fi
        ./PlMusicHireso.sh "`sed -n 1P ${qfiles[0]}`" "`sed -n 2P ${qfiles[0]}`" "`sed -n 3P ${qfiles[0]}`"
        mv -f ${qfiles[0]} /var/lib/tomcat8/webapps/ROOT/playque
      fi
    else
      mode=2 #QUE:2
      if [[ $(pgrep play || pgrep vlc) ]]; then
        :
      else
        # Play Queue !
        qfiles=(`ls /var/lib/tomcat8/webapps/ROOT/que* -1 2>/dev/null`)
        if [ "`sed -n 4P ${qfiles[0]}`" == "" ]; then
          sudo echo "`sed -n 1P ${qfiles[0]}`" > /var/lib/tomcat8/webapps/ROOT/nowplay
        else
          sudo echo `sed -n 4P ${qfiles[0]}` > /var/lib/tomcat8/webapps/ROOT/nowplay
        fi
        ./PlMusicHireso.sh "`sed -n 1P ${qfiles[0]}`" "`sed -n 2P ${qfiles[0]}`" "`sed -n 3P ${qfiles[0]}`"
        mv -f ${qfiles[0]} /var/lib/tomcat8/webapps/ROOT/playque
      fi
    fi
  elif [ -e /dev/input/js0 ] ; then
    mode=1 #RANDOM:1
  # Joypad : Next mode
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
      echo `echo "$(cat ./preNum) + $(cat all.csv | wc -l) - 2" | bc` > preNum
      sudo killall play
      sudo kill -9 `pgrep vlc`
    elif [ "$(echo $inp | grep ' 0:on')" != "" ];then
      echo Random !
      sudo killall play
      sudo kill -9 `pgrep vlc`
      echo Random Shell !
      ./random.sh
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
      rm -f /var/lib/tomcat8/webapps/ROOT/playque
      echo Next Shell !
      ./next.sh
    fi

  else
  # No Joydad : Random mode
    mode=1 #RANDOM:1
    if [[ $(pgrep play || pgrep vlc) ]]; then
      :
    else
      rm -f /var/lib/tomcat8/webapps/ROOT/playque
      echo Random Shell !
      ./random.sh
    fi
  fi

  if [ -e /var/lib/tomcat8/webapps/ROOT/playque ]; then
    mode=2
  fi
  
  #echo Sleep-B
  sleep 1s
done
