#!/bin/bash
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
# 适用于: ImmortalWrt openwrt-25.12 + kenzok8/small-package
#

# ============================================================
# 0. 清理旧版/冲突包
# ============================================================

# 移除 ImmortalWrt 源码中自带的旧版 OpenClash（避免版本撕裂）
rm -rf feeds/luci/applications/luci-app-openclash

# 强制删除 Rust 包目录（避免编译问题）
rm -rf feeds/packages/lang/rust

# ============================================================
# 1. 独立外部仓库（非 small-package 的独立源）
# ============================================================

# 添加 OpenClash 官方源
git clone --depth=1 -b master https://github.com/vernesong/OpenClash.git package/luci-app-openclash
chmod -R 755 package/luci-app-openclash

# ============================================================
# 2. 拉取 kenzok8/small-package 到临时目录
# ============================================================

mkdir -p package/small-package-tmp
git clone --depth=1 https://github.com/kenzok8/small-package.git package/small-package-tmp

# ============================================================
# 3. 从 small-package 复制所有非冲突软件包
#
# 排除规则：以下包在 ImmortalWrt 25.12 官方 feed 中已存在，
# 使用官方版本更稳定，因此跳过：
#   adguardhome, luci-app-adguardhome, smartdns, luci-app-smartdns,
#   docker, dockerd, luci-app-dockerman, cgroupfs-mount,
#   dnsmasq, firewall, firewall4, base-files, libnftnl,
#   aria2, luci-app-aria2, haproxy, frp, chinadns-ng, dnsproxy,
#   btop, amule, cups, luci-app-cupsd, ddns-scripts, coremark,
#   fullconenat, fullconenat-nft, python3, php8,
#   libtorrent-rasterbar, lua-maxminddb, jpcre2, xray-core,
#   zerotier, luci-app-zerotier, luci-app-aria2, luci-app-autoreboot
# ============================================================

# ---------- 代理/科学上网 ----------
for pkg in \
    mihomo luci-app-mihomo \
    sing-box luci-app-sing-box \
    luci-app-passwall luci-app-passwall2 \
    luci-app-ssr-plus \
    luci-app-homeproxy \
    luci-app-openclash luci-app-openclash2 \
    luci-app-clash luci-app-clash-meta \
    luci-app-clashoo \
    luci-app-fchomo \
    luci-app-bypass \
    luci-app-nikki nikki \
    hysteria \
    dae daed luci-app-dae luci-app-daed luci-app-daede \
    mosdns luci-app-mosdns \
    brook trojan trojan-go \
    clashoo \
    naiveproxy \
    v2ray-geodata \
    shadowsocks-rust \
    luci-app-netwizard \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ---------- DNS 相关 ----------
for pkg in \
    dns2socks dns2socks-rust dns2tcp \
    dnsforwarder \
    luci-app-dnsfilter \
    luci-app-dnscrypt-proxy2 \
    luci-app-dnsmasq-ipset \
    luci-app-dnsproxy \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ---------- 内网穿透/组网/远程 ----------
for pkg in \
    easytier luci-app-easytier \
    ddnsto luci-app-ddnsto \
    ddns-go luci-app-ddns-go \
    headscale luci-app-headscale \
    lucky luci-app-lucky \
    linkease linkeasefull linkease-common-bin luci-app-linkease \
    istoreenhance luci-app-istoreenhance \
    tailscale luci-app-tailscale \
    frp \
    nps luci-app-nps \
    vnt-cli vnt-server luci-app-vnt \
    softethervpn5 luci-app-softethervpn \
    openvpn-server luci-app-openvpn-server \
    tinc luci-app-tinc \
    ipsec-vpn \
    ocserv luci-app-ocserv \
    ocserv-status \
    n2n luci-app-n2n \
    wgn \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ---------- 网盘/NAS/文件服务 ----------
