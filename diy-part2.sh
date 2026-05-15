#!/bin/bash

########################################
# 1. 修改默认 IP（10.10.9.1）
########################################
sed -i 's/192.168.1.1/10.10.9.1/g' package/base-files/files/bin/config_generate

########################################
# 2. 修改主机名
########################################
sed -i "s/'OpenWrt'/'P3TERX-Router'/g" package/base-files/files/bin/config_generate

########################################
# 3. 设置默认主题为 Argon
########################################
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

########################################
# 4. 创建 uci-defaults（强烈推荐）
########################################
mkdir -p package/base-files/files/etc/uci-defaults

cat << "EOF" > package/base-files/files/etc/uci-defaults/99_default_config
#!/bin/sh

# ===== LAN IP =====
uci set network.lan.ipaddr='10.10.9.1'
uci commit network

# ===== Hostname =====
uci set system.@system[0].hostname='P3TERX-Router'
uci commit system

# ===== Theme =====
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci

# ===== USB WiFi 基础支持（x86）=====
# 防止首次启动无线被禁用
for dev in $(uci show wireless | grep '=wifi-device' | cut -d= -f1); do
    uci set ${dev}.disabled='0'
done

# 设置默认 SSID / 密码（仅对存在的无线设备生效）
uci set wireless.default_radio0.ssid='OpenWrt'
uci set wireless.default_radio0.key='1234567890'
uci set wireless.default_radio0.encryption='psk2'
uci set wireless.default_radio0.disabled='0'

uci commit wireless

exit 0
EOF

chmod +x package/base-files/files/etc/uci-defaults/99_default_config

########################################
# 5. 确保 USB WiFi 相关包已选中（保险）
########################################
cat << EOF >> .config
CONFIG_PACKAGE_kmod-usb-core=y
CONFIG_PACKAGE_kmod-usb-net=y
CONFIG_PACKAGE_kmod-usb-net-rtl8152=y
CONFIG_PACKAGE_kmod-usb-storage=y
CONFIG_PACKAGE_kmod-ath=y
CONFIG_PACKAGE_kmod-ath9k=y
CONFIG_PACKAGE_kmod-mt76=y
CONFIG_PACKAGE_kmod-mt76-usb=y
CONFIG_PACKAGE_kmod-rtl8192cu=y
CONFIG_PACKAGE_kmod-rtl88x2bu=y
CONFIG_PACKAGE_wireless-regdb=y
CONFIG_PACKAGE_iw=y
CONFIG_PACKAGE_iwinfo=y
CONFIG_PACKAGE_wpa-cli=y
CONFIG_PACKAGE_hostapd-common=y
EOF
