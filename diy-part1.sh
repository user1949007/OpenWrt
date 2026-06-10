#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh

echo 'src-git openclash https://github.com/vernesong/OpenClash' >>feeds.conf.default
echo 'src-git lucky https://github.com/gdy666/luci-app-lucky' >>feeds.conf.default
echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main' >> feeds.conf.default
