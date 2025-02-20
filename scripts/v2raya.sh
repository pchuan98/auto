#!/bin/bash

# Author: pchuan
# Version: 1.0
# Date: February 20, 2025
# Description: 安装v2rayA脚本

# set -exo
set -e

##############################################################

# Don't use anything from fucking Ubuntu Snap
PATH="$(echo "$PATH" | sed 's|:/snap/bin||g')"
export PATH

## Color
if command -v tput >/dev/null 2>&1; then
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    RESET=$(tput sgr0)
fi

## SHA256SUM
if command -v sha256sum >/dev/null 2>&1; then
    SHA256SUM() {
        sha256sum "$1" | awk -F ' ' '{print$1}'
    }
elif command -v shasum >/dev/null 2>&1; then
    SHA256SUM() {
        shasum -a 256 "$1" | awk -F ' ' '{print$1}'
    }
elif command -v openssl >/dev/null 2>&1; then
    SHA256SUM() {
        openssl dgst -sha256 "$1" | awk -F ' ' '{print$2}'
    }
elif command -v busybox >/dev/null 2>&1; then
    SHA256SUM() {
        busybox sha256sum "$1" | awk -F ' ' '{print$1}'
    }
fi

## Check root
if [ "$(id -u)" -ne 0 ]; then
    echo "${RED}Error: This script must be run as root!${RESET}" >&2
    exit 1
fi

# Check curl, unzip
for tool in curl unzip; do
    if ! command -v $tool >/dev/null 2>&1; then
        tool_need="$tool"" ""$tool_need"
    fi
done
if ! command -v sha256sum >/dev/null 2>&1 && ! command -v shasum >/dev/null 2>&1 && ! command -v openssl >/dev/null 2>&1; then
    tool_need="openssl"" ""$tool_need"
fi
if [ -n "$tool_need" ]; then
    if command -v apt >/dev/null 2>&1; then
        command_install_tool="apt update; apt install $tool_need -y"
    elif command -v dnf >/dev/null 2>&1; then
        command_install_tool="dnf install $tool_need -y"
    elif command -v yum >/dev/null 2>&1; then
        command_install_tool="yum install $tool_need -y"
    elif command -v zypper >/dev/null 2>&1; then
        command_install_tool="zypper --non-interactive install $tool_need"
    elif command -v pacman >/dev/null 2>&1; then
        command_install_tool="pacman -Sy $tool_need --noconfirm"
    elif command -v apk >/dev/null 2>&1; then
        command_install_tool="apk add $tool_need"
    else
        echo "$RED""You should install ""$tool_need""then try again.""$RESET"
        exit 1
    fi
    if ! /bin/sh -c "$command_install_tool"; then
        echo "$RED""Use system package manager to install $tool_need failed,""$RESET"
        echo "$RED""You should install ""$tool_need""then try again.""$RESET"
        exit 1
    fi
fi

if [ -n "$tool_need" ]; then
    echo "${GREEN}You have installed the following tools during installation:${RESET}"
    echo "$tool_need"
    echo "${GREEN}You can uninstall them now if you want.${RESET}"
    exit 0
else
    echo "${GREEN}You have installed all the necessary tools.${RESET}"
fi

## Check OS and arch
if [ "$(uname -s)" != "Linux" ]; then
    echo "${RED}Error: This script only support Linux!${RESET}" >&2
    exit 1
fi
case "$(uname -m)" in
x86_64)
    v2ray_arch="64"
    v2raya_arch="x64"
    ;;
armv7l)
    v2ray_arch="arm32-v7a"
    v2raya_arch="armv7"
    ;;
aarch64)
    v2ray_arch="arm64-v8a"
    v2raya_arch="arm64"
    ;;
riscv64)
    v2ray_arch="riscv64"
    v2raya_arch="riscv64"
    ;;
*)
    echo "${RED}Error: This script only support x86_64/armv7l/aarch64/riscv64 at the monment!${RESET}" >&2
    echo "${RED}Error: Please install v2ray and v2rayA manually!${RESET}" >&2
    exit 1
    ;;
esac

echo "${GREEN}Arch: $v2ray_arch${RESET}"

# download or using local file to install v2ray
# v2ray_temp_file="/tmp/v2ray-linux.zip"

# if [ -f "$v2ray_temp_file" ]; then
#     echo "${GREEN}Found v2ray-linux.zip${RESET}"

#     unzip -q "$v2ray_temp_file" -d "$v2ray_temp_file"_unzipped
#     install "$v2ray_temp_file"_unzipped/v2ray /usr/local/bin/v2ray
#     [ -d /usr/local/share/v2ray ] || mkdir -p /usr/local/share/v2ray
#     mv "$v2ray_temp_file"_unzipped/geoip.dat /usr/local/share/v2ray/geoip.dat
#     mv "$v2ray_temp_file"_unzipped/geosite.dat /usr/local/share/v2ray/geosite.dat
#     rm -rf "$v2ray_temp_file" "$v2ray_temp_file"_unzipped "$v2ray_temp_file".dgst
#     echo "${GREEN}v2ray version $v2ray_remote_version installed successfully!${RESET}"
# else
#     if ! curl -s "https://api.github.com/repos/v2fly/v2ray-core/releases/latest" -o "$v2ray_temp_file"; then
#         echo "${RED}Error: Cannot get latest version of v2ray!${RESET}"
#         exit 1
#     fi