for pkg in \
    alist luci-app-alist \
    baidudrive luci-app-baidudrive \
    baidusdk \
    cloudreve luci-app-cloudreve \
    clouddrive2 luci-app-clouddrive2 \
    chinesesubfinder luci-app-chinesesubfinder \
    filebrowser luci-app-filebrowser luci-app-filebrowser-go \
    gogs luci-app-gogs \
    gowebdav luci-app-gowebdav \
    webd luci-app-webd \
    rclone-ng \
    thunder luci-app-thunder \
    xunlei \
    nextcloud \
    kodexplorer luci-app-kodexplorer \
    verysync luci-app-verysync \
    syncthing \
    quickfile luci-app-quickfile \
    openlist2 luci-app-openlist2 \
    jdc \
    baidupcs-web luci-app-baidupcs-web \
    nut luci-app-nut \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ---------- 下载/BT ----------
for pkg in \
    qbittorrent luci-app-qbittorrent \
    transmission-web-control luci-app-transmission \
    aria2-web luci-app-ariang \
    microsocks \
    ariang \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ---------- Docker 管理增强 ----------
for pkg in \
    dockermanager luci-app-dockermanager \
    docker-lan-bridge \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ---------- 媒体服务器 ----------
for pkg in \
    emby luci-app-emby \
    jellyfin-server luci-app-jellyfin \
    plex luci-app-plex \
    minidlna \
    airconnect luci-app-airconnect \
    alac \
    gmediarender \
    music-control \
    UnblockNeteaseMusic UnblockNeteaseMusic-Go \
    luci-app-unblockneteasemusic \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ---------- 系统管理/工具 ----------
for pkg in \
    luci-app-store \
    quickstart luci-app-quickstart \
    luci-app-partexp \
    luci-app-fileassistant \
    luci-app-advanced \
    luci-app-autotimeset \
    luci-app-turboacc \
    luci-app-ramfree \
    luci-app-cpufreq \
    luci-app-watchdog \
    luci-app-watchcat \
    luci-app-poweroffdevice \
    luci-app-socat \
    ttyd luci-app-ttyd \
    luci-app-irqbalance \
    luci-app-autoupdate \
    autoupdate \
    luci-app-easyupdate \
    luci-app-netwizard \
    luci-app-demon \
    luci-app-chatgpt-web \
    luci-app-homeassistant \
    luci-app-homebridge \
    luci-app-homebox \
    luci-app-navidrome luci-app-navidproxy \
    luci-app-drawio \
    luci-app-codeserver \
    luci-app-exceldraw \
    luci-app-dpanel \
    luci-app-excalidraw \
    luci-app-ghttpd ghttpd \
    luci-app-taskplan \
    luci-app-control-mweb \
    luci-app-control-timewol \
    luci-app-control-webrestriction \
    luci-app-control-weburl \
    luci-app-sysuh3c \
    luci-app-dogcom \
    luci-app-chongyoung luci-app-chongyoung2.0 \
    MentoHUST-OpenWrt-ipk \
    mentohust luci-app-mentohust \
    luci-app-beardropper \
    luci-app-homeredirect homeredirect \
    luci-app-timecontrol \
    luci-app-pushbot \
    luci-app-wrtbwmon \
    luci-app-bandwidthd \
    luci-app-cloudflarespeedtest \
    cdnspeedtest \
    luci-app-speedtest-web \
    luci-app-usb3disable \
    luci-app-oaf oaf \
    luci-app-openappfilter \
    luci-app-ap-modem \
    luci-app-arcadia \
    luci-app-3ginfo-lite \
    luci-app-fakemesh \
    luci-app-fastnet fastnet \
    luci-app-floatip floatip \
    luci-app-gecoosac \
    luci-app-godproxy \
    luci-app-feishuvpn \
    luci-app-droidmodem \
    lcdsimple \
    luci-app-oled \
    luci-app-homebox \
    luci-app-modem \
    luci-app-nikki \
    luci-app-openvpn-server \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ---------- QoS/流量控制 ----------
