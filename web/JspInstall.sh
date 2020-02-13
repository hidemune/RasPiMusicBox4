#!/bin/bash

sudo mkdir /var/lib/tomcat8/webapps/ROOT/karaoke/
sudo cp *.jsp /var/lib/tomcat8/webapps/ROOT/karaoke/
sudo cp *.js /var/lib/tomcat8/webapps/ROOT/karaoke/
sudo cp *.java /var/lib/tomcat8/webapps/ROOT/karaoke/
sudo cp *.css /var/lib/tomcat8/webapps/ROOT/karaoke/

sudo cp index.html /var/lib/tomcat8/webapps/ROOT/
sudo cp *.png /var/lib/tomcat8/webapps/ROOT/
sudo cp rireki /var/lib/tomcat8/webapps/ROOT/
sudo rm -f /var/lib/tomcat8/webapps/ROOT/que*

sudo echo 90 > /var/lib/tomcat8/webapps/ROOT/volume

sudo chmod 777 /var/lib/tomcat8/webapps/ROOT/rireki
sudo chmod 777 /var/lib/tomcat8/webapps/ROOT/volume
