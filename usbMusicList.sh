#!/bin/bash

sudo -u pi chromium-browser http://localhost &

# ２重起動防止
if [ $(pgrep loop.sh) ] ; then
  exit 0
fi

cd /home/pi/git/RasPiMusicBox4/
./volume.sh 100



echo "準備を開始します。" > talk.txt
open_jtalk -x /var/lib/mecab/dic/open-jtalk/naist-jdic -m /usr/share/hts-voice/nitech-jp-atr503-m001/nitech_jp_atr503_m001.htsvoice -r 1.0 -ow talk.wav talk.txt
aplay talk.wav

sudo rm -f /var/lib/tomcat8/webapps/ROOT/stop
sudo rm -f /var/lib/tomcat8/webapps/ROOT/cancel
sudo rm -f /var/lib/tomcat8/webapps/ROOT/que*


DEVICE=sda1

sudo umount /dev/${DEVICE} 
sudo mount -o iocharset=utf8 /dev/${DEVICE} /home/pi/mount/ || sudo mount /dev/${DEVICE} /home/pi/mount/

if [ $? -gt 0 ] ; then
  MusicDir=/home/pi/Music/
  echo $MusicDir > MusicDir
  echo No USB...
  echo ${MusicDir}
  find ${MusicDir} -type f -not -path "*/playerSetting/*" | sort > work.txt

  if diff -q work.txt bkup.txt >/dev/null ; then
    sudo ./loop.sh
  else
    # Diff!
    sudo cp -f work.txt bkup.txt
    sudo ./makeCSV.sh ${MusicDir}
    sudo ./loop.sh
  fi

  sudo ./loop.sh
  exit 0
fi

# USB動作モード

lsblk -n -o NAME,MOUNTPOINT

sudo mkdir $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/
sudo cp -f $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/bkup.txt ./bkup.txt
sudo cp -f $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/*.csv ./

MusicDir=$(lsblk -n -o MOUNTPOINT /dev/${DEVICE})
echo MusicDir > MusicDir
find $(lsblk -n -o MOUNTPOINT /dev/${DEVICE}) -type f -not -path "*/playerSetting/*" | sort > work.txt

if diff -q work.txt bkup.txt >/dev/null ; then
  # Same !!!
  sudo ./loop.sh
  sudo umount $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})
else
  # Diff!
  sudo cp -f work.txt bkup.txt
  sudo cp -f bkup.txt $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/bkup.txt
  sudo ./makeCSV.sh $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})
  sudo cp -f *.csv $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/
  sync
  sudo ./loop.sh
  sudo umount $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})
fi