for pkg in \
    luci-app-eqosplus \
    luci-app-eqos \
    luci-app-qos-gargoyle \
    luci-app-nft-qos \
    luci-app-qos-plus \
    cpulimit luci-app-cpulimit \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ---------- 广告过滤/去广告 ----------
for pkg in \
    luci-app-koolproxyR \
    luci-app-openclaw \
    luci-app-adbyby-plus \
    luci-app-adguardhome \
    luci-app-dnsfilter \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ---------- 游戏加速 ----------
for pkg in \
    LingTiGameAcc luci-app-LingTiGameAcc lingtigameacc \
    luci-app-UUGameAcc \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ---------- 网络工具 ----------
for pkg in \
    UA2F \
    tun luci-app-tun \
    tproxy luci-app-tproxy \
    redirect luci-app-redirect \
    nmap luci-app-nmap \
    tcpdump-mini \
    ipt2socks \
    gost luci-app-gost \
    haproxy-new luci-app-haproxy-tcp \
    socat luci-app-socat \
    speedtest luci-app-speedtest \
    netspeedtest \
    netsupport luci-app-netsupport \
    netsupportmanager luci-app-netsupportmanager \
    webvirtcloud luci-app-webvirtcloud \
    poe luci-app-poe \
    pppoe-relay luci-app-pppoe-relay \
    pppoe-server luci-app-pppoe-server \
    nft-qos \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ---------- VPN 相关 ----------
for pkg in \
    wireguard luci-app-wireguard \
    ipsec-vpn \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ---------- LuCI 主题 ----------
for pkg in \
    luci-theme-argon luci-app-argon-config \
    luci-theme-design luci-app-design-config \
    luci-theme-alpha luci-app-alpha-config \
    luci-theme-atmaterial_new \
    luci-theme-kucat luci-app-kucat-config \
    luci-theme-tomato \
    luci-theme-opentomcat \
    luci-theme-ifit \
    luci-theme-glass \
    luci-theme-material3 \
    luci-theme-argone luci-app-argone-config \
    luci-theme-darkmatter \
    luci-theme-neobird \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ---------- 网络代理工具 ----------
for pkg in \
    natmap luci-app-natmap \
    onedrive luci-app-onedrive \
    rclone luci-app-rclone \
    telegrambot luci-app-telegrambot \
    webvirtcloud luci-app-webvirtcloud \
    honk \
    rustdesk-server luci-app-rustdesk \
    swap-zram \
    luci-app-swap-zram \
    vlmcsd luci-app-vlmcsd \
    kms luci-app-kms \
    luci-app-jd-dailybonus \
    luci-app-serverchan \
    luci-app-smstool \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ---------- 依赖库（排除官方已有的） ----------
for pkg in \
    libdouble-conversion \
    libcron \
    lua-ipops lua-neturl \
    luci-lib-taskd \
    luci-lib-xterm \
    taskd \
    gn \
    geoview \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ---------- iStore 生态 ----------
for pkg in \
    quickfile luci-app-quickfile \
    quickstart luci-app-quickstart \
    istoreenhance luci-app-istoreenhance \
    istorex luci-app-istorex \
    ophub luci-app-ophub \
    openlist2 luci-app-openlist2 \
    agentflow luci-app-agentflow \
    kai kai_session kaiplus luci-app-kaiplus \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ---------- EasyMesh 相关 ----------
for pkg in \
    luci-app-easymesh \
    luci-app-mesh \
    luci-app-fakemesh \
; do
    [ -d "package/small-package-tmp/$pkg" ] && cp -rf "package/small-package-tmp/$pkg" "package/$pkg"
done

# ============================================================
# 4. 清理临时目录
# ============================================================
rm -rf package/small-package-tmp

# ============================================================
# 5. 修正权限
# ============================================================
chmod -R 755 package/*

echo "✓ diy-part1.sh: small-package 非冲突软件包已全部导入"
