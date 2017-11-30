CCACHE=$(command -v ccache)

TOOLCHAIN=/home/adesh/Adesh/kernel/gcc-linaro-4.9.4-2017.01-i686_aarch64-linux-gnu/bin/aarch64-linux-gnu-

export CROSS_COMPILE="${CCACHE} ${TOOLCHAIN}"

export ARCH=arm64

make clean O=out/
make mrproper O=out/

make mido_defconfig O=out/

make -j8 O=out/
