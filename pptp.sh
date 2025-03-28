#!/bin/bash
#
# 作者:  yeho <lj2007331 AT gmail.com>
# 博客:  https://blog.linuxeye.com
#
# 安装CentOS专用PPTP VPN系统

# 检查是否为root用户
[ $(id -u) != "0" ] && { echo -e "\033[31m错误: 你必须以root用户运行此脚本\033[0m"; exit 1; } 

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
clear
printf "
#######################################################################
#    LNMP/LAMP/LANMP for CentOS/RadHat 5+ Debian 6+ and Ubuntu 12+    #
#            安装CentOS专用PPTP VPN系统                             #
# 更多信息请访问 17784902889                      #
#######################################################################
"

[ ! -e '/usr/bin/curl' ] && yum -y install curl

VPN_IP=`curl ipv4.icanhazip.com`

VPN_USER="linuxeye"
VPN_PASS="linuxeye"

VPN_LOCAL="192.168.0.150"
VPN_REMOTE="192.168.0.151-200"


while :; do echo
    read -p "请输入用户名: " VPN_USER 
    [ -n "$VPN_USER" ] && break
done

while :; do echo
    read -p "请输入密码: " VPN_PASS
    [ -n "$VPN_PASS" ] && break
done
clear


if [ -f /etc/redhat-release -a -n "`grep ' 7\.' /etc/redhat-release`" ];then
    #CentOS_REL=7
    if [ ! -e /etc/yum.repos.d/epel.repo ];then
        cat > /etc/yum.repos.d/epel.repo << EOF
[epel]
name=Extra Packages for Enterprise Linux 7 - \$basearch
#baseurl=http://download.fedoraproject.org/pub/epel/7/\$basearch
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=\$basearch
failovermethod=priority
enabled=1
gpgcheck=0
EOF
    fi
    for Package in wget make openssl gcc-c++ ppp pptpd iptables iptables-services 
    do
        yum -y install $Package
    done
    echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
elif [ -f /etc/redhat-release -a -n "`grep ' 6\.' /etc/redhat-release`" ];then
    #CentOS_REL=6
    for Package in wget make openssl gcc-c++ iptables ppp 
    do
        yum -y install $Package
    done
    sed -i 's@net.ipv4.ip_forward.*@net.ipv4.ip_forward = 1@g' /etc/sysctl.conf
    rpm -Uvh http://poptop.sourceforge.net/yum/stable/rhel6/pptp-release-current.noarch.rpm
    yum -y install pptpd
else
    echo -e "\033[31m不支持此操作系统，请联系作者！\033[0m"
    exit 1
fi

echo "1" > /proc/sys/net/ipv4/ip_forward

sysctl -p /etc/sysctl.conf

[ -z "`grep '^localip' /etc/pptpd.conf`" ] && echo "localip $VPN_LOCAL" >> /etc/pptpd.conf # 设置PPTP服务器的本地IP地址
[ -z "`grep '^remoteip' /etc/pptpd.conf`" ] && echo "remoteip $VPN_REMOTE" >> /etc/pptpd.conf # 设置VPN用户IP范围
[ -z "`grep '^stimeout' /etc/pptpd.conf`" ] && echo "stimeout 172800" >> /etc/pptpd.conf

if [ -z "`grep '^ms-dns' /etc/ppp/options.pptpd`" ];then
     cat >> /etc/ppp/options.pptpd << EOF
ms-dns 223.5.5.5 # 阿里云DNS
ms-dns 114.114.114.114 # 114 DNS
ms-dns 8.8.8.8 # 谷歌DNS
ms-dns 209.244.0.3 # Level3 DNS
ms-dns 208.67.222.222 # OpenDNS
EOF
fi

echo "$VPN_USER pptpd $VPN_PASS *" >> /etc/ppp/chap-secrets

ETH=`route | grep default | awk '{print $NF}'`
[ -z "`grep '1723 -j ACCEPT' /etc/sysconfig/iptables`" ] && iptables -I INPUT 4 -p tcp -m state --state NEW -m tcp --dport 1723 -j ACCEPT
[ -z "`grep 'gre -j ACCEPT' /etc/sysconfig/iptables`" ] && iptables -I INPUT 5 -p gre -j ACCEPT 
iptables -t nat -A POSTROUTING -o $ETH -j MASQUERADE
iptables -I FORWARD -p tcp --syn -i ppp+ -j TCPMSS --set-mss 1356
service iptables save
sed -i 's@^-A INPUT -j REJECT --reject-with icmp-host-prohibited@#-A INPUT -j REJECT --reject-with icmp-host-prohibited@' /etc/sysconfig/iptables 
sed -i 's@^-A FORWARD -j REJECT --reject-with icmp-host-prohibited@#-A FORWARD -j REJECT --reject-with icmp-host-prohibited@' /etc/sysconfig/iptables 
service iptables restart
chkconfig iptables on

service pptpd restart
chkconfig pptpd on
clear

echo -e "你现在可以通过你的外部IP连接VPN \033[32m${VPN_IP}\033[0m"

echo -e "用户名: \033[32m${VPN_USER}\033[0m"
echo -e "密码: \033[32m${VPN_PASS}\033[0m"
