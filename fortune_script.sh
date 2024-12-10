#!/bin/bash

# 사용자 이름 입력
echo "Today's Fortune 프로그램에 오신 것을 환영합니다!"
echo "이름을 입력해 주세요:"
read user_name

# API 키 설정
API_KEY="NNxXBNxj4LHS%2B9shi%2BFDKWgAfIvjpQQgMc7HeJ5GkGG7LdTkhlWYzs1AQUqiPvakK06rkD7yaU2PyArJwuO7Ug%3D%3D"

# 로그 디렉터리 생성
mkdir -p logs

# 스크립트 경로 설정
script_dir=$(dirname "$0")
fortune_file_path="$script_dir/fortune_files"
advice_file_path="$script_dir/advice_files"
location_file="$script_dir/locations.txt"

# 좌표 검색
get_coordinates() {
    location_name=$1
    coordinates=$(grep "^$location_name " "$location_file" | awk '{print $2, $3}')
    echo "$coordinates"
}

# 메일 관련 설정
send_email() {
    echo "이메일 주소를 입력해 주세요:"
    read email_address
    echo "오늘의 운세를 메일로 보내드릴게요!"

    json_message="{
        \"Subject\": {
            \"Data\": \"Today's Fortune🔮\",
            \"Charset\": \"utf8\"
        },
        \"Body\": {
            \"Text\": {
                \"Data\": \"$fortune_message\",
                \"Charset\": \"utf8\"
            }
        }
    }"

    aws ses send-email \
        --from "dkdud981217@gmail.com" \
        --destination "ToAddresses=$email_address" \
        --message "$json_message" \
        --region "us-east-1"

    echo "메일 전송이 완료되었습니다!"
}

# 메인 메뉴
main_menu() {
    echo "카테고리를 선택해 주세요:"
    echo "1. 운세"
    echo "2. 조언"
    echo "3. 종료"
    read category_choice

    case $category_choice in
        1) fortune_menu ;;
        2) advice_menu ;;
        3) exit ;;
        *) echo "잘못된 옵션입니다. 다시 시도해 주세요." ; main_menu ;;
    esac
}

# 운세 카테고리
fortune_menu() {
    echo "운세 카테고리:"
    echo "1. 연애"
    echo "2. 개발"
    echo "3. 금전운"
    echo "4. 인간관계"
    echo "5. 건강"
    echo "6. 별자리"
    read fortune_choice

    case $fortune_choice in
        1)
            fortune=$(cat "$fortune_file_path/love.txt" | shuf -n 1)
            fortune_message="$user_name 님, 오늘의 연애 운세를 알려드릴게요!\n$fortune"
            echo -e "$fortune_message"
            log_fortune_to_json "love" "$fortune"
            ;;
        2)
            fortune=$(cat "$fortune_file_path/developer.txt" | shuf -n 1)
            fortune_message="$user_name 님, 오늘의 개발 운세를 알려드릴게요!\n$fortune"
            echo -e "$fortune_message"
            log_fortune_to_json "developer" "$fortune"
            ;;
        3)
            fortune=$(cat "$fortune_file_path/wealth.txt" | shuf -n 1)
            fortune_message="$user_name 님, 오늘의 금전운을 알려드릴게요!\n$fortune"
            echo -e "$fortune_message"
            log_fortune_to_json "wealth" "$fortune"
            ;;
        4)
            fortune=$(cat "$fortune_file_path/relationships.txt" | shuf -n 1)
            fortune_message="$user_name 님, 오늘의 인간관계 운세를 알려드릴게요!\n$fortune"
            echo -e "$fortune_message"
            log_fortune_to_json "relationships" "$fortune"
            ;;
        5)
            fortune=$(cat "$fortune_file_path/health.txt" | shuf -n 1)
            fortune_message="$user_name 님, 오늘의 건강 운세를 알려드릴게요!\n$fortune"
            echo -e "$fortune_message"
            log_fortune_to_json "health" "$fortune"
            ;;
        6)
            zodiac_fortune
            return
            ;;
        *)
            echo "잘못된 옵션입니다. 다시 시도해 주세요."
            fortune_menu ;;
    esac

    # 메일로 보내기 여부 확인
    echo "오늘의 운세를 메일로 받아보시겠습니까? (y/n)"
    read send_email_choice

    if [[ "$send_email_choice" == "y" || "$send_email_choice" == "Y" ]]; then
        send_email
    else
        echo "운세를 종료합니다."
    fi
}

