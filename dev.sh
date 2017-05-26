#!/bin/bash


# Init shell
#

# Yum repo
yum install -y epel-release gcc gcc-c++ make cpp glibc-headers kernel-headers automake autoconf openssl-devel pcre-devel readline-devel libcurl-devel wget net-tools psmisc
wget https://raw.githubusercontent.com/lifezq/rpm_specs/617abbe2653f2e35ffd70f34b307f05317b8fd83/repo/ryan.repo -O /etc/yum.repos.d/ryan.repo
yum clean all && yum makecache fast

# Desktop
# yum groupinstall "GNOME Desktop" or yum groups mark-install "GNOME Desktop" "Development Tools"

# zsh
yum install -y zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Monitor Commands
yum install -y dstat
# dstat -cdlmnpsyr --socket --tcp

# Backup 
# rsync
# rdiff-backup
