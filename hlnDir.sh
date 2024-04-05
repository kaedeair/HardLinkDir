#!/bin/bash

# 函数：创建硬链接
create_hard_links() {

    # 检查目标目录是否存在，如果不存在则创建
    create_dir "$2"
    # 遍历源目录下的文件和子目录
    for file in "$1"/*; do
        if [[ -d "$file" ]]; then
            # 如果是目录，则递归调用函数
            create_hard_links "$file" "$2/$(basename "$file")"
        elif [[ -f "$file" ]]; then
            # 如果是文件，则创建硬链接到目标目录
            ln "$file" "$2/$(basename "$file")"
        fi
    done
}

create_dir(){
    # 检查目标目录是否存在，如果不存在则创建
    if [[ ! -d "$1" ]]; then
        mkdir -p "$1"
        if [[ $? -ne 0 ]]; then
            echo "Error: Failed to create target directory '$2'."
            exit 1
        fi
    fi
}

# 主函数
main() {
    # 检查输入参数数量
    if [[ $# -ne 2 ]]; then
        echo "Usage: $0 <source_directory> <target_directory>"
        exit 1
    fi

    # 检查源目录是否存在
    if [[ ! -d "$1" ]]; then
        echo "Error: Source directory '$1' not found."
        exit 1
    fi
    target_base_dir="$2/$(basename "$1")"

    # 创建硬链接
    create_hard_links "$1" "$target_base_dir"
    
    echo "Hard links created successfully from '$1' to '$target_base_dir'."
}

# 调用主函数，并传入命令行参数
main "$@"
