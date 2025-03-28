#!/bin/bash

echo "###############################################################"
echo "#           欢迎使用作者协议一键安装脚本                     #"
echo "#           脚本支持系统: CentOS                             #"
echo "###############################################################"
echo ""
echo "请选择操作："
echo "1. socks5一键搭建（随机端口密码）"
echo "2. PPTP搭建"
read -p "请输入选项 (1/2): " choice

case $choice in
1)
    echo "正在下载并运行 socks5搭建脚本..."
    BIND_SCRIPT_URL="https://github.com/xiaoyandexiaohao/sk5.sh/blob/main/socks5.sh"
    wget -O socks5.sh $BIND_SCRIPT_URL
    if [[ $? -eq 0 ]]; then
        chmod +x socsk5.sh
        echo "socsk5搭建中，请稍候..."
        ./socks5.sh
        echo "socks5搭建完成！"
    else
        echo "搭建失败，请检查下载链接是否正确！"
    fi
    ;;
2)
    echo "正在安装 sk5..."
    SK5_SCRIPT_URL="https://github.com/xiaoyandexiaohao/sk5.sh/blob/main/pptp.sh"


    echo "下载并运行 PPTP 安装脚本..."
    wget -O pptp.sh $SK5_SCRIPT_URL
    if [[ $? -eq 0 ]]; then
        chmod +x pptp.sh
        echo "运行 pptp.sh 脚本中，请稍候..."
        ./pptp.sh
        echo "pptp 安装脚本已运行完成！"
    else
        echo "下载 pptp.sh 文件失败，请检查下载链接是否正确！"
    fi
    ;;
*)
    echo "无效的选项，请输入 1、2 "
    ;;
esac
