#!/bin/bash

# Download toolchain if it does not exist.
if [ ! -e ./openwrt-sdk ]; then
	wget -O - https://downloads.openwrt.org/releases/21.02.7/targets/ath79/generic/openwrt-sdk-21.02.7-ath79-generic_gcc-8.4.0_musl.Linux-x86_64.tar.xz | tar --xz -xf - &&
	mv ./openwrt-sdk-21.02.7-ath79-generic_gcc-8.4.0_musl.Linux-x86_64 ./openwrt-sdk
fi

BUILD_TOPDIR=$(pwd)
STAGING=${BUILD_TOPDIR}/openwrt-sdk/staging_dir
TOOLCHAIN=${BUILD_TOPDIR}/openwrt-sdk/staging_dir/toolchain-mips_24kc_gcc-8.4.0_musl/bin/mips-openwrt-linux-

boards=( \
	h3c_wap422 \
	kisslink_nb1210 \
	lemon_wr-9341 \
	lemon_wr-9531 \
	letv_lba-047-ch \
)

rm ./bin/u-boot*

for board in ${boards[@]}; do
	make clean
	make ARCH=mips STAGING_DIR=${STAGING} CROSS_COMPILE=${TOOLCHAIN} $board
done

tar -cvaf u-boot-ath79.tar.xz ./bin/u-boot*
