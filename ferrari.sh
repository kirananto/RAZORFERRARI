 #
 # Copyright © 2014, KiranAnto
 #
 # Custom build script
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # Please maintain this if you use this script or any part of it
 #
KERNEL_DIR=$PWD
KERN_IMG=$KERNEL_DIR/arch/arm64/boot/Image
DTBTOOL=$KERNEL_DIR/tools/dtbToolCM
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
# Modify the following variable if you want to build
export CROSS_COMPILE="/home/kiran/android/toolchains/aarch64-linux-android-4.9-LTS/bin/aarch64-linux-android-"
export USE_CCACHE=1
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="Kiran.Anto"
export KBUILD_BUILD_HOST="RaZor-Machine"
STRIP="/home/kiran/android/toolchains/aarch64-linux-android-4.9-LTS/bin/aarch64-linux-android-strip"
MODULES_DIR=$KERNEL_DIR/../RaZORBUILDOUTPUT/Common

compile_kernel ()
{
echo -e "**********************************************************************************************"
echo "                    "
echo "                                        Compiling RaZorReborn kernel                    "
echo "                    "
echo -e "**********************************************************************************************"
make ferrari_razor_defconfig
make -j4
if ! [ -a $KERN_IMG ];
then
echo -e "$red Kernel Compilation failed! Fix the errors! $nocol"
exit 1
fi
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
}
case $1 in
clean)
make ARCH=arm64 -j8 clean mrproper
rm -rf $KERNEL_DIR/arch/arm/boot/dt.img
;;
*)
compile_kernel
;;
esac
rm $MODULES_DIR/../FerrariOutput/tools/Image
rm $MODULES_DIR/../FerrariOutput/tools/dt.img
cp $KERNEL_DIR/arch/arm64/boot/Image  $MODULES_DIR/../FerrariOutput/tools
cp $KERNEL_DIR/arch/arm64/boot/dt.img  $MODULES_DIR/../FerrariOutput/tools
cd /home/kiran/Downloads/RaZoRReborn/RaZORBUILDOUTPUT/FerrariOutput
echo -n "Enter The Zip file Name : "
read zipfile
echo $zipfile
zip -r $zipfile tools META-INF -x *kernel/.gitignore*
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
echo "Enjoy RazorKernel for Ferrari"
