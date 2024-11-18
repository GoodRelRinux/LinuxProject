#!/bin/bash

# 로그 파일 경로 설정
log_dir="./logs"
log_file="$log_dir/fortune_log.txt"

# 로그 디렉토리 생성
mkdir -p "$log_dir"

# 로그 기록 함수
log_fortune() {
    local user_name="$1"
    local category="$2"
    local fortune="$3"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    # 로그 파일에 기록
    echo "[$timestamp] USER: $user_name | CATEGORY: $category | FORTUNE: \"$fortune\"" >> "$log_file"
}

# 로그 기록 호출


log_fortune "$user_name" "$category" "$fortune"
echo "로그 기록 완료: [$user_name] - $category - \"$fortune\""