#     v2ray_remote_version=$(grep tag_name "$v2ray_temp_file" | awk -F "tag_name" '{printf $2}' | awk -F "," '{printf $1}' | awk -F '"' '{printf $3}')
#     v2ray_url="https://github.com/v2fly/v2ray-core/releases/download/$v2ray_remote_version/v2ray-linux-$v2ray_arch.zip"
#     rm -f "$v2ray_temp_file"

#     echo "${RED}Please download v2ray-linux.zip from $v2ray_url and put it in the same directory as this script.${RESET}"
#     echo "curl -L -o $v2ray_temp_file $v2ray_url"
# fi

# download or using local file to install xray
xray_temp_file="/tmp/xray-linux.zip"

if [ -f "$xray_temp_file" ]; then
    echo "${GREEN}Found xray-linux.zip${RESET}"

    unzip -q "$xray_temp_file" -d "$xray_temp_file"_unzipped
    install "$xray_temp_file"_unzipped/xray /usr/local/bin/xray
    [ -d /usr/local/share/xray ] || mkdir -p /usr/local/share/xray
    mv "$xray_temp_file"_unzipped/geoip.dat /usr/local/share/xray/geoip.dat
    mv "$xray_temp_file"_unzipped/geosite.dat /usr/local/share/xray/geosite.dat
    rm -rf "$xray_temp_file" "$xray_temp_file"_unzipped "$xray_temp_file".dgst
    echo "${GREEN}xray version $xray_remote_version installed successfully!${RESET}"
else
    if ! curl -s "https://api.github.com/repos/XTLS/Xray-core/releases/latest" -o "$xray_temp_file"; then
        echo "${RED}Error: Cannot get latest version of xray!${RESET}"
        exit 1
    fi

    xray_remote_version=$(grep tag_name "$xray_temp_file" | awk -F "tag_name" '{printf $2}' | awk -F "," '{printf $1}' | awk -F '"' '{printf $3}')
    xray_url="https://github.com/XTLS/Xray-core/releases/download/$xray_remote_version/Xray-linux-$v2ray_arch.zip"

    rm -f "$xray_temp_file"

    echo "${RED}Please download xray-linux.zip from $xray_url and put it in the same directory as this script.${RESET}"
    echo "curl -L -o $xray_temp_file $xray_url"
fi

# download or using local file to install v2raya
v2raya_temp_file="/tmp/v2raya-linux.zip"

v2raya_service=$(
    cat <<EOF
[Unit]
Description=A web GUI client of Project V which supports VMess, VLESS, SS, SSR, Trojan, Tuic and Juicity protocols
Documentation=https://v2raya.org
After=network.target nss-lookup.target iptables.service ip6tables.service nftables.service
Wants=network.target

[Service]
Environment="V2RAYA_CONFIG=/usr/local/etc/v2raya"
Environment="V2RAYA_LOG_FILE=/tmp/v2raya.log"
Type=simple
User=root
LimitNPROC=500
LimitNOFILE=1000000
ExecStart=/usr/local/bin/v2raya
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
)

if [ -f "$v2raya_temp_file" ]; then
    echo "${GREEN}Found v2raya-linux.zip${RESET}"

    install "$v2raya_temp_file" /usr/local/bin/v2raya

    echo "$v2raya_service" >"$v2raya_temp_file".service
    install -m 644 "$v2raya_temp_file".service /etc/systemd/system/v2raya.service
    systemctl daemon-reload

    rm -f "$v2raya_temp_file"
    [ -f "$v2raya_temp_file".service ] && rm -f "$v2raya_temp_file".service || [ -f "$v2raya_temp_file"-openrc ] && rm -f "$v2raya_temp_file"-openrc
    echo "${GREEN}v2rayA version $v2raya_remote_version installed successfully!${RESET}"

else
    if ! curl -s "https://api.github.com/repos/v2rayA/v2rayA/releases/latest" -o "$v2raya_temp_file"; then
        echo "${RED}Error: Cannot get latest version of v2raya!${RESET}"
        exit 1
    fi

    v2raya_remote_version=$(grep tag_name "$v2raya_temp_file" | awk -F "tag_name" '{printf $2}' | awk -F "," '{printf $1}' | awk -F '"' '{printf $3}')
    v2raya_short_version=$(echo "$v2raya_remote_version" | cut -d "v" -f2)
    v2raya_url="https://github.com/v2rayA/v2rayA/releases/download/${v2raya_remote_version}/v2raya_linux_${v2raya_arch}_${v2raya_short_version}"

    echo "${GREEN}Downloading v2raya-linux.zip from $v2raya_url${RESET}"
    echo "wget -O $v2raya_temp_file $v2raya_url"

    rm -f "$v2raya_temp_file"
fi
