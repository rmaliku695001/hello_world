#!/bin/dash
export CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm # build for armv7 / armhf

echo :: Installing tools...
DEPS_FOR_DTB="libyaml-dev"
sudo apt-get -qq install -y --no-install-recommends -o=Dpkg::Use-Pty=0 git build-essential binutils-multiarch crossbuild-essential-armhf device-tree-compiler fakeroot libncurses5-dev libssl-dev ccache bison flex libelf-dev dwarves python3-pip socat ${DEPS_FOR_DTB} > /dev/null
pip3 install -U --user git+https://github.com/devicetree-org/dt-schema.git@master

echo :: Running tests...
cd linux
make defconfig KBUILD_DEFCONFIG=qcom_apq8064_defconfig
status=0
echo :: Building dtb
make -j3 dtbs || status=1
echo :: Running dt_binding_check
make -j3 dt_binding_check dtbs_check || status=1

exit $status

