#!/bin/bash

# 记录脚本开始时间
start_time=$(date +%s)

# 检查参数是否提供
if [ -z "$1" ]; then
    echo "Usage: $0 <JSON文件路径> <起始端口> <结束端口>"
    exit 1
fi

# 检查jq是否已安装
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install jq (https://stedolan.github.io/jq/) to proceed."
    exit 1
fi

# 读取JSON文件
json_file="$1"

# 起始端口
start_port="$2"

# 结束端口
end_port="$3"

# 随机生成起始端口和结束端口之间的端口号
random_port=$((start_port + RANDOM % (end_port - start_port + 1)))

# 修改server_port字段为随机端口号
jq --argjson random_port "$random_port" '.outbounds |= map(if .type == "hysteria2" then .server_port = $random_port else . end)' "$json_file" > "$json_file.tmp" && mv "$json_file.tmp" "$json_file"

# 输出修改后的JSON文件内容
echo "Modified JSON file:"
echo $random_port

# 记录脚本结束时间
end_time=$(date +%s)

# 计算脚本运行时间
runtime=$((end_time - start_time))

# 输出脚本运行时间
echo "Script execution time: $runtime seconds"
