#!/bin/bash

#export LOCALVERSION="-R1.6"
export CROSS_COMPILE="path_to_cross_compiler/bin/aarch64-linux-gnu-"
export ARCH="arm64"
export SUBARCH="arm64"

if  [ ! -d ./out ]
then
mkdir out
make O=out clean
make O=out mrproper
fi
make O=out tegra_android_defconfig

if make O=out -j$(nproc); then cd bootimg && ./createboot.sh; fi
