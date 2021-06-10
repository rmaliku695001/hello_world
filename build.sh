#!/bin/dash
export CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm # build for armv7 / armhf

echo :: Installing tools...
sudo apt-get -qq update > /dev/null
sudo apt-get -qq install -y --no-install-recommends -o=Dpkg::Use-Pty=0 git build-essential binutils-multiarch crossbuild-essential-armhf device-tree-compiler fakeroot libncurses5-dev libssl-dev ccache bison flex libelf-dev dwarves python3-pip socat > /dev/null
pip3 install -U --user tuxmake

echo :: Compiling kernel...
tuxmake --directory linux --build-dir=cache/ --target-arch=arm -k qcom_apq8064_defconfig --kconfig-add CONFIG_GENERIC_IRQ_DEBUGFS=y

echo :: Exporting artefacts...
cd /home/runner/.cache/tuxmake/builds/1/
tar -cf linux-${BRANCH}.tar *
cd -
mv /home/runner/.cache/tuxmake/builds/1/linux-${BRANCH}.tar ./
