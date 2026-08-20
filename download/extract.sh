#!/bin/bash

rm -rf ./final_system ./super_extracted ./super.img

IMG_FILE="system.img"
OUTPUT_FILE="super.img"

if [ ! -f "$IMG_FILE" ]; then
    echo "File not found."
    exit 1
fi

SECTOR_SIZE=$(fdisk -l "$IMG_FILE" | grep -i "Sector size" | awk '{print $4}')
SECTOR_SIZE=${SECTOR_SIZE:-512}

P2_INFO=$(fdisk -l "$IMG_FILE" | grep -E "^${IMG_FILE}" | sed -n '2p')

if [ -z "$P2_INFO" ]; then
    echo "Partition 2 not found."
    exit 1
fi

START_SECTOR=$(echo "$P2_INFO" | awk '{print $2}')
END_SECTOR=$(echo "$P2_INFO" | awk '{print $3}')

SECTOR_COUNT=$((END_SECTOR - START_SECTOR + 1))

echo "SECTOR_SIZE: $SECTOR_SIZE BYTE"
echo "START_SECTOR: $START_SECTOR"
echo "END_SECTOR: $END_SECTOR"
echo "SECTOR_COUNT: $SECTOR_COUNT"
echo "OUTPUT_FILE: $OUTPUT_FILE"

dd if="$IMG_FILE" of="$OUTPUT_FILE" bs="$SECTOR_SIZE" skip="$START_SECTOR" count="$SECTOR_COUNT" status=progress

if [ $? -ne 0 ]; then
    exit 1
fi
lpunpack ./super.img ./super_extracted
7z x -o./final_system ./super_extracted/system.img -snld

rm -rf ./super_extracted ./super.img

pushd final_system
find system \( -name 'libndk_translation*' -o -name '*arm*' -o -name 'ndk_translation*' -o -name 'libberberis*' \) ! -name 'libalarm*' | tar -cf ../native-bridge.tar -T -
popd
tar -xvf native-bridge.tar -C ..

#rm -rf ./system.img
#rm -rf ./final_system

echo "Ended..."
