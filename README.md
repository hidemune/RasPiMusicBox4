# RasPiMusicBox4
Music Box for RasPi4

# Setup

```
cd ~
mkdir mount
mkdir git

cd git/
git clone https://github.com/hidemune/RasPiMusicBox4.git
cd RasPiMusicBox4/

sudo apt-get -y install thunar smbclient
sudo apt-get -y install unclutter xautomation
sudo apt-get install open-jtalk open-jtalk-mecab-naist-jdic hts-voice-nitech-jp-atr503-m001 -y

sudo apt-get install -y bc xdotool 
sudo apt-get install -y flac sox libsox-fmt-all
sudo apt-get install -y ffmpeg
sudo apt-get install -y jstest-gtk
```

# Start

```
sudo /home/pi/git/RasPiMusicBox4/start.sh
```
