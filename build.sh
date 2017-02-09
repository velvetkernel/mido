#!/bin/bash
echo "Welcome to Velvet Kernel Builder!"
LC_ALL=C date +%Y-%m-%d
kernel_dir=$PWD
build=$kernel_dir/out2
version=r7
kernel="velvet"
vendor="xiaomi"
device="mido-oreo"
export CROSS_COMPILE="/home/arn4v/velvet/toolchains/aarch64-linux-android-4.9/bin/aarch64-linux-android-"
zip=zip
date=`date +"%Y%m%d-%H%M"`
config=mido_defconfig
kerneltype="Image.gz-dtb"
jobcount="-j$(grep -c ^processor /proc/cpuinfo)"
#modules_dir=$kernel_dir/"$zip"/system/lib/modules
modules_dir=$kernel_dir/"$zip"/modules
zip_name="$kernel"-"$version"-"$device".zip
export KBUILD_BUILD_USER=arnavgosain
export KBUILD_BUILD_HOST=velvet
#export CCACHE_DIR="/root/.ccache"
#export CXX="ccache g++"
#export CC="ccache gcc"

function clean() {
rm -rf out2; mkdir out2; export ARCH=arm64; make O=out clean && make O=out mrproper
}

function build() {
make O=out "$config"; make O=out "$jobcount"; cp out/arch/arm64/boot/"$kerneltype" "$zip"/"$kerneltype"
}

function cleanbuild() {
clean; build; kzip
}

function kzip() {
cd $kernel_dir/$zip
mkdir treble
mkdir nontreble
cp $kernel_dir/arch/arm64/boot/dts/qcom/msm8953-qrd-sku3-mido-nontreble.dtb $kernel_dir/zip/nontreble/
cp $kernel_dir/arch/arm64/boot/dts/qcom/msm8953-qrd-sku3-mido-treble.dtb $kernel_dir/zip/treble/
zip -r $build/$zip_name .
rm "$kerneltype"
cd ..
export out2dir=""$build""
export out2=""$build""
export out2=""$build""
echo "Package complete: "$build"/"$zip_name""
exit 0;
}

echo $zip_name
echo $kernel_dir

if [[ "$1" =~ "cleanbuild" ]];
then
    cleanbuild
else
    if [[ "$1" =~ "reset" ]];
    then
        git add -A
        git commit -am "lol"
        git fetch origin
        git checkout2 origin/cm-14.1
        git reset --hard
        clean
        build
        kzip
    fi
fi

if [[ "$1" =~ "reset" ]];
then
    git add -A
    git commit -am "lol"
    git fetch origin
    git checkout2 origin/cm-14.1
    git reset --hard
fi

if [ -z $1]; then
cleanbuild
fi
