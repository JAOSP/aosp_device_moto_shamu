#!/bin/bash

VENDOR=lge
DEVICE=hammerhead
OUTDIR=vendor/$VENDOR/$DEVICE
MAKEFILE=../../../$OUTDIR/$DEVICE-vendor-blobs.mk

(cat << EOF) > $MAKEFILE

PRODUCT_COPY_FILES += \\
EOF

LINEEND=" \\"
COUNT=`cat proprietary-blobs.txt | grep -v ^# | grep -v ^$ | wc -l | awk {'print $1'}`
for FILE in `cat proprietary-blobs.txt | grep -v ^# | grep -v ^$ | sed -e 's#^/system/##g'`; do
    COUNT=`expr $COUNT - 1`
    if [ $COUNT = "0" ]; then
        LINEEND=""
    fi
    if [[ ! "$FILE" =~ ^-.* ]]; then
        FILE=`echo $FILE | sed -e "s/^-//g"`
        echo "    $OUTDIR/proprietary/$FILE:system/$FILE:lge$LINEEND" >> $MAKEFILE
    fi
done

(cat << EOF) > ../../../$OUTDIR/$DEVICE-vendor.mk

\$(call inherit-product, vendor/$VENDOR/$DEVICE/$DEVICE-vendor-blobs.mk)
EOF

(cat << EOF) > ../../../$OUTDIR/BoardConfigVendor.mk

USE_CAMERA_STUB := false
EOF

(cat << EOF) > ../../../$OUTDIR/proprietary/Android.mk

LOCAL_PATH := \$(call my-dir)

ifeq (\$(TARGET_DEVICE),hammerhead)

endif
EOF
