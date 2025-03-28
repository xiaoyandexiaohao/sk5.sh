#!/bin/bash

while true; do
    # 清除屏幕，开始显示菜单
    clear
    echo "###############################################################"
    echo "#           欢迎使用作者-小晏同学----协议一键安装脚本                     #"
    echo "#           脚本支持系统: CentOS                             #"
    echo "###############################################################"
    echo ""
    echo "请选择操作："
    echo "1. socks5一键搭建（随机端口密码）"
    echo "2. PPTP搭建"
    echo "3. 退出脚本"
    read -p "请输入选项 (1/2/3): " choice

    case $choice in
    1)
        # 清屏，进入新的“页面”
        clear
        echo "正在下载并运行 socks5搭建脚本..."
        SOCKS5_SCRIPT_URL="https://raw.githubusercontent.com/xiaoyandexiaohao/sk5.sh/refs/heads/main/socks5.sh"
        wget -O socks5.sh $SOCKS5_SCRIPT_URL
        if [[ $? -eq 0 ]]; then
            chmod +x socks5.sh
            echo "socks5搭建中，请稍候..."
            ./socks5.sh
            echo "socks5搭建完成！"
        else
            echo "下载 socks5.sh 文件失败，请检查下载链接是否正确！"
        fi
        echo ""
        echo "按任意键返回主菜单..."
        read -n 1  # 等待用户输入任意键
        clear  # 清屏，返回主菜单
        ;;
    2)
        # 清屏，进入新的“页面”
        clear
        echo "正在安装 pptp..."
        PPTP_SCRIPT_URL="https://raw.githubusercontent.com/xiaoyandexiaohao/sk5.sh/refs/heads/main/pptp.sh"
        echo "下载并运行 PPTP 安装脚本..."
        wget -O pptp.sh $PPTP_SCRIPT_URL
        if [[ $? -eq 0 ]]; then
            chmod +x pptp.sh
            echo "运行 pptp.sh 脚本中，请稍候..."
            ./pptp.sh
            echo "pptp 安装脚本已运行完成！"
        else
            echo "下载 pptp.sh 文件失败，请检查下载链接是否正确！"
        fi
        echo ""
        echo "按任意键返回主菜单..."
        read -n 1  # 等待用户输入任意键
        clear  # 清屏，返回主菜单
        ;;
    3)
        echo "正在退出脚本..."
        break
        ;;
    *)
        echo "无效的选项，请输入 1、2 或 3"
        ;;
    esac
done
