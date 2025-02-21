#!/bin/bash

# ===================== 用户配置区 =====================
# ▼▼▼ 以下变量必须修改 ▼▼▼
HTTP_PROXY="http://192.168.1.118:7890/"  # 改为你的代理IP和端口
HTTPS_PROXY="http://192.168.1.118:7890/" # 同上
NO_PROXY="localhost,127.0.0.1,.corp.com" # 内网域名白名单
# ▲▲▲ 修改结束 ▲▲▲

# ===================== 执行逻辑 =====================
if [ $# -eq 0 ]; then
    echo "错误：请指定操作模式"
    echo "用法：sudo $0 {set|remove}"
    exit 1
fi

# 创建配置目录
sudo mkdir -p /etc/systemd/system/docker.service.d/

case "$1" in
"set")
    echo "▶ 正在注入代理配置（目标地址：${HTTP_PROXY}）..."

    # 生成代理配置文件
    sudo tee /etc/systemd/system/docker.service.d/proxy.conf >/dev/null <<EOF
[Service]
Environment="HTTP_PROXY=${HTTP_PROXY}"
Environment="HTTPS_PROXY=${HTTPS_PROXY}"
Environment="NO_PROXY=${NO_PROXY}"
EOF

    # 重载服务配置
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    echo "✔ 代理已生效！"
    echo "  验证命令：docker info | grep -i proxy"
    ;;

"remove")
    echo "▶ 正在清除代理配置..."

    sudo rm -f /etc/systemd/system/docker.service.d/proxy.conf
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    echo "✔ 已恢复原始环境"
    ;;

*)
    echo "错误：无效参数，支持 set 或 remove"
    exit 1
    ;;
esac

echo "  注意：若容器网络异常，请尝试重启容器！"
