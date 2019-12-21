#!/bin/bash

RUNTTY=`/usr/bin/tty | cut -c 6-8`
if [ $RUNTTY = 'tty' ]
then
  jfbterm -e sudo /home/pi/git/RasPiMusicBox4/usbMusicList.sh
else
  sudo /home/pi/git/RasPiMusicBox4/usbMusicList.sh
fi
