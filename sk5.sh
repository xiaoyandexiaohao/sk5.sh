#!/bin/bash

# 设置颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # 无颜色

function socks5() {
    # 安装sk5
    wget -O /usr/local/bin/sk5 https://github.com/yanpeng997995/prxoy/raw/main/sk5
    chmod +x /usr/local/bin/sk5
    
    # 判断是否是root用户
    if [ "$(id -u)" != "0" ]; then
        echo -e "${RED}此脚本需要以root用户权限运行。${NC}"
        echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
        exit 1
    fi
    
    # 交互式提示设置端口、用户名和密码
    read -p "请输入端口: " PORT
    read -p "请输入用户名: " USER
    read -p "请输入密码: " PASSWD
    
    # 清空防火墙规则，屏蔽iptables输出
    iptables -P INPUT ACCEPT > /dev/null 2>&1
    iptables -P FORWARD ACCEPT > /dev/null 2>&1
    iptables -P OUTPUT ACCEPT > /dev/null 2>&1
    iptables -t nat -F > /dev/null 2>&1
    iptables -t mangle -F > /dev/null 2>&1
    iptables -F > /dev/null 2>&1
    iptables -X > /dev/null 2>&1
    iptables-save > /dev/null 2>&1
    
    # 获取公网IP
    PUBLIC_IP=$(curl -s https://api.ipify.org)
    
    # sk5 安装
    chmod +x /usr/local/bin/sk5
    cat <<EOF > /etc/systemd/system/sk5.service
[Unit]
Description=The sk5 Proxy Server
After=network-online.target

[Service]
ExecStart=/usr/local/bin/sk5 -c /etc/sk5/serve.toml
ExecStop=/bin/kill -s QUIT \$MAINPID
Restart=always
RestartSec=15s

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable sk5
    
    # sk5 配置
    mkdir -p /etc/sk5
    echo -n "" > /etc/sk5/serve.toml
    
    for ip in "${ips[@]}"; do
        cat <<EOF >> /etc/sk5/serve.toml
[[inbounds]]
listen = "${ip}"
port = ${PORT}
protocol = "socks"
tag = "socks-inbound"

[inbounds.settings]
auth = "password"
udp = true
ip = "${ip}"

[[inbounds.settings.accounts]]
user = "${USER}"
pass = "${PASSWD}"

[[routing.rules]]
type = "field"
inboundTag = "socks-inbound"
outboundTag = "freedom-outbound"

[[outbounds]]
sendThrough = "${ip}"
protocol = "freedom"
tag = "freedom-outbound"
EOF
    done
    
    systemctl stop sk5
    systemctl start sk5
    
    # 仅显示公网IP, 端口, 用户名, 密码
    clear  # 清空当前页面
    echo -e "${GREEN}代理服务器搭建完成！${NC}"
    echo -e "${BLUE}公网IP: ${PUBLIC_IP}${NC}"
    echo -e "${BLUE}端口: ${PORT}${NC}"
    echo -e "${BLUE}用户名: ${USER}${NC}"
    echo -e "${BLUE}密码: ${PASSWD}${NC}"
}

# 主菜单
function main_menu() {
    while true; do
        clear
        echo -e "${YELLOW}脚本由游艇舰队----迫击炮进行编写${NC}"
        echo "=========================基于github仓库修改======================================="
        echo "节点社区:微信             微信联系:17784902889"
        echo "欢迎各位交流，包括低价腾讯云，阿里云，华为云服务器：17784902889"
        echo "退出脚本，请按键盘ctrl c退出即可"
        echo "请选择要执行的操作:"
        echo "1. 安装socks5"
        read -p "请输入选项: " OPTION
        
        case $OPTION in
        1) socks5 ;;
        *) echo -e "${RED}无效选项。${NC}" ;;
        esac
        echo "按任意键返回主菜单..."
        read -n 1
    done
}

# 显示主菜单
main_menu
