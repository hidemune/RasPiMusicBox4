#!/bin/bash
files='./all.csv'

IFS='
' images=(`cat $files`)

preNum=$(cat ./preNum)

num_images=${#images[*]}
echo MAX : $num_images
if [ "${preNum}" == "" ] ; then
  preNum=-1
fi

rnd=$(echo "$preNum + 1" | bc)

nextNum=$(($rnd % $num_images))

preNum=${nextNum}
echo $preNum > preNum
sync

echo $nextNum
IFS='	' fileNm=(${images[$nextNum]})
echo RandomFileName _ "${fileNm[0]}"

if [ "${fileNm[3]}" == "" ]; then
  echo ${fileNm[0]} > /var/lib/tomcat8/webapps/ROOT/nowplay
else
  echo ${fileNm[3]} > /var/lib/tomcat8/webapps/ROOT/nowplay
  echo ${fileNm[1]} >> /var/lib/tomcat8/webapps/ROOT/nowplay
fi

vol="${fileNm[4]}"
./PlMusicHireso.sh "${fileNm[0]}" ${vol}
