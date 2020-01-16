#!/bin/bash

# ２重起動防止
#if [ $(pgrep startx) ] ; then
#  exit 0
#fi

#export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games

cd /home/pi/git/RasPiMusicBox4/

sudo rm -f /var/lib/tomcat8/webapps/ROOT/start

#sudo ifdown wlan0 --force
#sudo ifup wlan0
#sudo ifdown eth0 --force
#sudo ifup eth0

#xdotool mousemove 200 200

sudo ./volume.sh 100

for f in `seq 2 -1 1`
do
  ip2=`hostname -I | awk '{print $1}'`
  if [[ "${ip2}" == 192* ]]; then
    echo "${ip2}"
    break
  fi
  echo "Waiting - network interface might be down..."
  sleep 1
done

#ip2=`hostname -I | awk '{print $1}'`

if [[ "${ip2}" == 192* ]]; then
  url="http://${ip2}"
  echo 以下のアドレスに、ブラウザからLAN経由で繋いでください。
  echo
  echo ${url}

  last=$(echo ${url} | sed 's/^.*\.\([^\.]*\)$/\1/')
  
  sudo cp -f ./all.csv /var/lib/tomcat8/webapps/ROOT/

  qrencode -t ansi "${url}"
  #aplay -D pluhw:1 /home/pi/git/ready.wav 2>/dev/null
  sudo echo "$last 以下のアドレスに、ブラウザからLAN経由で繋いでください。 ${url}" | sed -e "s/\./ ドット /g" -e "s/http\:\/\// /g" -e "s/\//スラッシュ /g" -e "s/:8080//g" > url.txt
  sudo open_jtalk -x /var/lib/mecab/dic/open-jtalk/naist-jdic -m /usr/share/hts-voice/nitech-jp-atr503-m001/nitech_jp_atr503_m001.htsvoice -r 1.0 -ow url.wav url.txt 

else

  echo ネットワークアドレスを取得できません。
  echo WiFiまたはLANケーブルをご確認ください。
  sudo echo "LANケーブルが接続されていないため、ネットワーク機能は利用できません。" > url.txt
  sudo touch /var/lib/tomcat8/webapps/ROOT/start
  sudo chmod 777 /var/lib/tomcat8/webapps/ROOT/start
  exit 0
  sudo open_jtalk -x /var/lib/mecab/dic/open-jtalk/naist-jdic -m /usr/share/hts-voice/nitech-jp-atr503-m001/nitech_jp_atr503_m001.htsvoice -r 1.0 -ow url.wav url.txt 

fi

aplay url.wav
sudo touch /var/lib/tomcat8/webapps/ROOT/start
sudo chmod 777 /var/lib/tomcat8/webapps/ROOT/start
