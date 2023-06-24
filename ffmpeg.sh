#!/bin/bash

#下载源
    name=DF官网下载
    link=https://dengfenglai.cloud/ffmpeg
#阿里link=https://denfenglai.oss-cn-hongkong.aliyuncs.com
#码云link=https://gitee.com/Wind-is-so-strong/ffmpeg/raw/master

# 设定文件大小
  ffmpeg_size=$(stat -c%s /usr/local/bin/ffmpeg)
  ffprobe_size=$(stat -c%s /usr/local/bin/ffprobe)
  min_size=40000000  # 设置最小文件大小为40MB


# 颜色样式
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# 检查用户是否是 Linux 系统，否则退出
if [ "$(uname -s)" != "Linux" ]; then
  clear
  echo -e "${RED}抱歉，该脚本仅适用于 Linux 系统。${NC}"
  exit 1
fi

# 检查是否为 root 用户，否则退出
if [ "$(id -u)" != "0" ]; then
  clear
  echo -e "${RED}请使用 root 用户执行该脚本。${NC}"
  exit 1
fi


    if [[ $ffmpeg_size -gt $min_size && $ffprobe_size -gt $min_size ]]; then
    clear_screen  # 清屏
      clear
  echo -e "==============================="
  echo -e "            DF 等风来"
  echo -e "==============================="
  echo -e "       \e[1;31m注意:\e[0m"
  echo -e "       FFmpeg\e[1;36m 已安装\e[0m"
  read -p "是否需要删除重新安装？(Y/N): " reinstall
  clear
  reinstall=$(echo "$reinstall" | tr '[:upper:]' '[:lower:]')  # 转换为小写字母

  if [[ $reinstall == "y" || $reinstall == "yes" ]]; then
    echo -e "\e[32m开始重新安装 FFmpeg...\e[0m"
  else
    echo -e "\e[32m退出安装\e[0m“”"
    exit 0
  fi
  fi 

# 检查是否安装 wget，如果未安装则使用包管理器安装
if ! command -v wget >/dev/null 2>&1; then
  clear
  echo "未检测到 wget，尝试安装..."
  
  # 使用 apt-get 安装 wget（Debian 或 Ubuntu）
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update
    apt-get install -y wget || { clear; echo -e "${RED}无法安装 wget。${NC}"; exit 1; }
  fi
  
  # 使用 yum 安装 wget（CentOS 或 RHEL）
  if command -v yum >/dev/null 2>&1; then
    yum update -y
    yum install -y wget || { clear; echo -e "${RED}无法安装 wget。${NC}"; exit 1; }
  fi
fi

# 清屏函数
clear_screen() {
  clear  # 清屏
  echo "==========================="
  echo "      FFmpeg 安装"
  echo "      作者：等风来        "
  echo "      dengfenglai.cloud "
  echo "==========================="
  echo
}

  clear_screen  # 清屏
  if [ $(uname -m) == "aarch64" ]; then
    echo -e "\e[1;36m正在下载 \e[32mffmpeg\e[0m"
    echo -e "\e[34m下载源:\e[33m${name}\e[0m"
    echo
    cd /usr/local/bin
    rm -rf /usr/local/bin/ffmpeg
    rm -rf /usr/local/bin/ffprobe
    time wget ${link}/ARM64/ffmpeg
    echo
    echo -e "\e[1;32m正在下载 \e[32mffprobe\e[0m"
    echo -e "\e[34m下载源:\e[33m${name}\e[0m"
    echo 
    time wget ${link}/ARM64/ffprobe
    chmod 777 ffmpeg
    chmod 777 ffprobe
    
elif [ $(uname -m) == "x86_64" ]; then
    clear_screen
    echo -e "\e[1;36m正在下载 \e[32mffmpeg\e[0m"  
    echo -e "\e[34m下载源:\e[33m${name}\e[0m"
    echo
    cd /usr/local/bin
    rm -rf /usr/local/bin/ffmpeg
    time wget ${link}/AMD64/ffmpeg
    chmod 777 ffmpeg
fi

# 设定文件大小
  ffmpeg_size=$(stat -c%s /usr/local/bin/ffmpeg)
  ffprobe_size=$(stat -c%s /usr/local/bin/ffprobe)
  min_size=40000000  # 设置最小文件大小为40MB
#检查是否安装成功  
  if [[ $ffmpeg_size -gt $min_size && $ffprobe_size -gt $min_size ]]; then
    clear_screen  # 清屏
    echo -e "\e[32m安装成功\e[0m"
    echo -e "\e[33m重启Yunzai后就能用了"
    echo -e "\e[36m主页dengfenglai.cloud\e[34m"
    echo -e "\e[37mQQ交流群:692314526\e[0m"
    exit 0
  else
    echo -e "${RED}FFmpeg 安装失败，请检查你的网络。${NC}"
  fi 