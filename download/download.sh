#!/bin/bash
NAME=x86_64-36.1_r04
rm -rf $NAME
wget https://dl.google.com/android/repository/sys-img/google_apis_playstore/$NAME.zip
unzip -j $NAME "x86_64/system.img"
rm -rf $NAME
echo "Ended......"
