#!/bin/bash

input_file="맥_developer_log.txt"
output_file="developer_log.json"

# JSON 파일 초기화
echo "[" > "$output_file"

# 파일 내용 읽어서 JSON 포맷으로 변환
first_entry=true
while IFS= read -r line
do
    # 로그 파일의 빈 줄을 무시하기 위해 체크
    if [ -z "$line" ]; then
        continue
    fi

    # 날짜, 카테고리, 메시지를 구분하여 추출
    log_date=$(echo "$line" | awk -F' - ' '{print $1}')
    category=$(echo "$line" | awk -F' - ' '{print $2}' | awk -F': ' '{print $1}')
    message=$(echo "$line" | awk -F': ' '{print $2}')

    # 첫 번째 항목 이후에는 쉼표 추가
    if [ "$first_entry" = true ]; then
        first_entry=false
    else
        echo "," >> "$output_file"
    fi

    # JSON 형식으로 변환하여 파일에 추가
    echo "  {" >> "$output_file"
    echo "    \"date\": \"$log_date\"," >> "$output_file"
    echo "    \"category\": \"$category\"," >> "$output_file"
    echo "    \"message\": \"$message\"" >> "$output_file"
    echo "  }" >> "$output_file"
done < "$input_file"

# JSON 배열 닫기
echo "]" >> "$output_file"

echo "JSON 파일이 생성되었습니다: $output_file"

