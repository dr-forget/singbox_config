#!/bin/bash

# 记录脚本开始时间
start_time=$(date +%s)

# 检查参数是否提供
if [ -z "$1" ]; then
    echo "Usage: $0 <JSON文件路径>"
    exit 1
fi

# 检查jq是否已安装
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install jq (https://stedolan.github.io/jq/) to proceed."
    exit 1
fi

# 读取JSON文件
json_file="$1"

# 提取route下的rule_set数组
rule_sets=$(jq -r '.route.rule_set' "$json_file")

# 函数定义：下载URL资源并保存到对应路径
download_and_save() {
    local url="$1"
    local path="$2"
    echo "Downloading $url to $path"
    curl -sS "$url" -o "$path"
    if [ $? -eq 0 ]; then
        echo "Download successful"
    else
        echo "Download failed"
    fi
}

# 遍历rule_sets数组，启动多个下载任务
for rule in $(echo "$rule_sets" | jq -c '.[]'); do
    # 提取URL和路径
    url=$(echo "$rule" | jq -r '.url')
    path=$(echo "$rule" | jq -r '.path')

    # 启动后台下载任务
    download_and_save "$url" "$path" &
done

# 等待所有后台下载任务完成
wait

# 记录脚本结束时间
end_time=$(date +%s)

# 计算脚本运行时间
runtime=$((end_time - start_time))

# 输出脚本运行时间
echo "Script execution time: $runtime seconds"
