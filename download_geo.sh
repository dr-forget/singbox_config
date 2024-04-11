#!/bin/bash

# 记录脚本开始时间
start_time=$(date +%s)

# 定义文件下载链接和目标保存路径
file_urls=(
    "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/geolocation-!cn.srs"
    "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geosite/geolocation-cn.srs"
    "https://cdn.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@sing/geo/geoip/cn.srs"
    "https://mirror.ghproxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/category-ads-all.srs"
    "https://mirror.ghproxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/apple.srs"
    "https://mirror.ghproxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/private.srs"
    "https://mirror.ghproxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geoip/private.srs"
    "https://mirror.ghproxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/google.srs"
    "https://mirror.ghproxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/openai@ads.srs"
    https://mirror.ghproxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/openai.srs
)
destinations=(
    "/usr/share/geo-data/geo/geolocation-not_cn.srs"
    "/usr/share/geo-data/geo/geolocation-cn.srs"
    "/usr/share/geo-data/geo/cn.srs"
    "/usr/share/geo-data/geo/category-ads-all.srs"
    "/usr/share/geo-data/geo/apple.srs"
    "/usr/share/geo-data/geo/private.srs"
    "/usr/share/geo-data/geo/private_geoip.srs"
    "/usr/share/geo-data/geo/google.srs"
    "/usr/share/geo-data/geo/openai_geosite.srs"
    "/usr/share/geo-data/geo/openai_geoip.srs"
)

# 重置进度条
reset_progress() {
    progress_bar="                                                  "
    echo -n "0%"
}

# 更新进度条
update_progress() {
    local percentage=$1
    local progress=$((percentage / 2))
    printf "\r[%-${progress}s] %d%%" "${progress_bar:0:progress}" "$percentage"
}

# 初始化进度条
reset_progress

# 下载函数
download_file() {
    local file_url=$1
    local destination=$2
    
    # 下载文件
    wget --quiet --progress=bar:force:noscroll -O "$destination" "$file_url"

    # 检查下载是否成功
    if [ $? -eq 0 ]; then
        echo "文件已成功下载并保存到 $destination"
    else
        echo "下载文件 $file_url 时发生错误，请检查网络连接或重试"
    fi
}

# 循环下载文件
for ((i = 0; i < ${#file_urls[@]}; i++)); do
    file_url="${file_urls[i]}"
    destination="${destinations[i]}"

    # 在后台执行下载函数
    download_file "$file_url" "$destination" &
done

# 等待所有后台任务完成
wait

# 记录脚本结束时间
end_time=$(date +%s)

# 计算脚本运行耗时
duration=$((end_time - start_time))

# 输出耗时
echo "脚本运行耗时：$duration 秒"

# 下载完成后换行
echo ""