# 운세 기록을 JSON 파일로 저장하는 함수
log_fortune_to_json() {
    category=$1
    fortune=$2
    log_file="logs/${user_name}_${category}_log.json"

    # JSON 형식으로 날짜와 운세 내용 저장
    json_entry=$(jq -n --arg date "$(date)" --arg category "$category" --arg message "$fortune" \
        '{date: $date, category: $category, message: $message}')

    # 기존 JSON 파일에 추가하거나 새로 생성
    if [[ -f "$log_file" ]]; then
        jq ". + [$json_entry]" "$log_file" > temp.json && mv temp.json "$log_file"
    else
        echo "[$json_entry]" > "$log_file"
    fi
}

# 별자리 운세
zodiac_fortune() {
    echo "생일 월을 입력해 주세요 (1-12):"
    read birth_month
    echo "생일 일을 입력해 주세요 (1-31):"
    read birth_day

    if [[ ($birth_month -eq 3 && $birth_day -ge 21) || ($birth_month -eq 4 && $birth_day -le 19) ]]; then
        zodiac_sign="양자리"
    elif [[ ($birth_month -eq 4 && $birth_day -ge 20) || ($birth_month -eq 5 && $birth_day -le 20) ]]; then
        zodiac_sign="황소자리"
    elif [[ ($birth_month -eq 5 && $birth_day -ge 21) || ($birth_month -eq 6 && $birth_day -le 20) ]]; then
        zodiac_sign="쌍둥이자리"
    elif [[ ($birth_month -eq 6 && $birth_day -ge 21) || ($birth_month -eq 7 && $birth_day -le 22) ]]; then
        zodiac_sign="게자리"
    elif [[ ($birth_month -eq 7 && $birth_day -ge 23) || ($birth_month -eq 8 && $birth_day -le 22) ]]; then
        zodiac_sign="사자자리"
    elif [[ ($birth_month -eq 8 && $birth_day -ge 23) || ($birth_month -eq 9 && $birth_day -le 22) ]]; then
        zodiac_sign="처녀자리"
    elif [[ ($birth_month -eq 9 && $birth_day -ge 23) || ($birth_month -eq 10 && $birth_day -le 22) ]]; then
        zodiac_sign="천칭자리"
    elif [[ ($birth_month -eq 10 && $birth_day -ge 23) || ($birth_month -eq 11 && $birth_day -le 21) ]]; then
        zodiac_sign="전갈자리"
    elif [[ ($birth_month -eq 11 && $birth_day -ge 22) || ($birth_month -eq 12 && $birth_day -le 21) ]]; then
        zodiac_sign="사수자리"
    elif [[ ($birth_month -eq 12 && $birth_day -ge 22) || ($birth_month -eq 1 && $birth_day -le 19) ]]; then
        zodiac_sign="염소자리"
    elif [[ ($birth_month -eq 1 && $birth_day -ge 20) || ($birth_month -eq 2 && $birth_day -le 18) ]]; then
        zodiac_sign="물병자리"
    elif [[ ($birth_month -eq 2 && $birth_day -ge 19) || ($birth_month -eq 3 && $birth_day -le 20) ]]; then
        zodiac_sign="물고기자리"
    fi

    zodiac_file="fortune_files/zodiac.txt"

    if [[ -f "$zodiac_file" ]]; then
        fortune=$(cat "$zodiac_file" | shuf -n 1)
    else
        fortune="운세 파일이 존재하지 않습니다."
    fi

    fortune_message="$user_name 님, 오늘의 ${zodiac_sign} 운세를 알려드릴게요!\n$fortune"
    echo -e "$fortune_message"
    log_fortune_to_json "${zodiac_sign}" "$fortune"

    # 메일로 보내기 여부 확인
    echo "오늘의 별자리 운세를 메일로 받아보시겠습니까? (y/n)"
    read send_email_choice

    if [[ "$send_email_choice" == "y" || "$send_email_choice" == "Y" ]]; then
        send_email
    else
        echo "별자리 운세를 종료합니다."
    fi
}

