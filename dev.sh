#!/bin/bash


# Init shell
#

# Yum repo
yum install -y epel-release gcc gcc-c++ make cpp glibc-headers kernel-headers automake autoconf openssl-devel pcre-devel readline-devel libcurl-devel wget net-tools
wget https://raw.githubusercontent.com/lifezq/rpm_specs/master/repo/ryan.repo -O /etc/yum.repos.d/ryan.repo
yum clean all && yum makecache fast

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

# pci
# yum install -y lspci
# usage: lspci -vvv | grep Ethernet

# /etc/profile
# export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
