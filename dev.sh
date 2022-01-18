#!/bin/bash


# Init shell
#

# Yum repo
yum install -y epel-release gcc gcc-c++ make cpp glibc-headers kernel-headers automake autoconf openssl-devel pcre-devel readline-devel libcurl-devel wget net-tools rpm-build rpmdevtools
wget https://raw.githubusercontent.com/lifezq/rpm_specs/master/repo/ryan.repo -O /etc/yum.repos.d/ryan.repo
# chrome
echo '[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub' > /etc/yum.repos.d/google-chrome.repo

yum clean all && yum makecache fast

echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf
sysctl -p



# Desktop
# yum groupinstall "GNOME Desktop" or yum groups mark-install "GNOME Desktop" "Development Tools"

# zsh
yum install -y zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Monitor Commands
yum install -y dstat
# usage: dstat -cdlmnpsyr --socket --tcp

# Backup 
# rsync
# rdiff-backup 

# Port scan
yum install -y nmap
# usage: nmap -sS 192.168.0.1/24

# trace route
yum install -y traceroute mtr

# system profile
yum install -y sysstat psmisc

# disk profile
yum install -y hdparm
# usage: hdparm -I /dev/sda 

# net profile
yum install -y tcpdump
# usage: tcpdump -i enp5s0 -vv host domain
# usage: tcpdump -i any -Xnns 0 port 8281   

# pci
# yum install -y lspci
# usage: lspci -vvv | grep Ethernet

# /etc/profile
# export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

## 去这上面找个ttl小的 http://tool.chinaz.com/dns
# echo -e "192.30.253.112 github.com\n151.101.13.194 github.global.ssl.fastly.net\n52.216.65.8 github-cloud.s3.amazonaws.com" >> /etc/hosts


# npm config set registry http://registry.npm.taobao.org/
# npm config set registry https://registry.npmjs.org/


# TZ='Asia/Shanghai'; export TZ

## GO ENV
GO111MODULE=on
GOPROXY=https://goproxy.cn,direct
# go静态编译
# CGO_ENABLED=0 go build --ldflags "-extldflags -static" .


# protoc
## protoc -I/path1/common -I /path2/proto --go_out=.  --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative  *.proto

# win10 禁用Hyper-V, 以管理员身份运行cmd输入
## bcdedit /set hypervisorlaunchtype off
# win10 恢复Hyper-V
## bcdedit /set hypervisorlaunchtype auto

# git ctrl/lf
git config --global core.autocrlf true  # 如果编辑器已经是LF，就不需要这个转换。为input/false即可
git config --global core.safecrlf true

# 更换pip源 修改 ~/.pip/pip.conf 
```
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple/
[install]
trusted-host = pypi.tuna.tsinghua.edu.cn
```
