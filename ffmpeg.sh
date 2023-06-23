#!/bin/bash

# 颜色样式
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# 检查用户是否是 Linux 系统，否则退出
if [ "$(uname -s)" != "Linux" ]; then
  echo -e "${RED}抱歉，该脚本仅适用于 Linux 系统。${NC}"
  exit 1
fi

# 检查是否为 root 用户，否则退出
if [ "$(id -u)" != "0" ]; then
  echo -e "${RED}请使用 root 用户执行该脚本。${NC}"
  exit 1
fi

# 检查 /usr/local/bin/ffmpeg 文件是否存在
if [ -e "/usr/local/bin/ffmpeg" ]; then
  read -p "FFmpeg 已安装，是否需要重新安装？(y/n): " reinstall
  reinstall=$(echo "$reinstall" | tr '[:upper:]' '[:lower:]')  # 转换为小写字母

  if [[ $reinstall == "y" || $reinstall == "yes" ]]; then
    echo "开始重新安装 FFmpeg..."
  else
    echo "退出安装。"
    exit 0
  fi
fi

# 检查是否安装 wget，如果未安装则使用包管理器安装
if ! command -v wget >/dev/null 2>&1; then
  echo "未检测到 wget，尝试安装..."
  
  # 使用 apt-get 安装 wget（Debian 或 Ubuntu）
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update
    apt-get install -y wget || { echo -e "${RED}无法安装 wget。${NC}"; exit 1; }
  fi
  
  # 使用 yum 安装 wget（CentOS 或 RHEL）
  if command -v yum >/dev/null 2>&1; then
    yum update -y
    yum install -y wget || { echo -e "${RED}无法安装 wget。${NC}"; exit 1; }
  fi
fi

# 安装函数
install_ffmpeg() {
  local source_name=$1
  local ffmpeg_url=$2
  local ffprobe_url=$3

  echo -e "开始下载 FFmpeg（源：${GREEN}${source_name}${NC}）..."
  
  # 删除已有的文件
  rm -f /usr/local/bin/ffmpeg
  rm -f /usr/local/bin/ffprobe

  wget -O /usr/local/bin/ffmpeg $ffmpeg_url
  wget -O /usr/local/bin/ffprobe $ffprobe_url
  chmod 777 /usr/local/bin/ffmpeg
  chmod 777 /usr/local/bin/ffprobe

  # 检查安装是否成功
  if [ ! -e "/usr/local/bin/ffmpeg" ] || [ ! -e "/usr/local/bin/ffprobe" ]; then
    echo -e "${RED}FFmpeg 安装失败，请检查你的网络。${NC}"
    exit 1
  fi

  echo "安装成功。"
  exit 0
}

# 检查 CPU 架构并下载相应的 FFmpeg 和 ffprobe 文件
if [[ "$(uname -m)" == "arm"* ]]; then
  echo "检测到 ARM 架构，开始下载 FFmpeg 和 ffprobe..."

  # 尝试第一组链接进行安装
  install_ffmpeg "DF官网下载" "https://dengfenglai.cloud/ffmpeg/ARM64/ffmpeg" "https://dengfenglai.cloud/ffmpeg/ARM64/ffprobe"

  # 尝试第二组链接进行安装
  install_ffmpeg "阿里云下载" "https://denfenglai.oss-cn-hongkong.aliyuncs.com/ARM64/ffmpeg" "https://denfenglai.oss-cn-hongkong.aliyuncs.com/ARM64/ffprobe"

  # 尝试第三组链接进行安装
  install_ffmpeg "gitee码云下载" "https://gitee.com/Wind-is-so-strong/ffmpeg/raw/master/ARM64/ffmpeg" "https://gitee.com/Wind-is-so-strong/ffmpeg/raw/master/ARM64/ffprobe"
elif [[ "$(uname -m)" == "x86_64" ]]; then
  echo "检测到 AMD 架构，开始下载 FFmpeg..."

  # 尝试第一组链接进行安装
  install_ffmpeg "DF官网下载" "https://dengfenglai.cloud/ffmpeg/AMD64/ffmpeg" ""

  # 尝试第二组链接进行安装
  install_ffmpeg "阿里云下载" "https://denfenglai.oss-cn-hongkong.aliyuncs.com/AMD64/ffmpeg" ""

  # 尝试第三组链接进行安装
  install_ffmpeg "gitee码云下载" "https://gitee.com/Wind-is-so-strong/ffmpeg/raw/master/AMD64/ffmpeg" ""
else
  echo -e "${RED}抱歉，不支持当前 CPU 架构。${NC}"
  exit 1
fi