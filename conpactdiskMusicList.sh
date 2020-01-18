#!/bin/bash

#sudo -u pi chromium-browser --user-data-dir=/home/pi http://localhost &

sudo pkill loop.sh
sudo pkill play
sudo umount /home/pi/mount

# ２重起動防止
if [ $(pgrep loop.sh) ] ; then
  exit 0
fi

cd /home/pi/git/RasPiMusicBox4/
./volume.sh 100


sudo rm -f /var/lib/tomcat8/webapps/ROOT/stop
sudo rm -f /var/lib/tomcat8/webapps/ROOT/cancel
sudo rm -f /var/lib/tomcat8/webapps/ROOT/que*


DEVICE=/run/user/1000/gvfs/cdda\:host\=sr0/

sudo -u pi ls ${DEVICE}

if [ $? -gt 0 ] ; then
  MusicDir=/home/pi/Music/
  echo $MusicDir > MusicDir
  echo No Disk...

  exit 0
fi

# USB動作モード


MusicDir=${DEVICE}
echo MusicDir > MusicDir

  # Diff!
  sudo ./makeCSVpi.sh ${DEVICE}
  sudo ./loopPi.sh
