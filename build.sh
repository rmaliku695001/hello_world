#!/bin/dash
export CROSS_COMPILE=arm-linux-gnueabihf- ARCH=arm # build for armv7 / armhf
export BRANCH=qcom-apq8064-v5.10

echo :: Installing tools...
sudo apt-get -qq install -y --no-install-recommends -o=Dpkg::Use-Pty=0 git build-essential binutils-multiarch crossbuild-essential-armhf device-tree-compiler fakeroot libncurses5-dev libssl-dev ccache bison flex libelf-dev dwarves python3-pip socat > /dev/null
pip3 install -U --user tuxmake

echo :: Cloning git repo...
git clone --quiet --depth=1 --single-branch --branch=$BRANCH https://github.com/okias/linux.git
echo :: Getting kernel config...
curl -S -L -O https://gitlab.com/alpine-mobile/pmaports/-/raw/asus-flo/main/linux-postmarketos-qcom-apq8064/config-postmarketos-qcom-apq8064.armv7


# Example :
#Command : ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- make KERNELRELEASE="5.13-sunxi64" KDEB_PKGVERSION="5.13~rc3+sunxi64-0.1" -j64 bindeb-pkg
#Output : linux-image-$(KERNELRELEASE)_$(KDEB_PKGVERSION)_$(ARCH).deb

echo :: Compiling kernel...
cd linux
tuxmake --target-arch=arm -k ../config-postmarketos-qcom-apq8064.armv7  --kconfig-add CONFIG_MAILBOX=y
cd ..

echo :: Exporting artefacts...
cd /home/runner/.cache/tuxmake/builds/1/
tar -cf linux-${BRANCH}.tar *
cd -
mv /home/runner/.cache/tuxmake/builds/1/linux-${BRANCH}.tar ./
