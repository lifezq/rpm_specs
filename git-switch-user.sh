#!/bin/bash

# 定义两个用户配置
USER1_NAME="user1"
USER1_EMAIL="user1@example.com"

USER2_NAME="user2"
USER2_EMAIL="user2@example.com"

# 当前配置变量
CURRENT_NAME=$(git config --global user.name)
CURRENT_EMAIL=$(git config --global user.email)

# 显示当前配置
echo "当前Git配置:"
echo "用户名: $CURRENT_NAME"
echo "邮箱: $CURRENT_EMAIL"
echo ""

# 切换配置函数
switch_git_config() {
    local new_name=$1
    local new_email=$2
    
    git config --global user.name "$new_name"
    git config --global user.email "$new_email"
    
    echo "已切换到:"
    echo "用户名: $(git config --global user.name)"
    echo "邮箱: $(git config --global user.email)"
}

# 主菜单
echo "请选择要切换的Git配置:"
echo "1) $USER1_NAME <$USER1_EMAIL>"
echo "2) $USER2_NAME <$USER2_EMAIL>"
echo "q) 退出"
echo ""

read -p "请输入选择 (1/2/q): " choice

case $choice in
    1)
        switch_git_config "$USER1_NAME" "$USER1_EMAIL"
        ;;
    2)
        switch_git_config "$USER2_NAME" "$USER2_EMAIL"
        ;;
    q|Q)
        echo "退出脚本"
        exit 0
        ;;
    *)
        echo "无效输入"
        exit 1
        ;;
esac
