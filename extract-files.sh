#!/bin/sh

VENDOR=moto
DEVICE=shamu

echo "Please wait..."
wget -nc -q https://dl.google.com/dl/android/aosp/shamu-mra58k-factory-5b07088c.tgz
tar zxf shamu-mra58k-factory-5b07088c.tgz
rm shamu-mra58k-factory-5b07088c.tgz
cd shamu-mra58k
unzip image-shamu-mra58k.zip
cd ../
./simg2img shamu-mra58k/system.img system.ext4.img
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
    echo "cp $FILE $BASE/$FILE"
    cp system/$FILE $BASE/$FILE

done

./setup-makefiles.sh

sudo umount system
rm -rf system
rm -rf shamu-mra58k
rm system.ext4.img