# 조언 카테고리
advice_menu() {
    echo "조언 카테고리:"
    echo "1. 개발"
    echo "2. 날씨"
    echo "3. 돌아가기"
    read advice_choice

    case $advice_choice in
        1) developer_advice ;;
        2) weather_advice ;;
        3) main_menu ;;
        *) echo "잘못된 옵션입니다. 다시 시도해 주세요." ; advice_menu ;;
    esac
}

developer_advice() {
    title_file="advice_files/developer_Title.txt"
    content_file="advice_files/developer_Contents.txt"

    IFS=$'\n' read -r -d '' -a titles < "$title_file"

    echo "조언들:"
    for i in "${!titles[@]}"; do
        echo "$((i + 1)). ${titles[$i]}"
    done
    echo "$(( ${#titles[@]} + 1 )). 돌아가기"

    echo "원하는 조언의 번호를 선택해 주세요:"
    read advice_choice

    if [[ "$advice_choice" -lt 1 || "$advice_choice" -gt $(( ${#titles[@]} + 1 )) ]]; then
        echo "잘못된 선택입니다. 다시 시도해 주세요."
        developer_advice
    elif [[ "$advice_choice" -eq $(( ${#titles[@]} + 1 )) ]]; then
        main_menu
    else
        content=$(awk -v RS="" "NR==$advice_choice" "$content_file")
        advice_message="$user_name 님, 오늘의 개발 조언: $content"
        echo "$advice_message"

        echo "오늘의 조언을 메일로 받아보시겠습니까? (y/n)"
        read send_email_choice

        if [[ "$send_email_choice" == "y" || "$send_email_choice" == "Y" ]]; then
            send_email
        else
            echo "조언을 종료합니다."
        fi
    fi
}

# 날씨 함수 
weather_advice() {
    echo "현재 위치를 입력해 주세요 (예: 서울):"
    read location

    # 좌표 가져오기
    coordinates=$(get_coordinates "$location")
    if [[ -z "$coordinates" ]]; then
        echo "입력한 위치에 대한 데이터를 찾을 수 없습니다."
        return
    fi

    nx=$(echo "$coordinates" | awk '{print $1}')
    ny=$(echo "$coordinates" | awk '{print $2}')

    echo ""

    # API 호출
    today=$(date +"%Y%m%d")
    base_time=$(calculate_base_time)

    response=$(curl -s "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=${API_KEY}&numOfRows=10&pageNo=1&dataType=JSON&base_date=${today}&base_time=${base_time}&nx=${nx}&ny=${ny}")

    # JSON 유효성 검사
    if ! echo "$response" | jq empty > /dev/null 2>&1; then
        echo "API 응답이 유효하지 않습니다."
        echo "API 응답: $response"
        return
    fi

    # 데이터 추출
    temperature=$(echo "$response" | jq -r '.response.body.items.item[] | select(.category=="TMP") | .fcstValue')
    sky=$(echo "$response" | jq -r '.response.body.items.item[] | select(.category=="SKY") | .fcstValue')
    precipitation=$(echo "$response" | jq -r '.response.body.items.item[] | select(.category=="PTY") | .fcstValue')

    if [[ -z "$temperature" ]]; then
        echo "온도 데이터를 찾을 수 없습니다."
        return
    fi

    case $sky in
        1) sky_status="맑음" ;;
        3) sky_status="구름 많음" ;;
        4) sky_status="흐림" ;;
        *) sky_status="알 수 없음" ;;
    esac

    case $precipitation in
        0) precipitation_status="강수 없음" ;;
        1) precipitation_status="비" ;;
        2) precipitation_status="비/눈" ;;
        3) precipitation_status="눈" ;;
        *) precipitation_status="알 수 없음" ;;
    esac

    echo "현재 ${location}의 날씨 정보를 알려드릴게요!"
    echo "- 기온: ${temperature}°C"
    echo "- 하늘 상태: ${sky_status}"
    echo "- 강수 상태: ${precipitation_status}"
}


# 기준 시간 계산 함수
calculate_base_time() {
    current_hour=$(date +"%H")
    if (( current_hour < 2 )); then echo "2300"; else echo "0500"; fi
}

# 메인 프로그램 실행
main_menu
