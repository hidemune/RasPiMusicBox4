#!/bin/bash

#echo Volume : $1
sudo echo $1 > /var/lib/tomcat8/webapps/ROOT/volume

#amixer sset 'Digital' $(echo "(50 + 0$1) /180*255" | bc -l) > /dev/null 2>&1 
#amixer set 'Master' $1% > /dev/null 2>&1 
amixer -c 0 set 'PCM' $(echo $1*0.9 | bc )% > /dev/null 2>&1 
#pactl set-sink-volume 0 $1% > /dev/null 2>&1 
