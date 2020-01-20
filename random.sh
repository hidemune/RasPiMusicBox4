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

rnd=$(echo $RANDOM*32768+$RANDOM | bc)

for i in {1..32}; do
  nextNum=$(($rnd % $num_images))
  if [ "${preNum}" != "${nextNum}" ] ; then
    preNum=${nextNum}
    echo $preNum > preNum
    break
  fi
done

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
