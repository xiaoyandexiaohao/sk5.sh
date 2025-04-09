# 一键搭建 SOCKS5 和 PPTP 服务器

欢迎使用本项目，您可以通过以下简单的步骤快速搭建 SOCKS5 和 PPTP 服务。

## 📝 简介

此脚本通过 `bash` 命令一键自动化部署 SOCKS5 代理和 PPTP VPN 服务器，适用于 Linux 系统。通过本脚本，您可以轻松搭建个人 VPN 或代理服务。

### 功能：

- 自动安装并配置 SOCKS5 代理服务
- 自动安装并配置 PPTP VPN 服务
- 一键化操作，简化部署过程

## 🚀 快速开始

### 1. 执行以下命令开始搭建：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/xiaoyandexiaohao/sk5.sh/refs/heads/main/dajian.sh)
```

该命令会从 GitHub 上获取脚本并立即开始执行。脚本会自动完成必要的安装与配置步骤。

2. 配置说明：
SOCKS5 代理：支持通过 shadowsocks 客户端进行访问。

PPTP VPN：支持 Windows、Linux 和 macOS 的内置 PPTP 客户端连接。

3. 完成安装后，您可以通过以下方式进行连接：
SOCKS5：使用您选择的 SOCKS5 客户端，填写服务器 IP 和端口即可连接。

PPTP VPN：在系统的 VPN 设置中，选择 PPTP 协议，填写服务器地址、用户名和密码即可。

🔧 常见问题
Q1: 如何修改服务器的用户名和密码？
您可以编辑脚本中的配置部分，修改 PPTP 和 SOCKS5 的相关用户名和密码设置。

Q2: 如何查看日志或排查问题？
您可以通过查看服务器的系统日志来检查服务是否正常运行。执行以下命令查看相关日志：

```bash
tail -f /var/log/syslog
```

Q3:提示非root用户，搭建失败！
您可以输入以下内容切换root用户
```bash
sudo -s
```
📜 脚本源代码
该项目的源代码托管在 GitHub 上，您可以在这里查看脚本的完整内容和更多的自定义选项：

GitHub 仓库

🛠️ 支持的系统
Ubuntu

Debian

CentOS

RedHat

📢 免责声明
使用本脚本时请确保您的网络行为符合当地法律法规。本站不对任何因使用该脚本导致的法律问题或其他相关问题承担责任。
