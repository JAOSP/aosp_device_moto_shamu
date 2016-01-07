#!/bin/sh

VENDOR=moto
DEVICE=shamu

echo "Please wait..."
wget -nc -q https://dl.google.com/dl/android/aosp/shamu-mmb29s-factory-fc7b590e.tgz
tar zxf shamu-mmb29s-factory-fc7b590e.tgz
rm shamu-mmb29s-factory-fc7b590e.tgz
cd shamu-mmb29s
unzip image-shamu-mmb29s.zip
cd ../
./simg2img shamu-mmb29s/system.img system.ext4.img
mkdir system
sudo mount -o loop -t ext4 system.ext4.img system
sudo chmod a+r system/bin/adspd
sudo chmod a+r system/bin/qmuxd

BASE=../../../vendor/$VENDOR/$DEVICE/proprietary
rm -rf $BASE/*

for FILE in `cat proprietary-blobs-jaosp.txt | grep -v ^# | grep -v ^$ | sed -e 's#^/system/##g'| sed -e "s#^-/system/##g"`; do
    DIR=`dirname $FILE`
    if [ ! -d $BASE/$DIR ]; then
        mkdir -p $BASE/$DIR
    fi
    cp system/$FILE $BASE/$FILE

done

./setup-makefiles.sh

sudo umount system
rm -rf system
rm -rf shamu-mmb29s
rm system.ext4.img
