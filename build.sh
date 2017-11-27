#!/bin/bash
echo "Welcome to Velvet Kernel Builder!"
LC_ALL=C date +%Y-%m-%d
kernel_dir=$PWD
build=$kernel_dir/out
export CROSS_COMPILE="/home/adesh/Adesh/kernel/gcc-prebuilts/bin/aarch64-linaro-linux-android-"
kernel="velvet"
version="r5.2"
vendor="xiaomi"
device="mido-los"
zip=zip
date=`date +"%Y%m%d-%H%M"`
config=mido_defconfig
kerneltype="Image.gz-dtb"
jobcount="-j$(grep -c ^processor /proc/cpuinfo)"
#modules_dir=$kernel_dir/"$zip"/system/lib/modules
modules_dir=$kernel_dir/"$zip"/modules
zip_name="$kernel"-"$version"-"$device".zip
export KBUILD_BUILD_USER=adesh15
export KBUILD_BUILD_HOST=velvet

echo "Checking for build..."
if [ -d arch/arm64/boot/"$kerneltype" ]; then
	read -p "Previous build found, clean working directory..(y/n)? : " cchoice
	case "$cchoice" in
		y|Y )
			rm -rf out
			mkdir out
			rm -rf "$zip"/modules
			mkdir "$zip"/modules
			export ARCH=arm64
			make clean && make mrproper
			echo "Working directory cleaned...";;
		n|N )
			exit 0;;
		* )
			echo "Invalid...";;
	esac
	read -p "Begin build now..(y/n)? : " dchoice
	case "$dchoice" in
		y|Y)
			make "$config"
			make "$jobcount"
			exit 0;;

		n|N )
			exit 0;;
		* )
			echo "Invalid...";;
	esac
fi
echo "Extracting files..."
if [ -f arch/arm64/boot/"$kerneltype" ]; then
	cp arch/arm64/boot/"$kerneltype" "$zip"/"$kerneltype"
#        mkdir -p zip/modules/pronto
#	cp drivers/staging/prima/wlan.ko zip/modules/pronto/pronto_wlan.ko
	find . -name '*.ko' -exec cp {} $modules_dir/ \;
	"$CROSS_COMPILE"strip --strip-unneeded "$zip"/modules/*.ko &> /dev/null
        mkdir -p zip/modules/pronto/
        mv zip/modules/wlan.ko zip/modules/pronto/pronto_wlan.ko
else
	echo "Nothing has been made..."
	read -p "Clean working directory..(y/n)? : " achoice
	case "$achoice" in
		y|Y )
                        rm -rf out
                        mkdir out
                        rm -rf "$zip"/modules
                        mkdir "$zip"/modules
			export ARCH=arm64
                        make clean && make mrproper
                        echo "Working directory cleaned...";;
		n|N )
			exit 0;;
		* )
			echo "Invalid...";;
	esac
	read -p "Begin build now..(y/n)? : " bchoice
	case "$bchoice" in
		y|Y)
			make "$config"
			make "$jobcount"
			exit 0;;
		n|N )
			exit 0;;
		* )
			echo "Invalid...";;
	esac
fi

echo "Zipping..."
if [ -f "$zip"/"$kerneltype" ]; then
	cd "$zip"
	zip -r ../$zip_name .
	mv ../$zip_name $build
	rm "$kerneltype"
	cd ..
	rm -rf arch/arm64/boot/"$kerneltype"
        echo "Generating changelog..."
        git --no-pager log --pretty=oneline --abbrev-commit 5a78b82c579686457ad600ad4bdf3d6abd0311da..HEAD > zip/changelog.txt
        paste zip/changelog.txt
        rm zip/changelog.txt
	export outdir=""$build""
        export out=""$build""
        export OUT=""$build""
	echo "Package complete: "$build"/"$zip_name""
	exit 0;
else
	echo "No $kerneltype found..."
	exit 0;
fi
# Export script by Savoca
# Thank You Savoca!
