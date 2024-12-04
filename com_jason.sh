#	!/bin/bash

json_file="/path/to/react-app/src/logs/user_fortune_log.json"

log_file="logs/user_fortune_log.txt"
json_file="logs/user_fortune_log.json"

# JSON 파일 생성
echo "[" > "$json_file"
while IFS= read -r line; do
  date=$(echo "$line" | cut -d'-' -f1 | xargs)
  category=$(echo "$line" | cut -d'-' -f2 | cut -d':' -f1 | xargs)
  message=$(echo "$line" | cut -d':' -f2- | xargs)

  echo "  {" >> "$json_file"
  echo "    \"date\": \"$date\"," >> "$json_file"
  echo "    \"category\": \"$category\"," >> "$json_file"
  echo "    \"message\": \"$message\"" >> "$json_file"
  echo "  }," >> "$json_file"

done < "$log_file"
sed -i '$ s/,$//' "$json_file"
echo "]" >> "$json_file"

