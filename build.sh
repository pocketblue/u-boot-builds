#!/bin/bash

set -uexo pipefail

CONFIG="$1"
DEVICE_TREE="$2"

cd ..
make $CONFIG
make -j $(nproc) DEVICE_TREE="$DEVICE_TREE"
gzip u-boot-nodtb.bin -c > u-boot-nodtb.bin.gz
cat u-boot-nodtb.bin.gz dts/upstream/src/arm64/$DEVICETREE.dtb > u-boot-dtb
mkbootimg --kernel_offset '0x00008000' --pagesize '4096' --kernel u-boot-dtb -o u-boot.img
mkdir -p builder/output/
cp u-boot.img builder/output/u-boot.img
