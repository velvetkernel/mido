#!/bin/sh

CCACHE=$(command -v ccache)

TOOLCHAIN=/home/adesh/Adesh/kernel/gcc-prebuilts/bin/aarch64-linaro-linux-android-

export CROSS_COMPILE="${CCACHE} ${TOOLCHAIN}"

export ARCH=arm64

make clean O=out/
make mrproper O=out/

make mido_defconfig O=out/

make -j8 O=out/
