#!/bin/bash

# 사용자 이름 입력
echo "Today's Fortune 프로그램에 오신 것을 환영합니다!"
echo "이름을 입력해 주세요:"
read user_name

# 파일 경로 정의
zodiac_file="zodiac.txt"
advice_file="advice.txt"
developer_advice_file="developer_advice.txt"

# 로그 디렉터리 생성
mkdir -p logs

# 메일 관련 설정 (AWS SES 활용)
send_email() {
    echo "이메일 주소를 입력해 주세요:"
    read email_address
    echo "운세 또는 조언을 이메일로 보내드립니다..."

    # SES를 통해 이메일 보내기
    aws ses send-email \
        --from "dkdud981217@gmail.com" \
        --destination "ToAddresses=$email_address" \
        --message "Subject={Data=운세 또는 조언,Charset=utf8},Body={Text={Data=$fortune_message,Charset=utf8}}" \
        --region "us-east-1"
    echo "이메일을 성공적으로 보냈습니다!"
}

# 메인 메뉴
main_menu() {
    echo "카테고리를 선택해 주세요:"
    echo "1. 운세"
    echo "2. 조언"
    echo "3. 컬렉션"
    echo "4. 종료"
    read category_choice

    case $category_choice in
        1) fortune_menu ;;
        2) advice_menu ;;
        3) collection_menu ;;
        4) exit ;;
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
            fortune=$(cat love.txt | shuf -n 1)
            fortune_message="$user_name 님! 오늘의 연애 운세는: $fortune"
            echo "$(date) - 연애: $fortune" >> "logs/${user_name}_love_log.txt"
            ;;
        2)
            fortune=$(cat developer.txt | shuf -n 1)
            fortune_message="$user_name 님! 오늘의 개발 운세는: $fortune"
            echo "$(date) - 개발: $fortune" >> "logs/${user_name}_developer_log.txt"
            ;;
        3)
            fortune=$(cat wealth.txt | shuf -n 1)
            fortune_message="$user_name 님! 오늘의 금전운은: $fortune"
            echo "$(date) - 금전운: $fortune" >> "logs/${user_name}_wealth_log.txt"
            ;;
        4)
            fortune=$(cat relationships.txt | shuf -n 1)
            fortune_message="$user_name 님! 오늘의 인간관계 운세는: $fortune"
            echo "$(date) - 인간관계: $fortune" >> "logs/${user_name}_relationships_log.txt"
            ;;
        5)
            fortune=$(cat health.txt | shuf -n 1)
            fortune_message="$user_name 님! 오늘의 건강 운세는: $fortune"
            echo "$(date) - 건강: $fortune" >> "logs/${user_name}_health_log.txt"
            ;;
        6)
            zodiac_fortune
            return
            ;;
        *)
            echo "잘못된 옵션입니다. 다시 시도해 주세요."
            fortune_menu ;;
    esac

    echo "$fortune_message"

    # 메일로 보내기 여부 확인
    echo "오늘의 운세를 메일로 받아보시겠습니까? (y/n)"
    read send_email_choice

    if [[ "$send_email_choice" == "y" || "$send_email_choice" == "Y" ]]; then
        send_email
    else
        echo "운세를 종료합니다."
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
        advice_message="$user_name 님의 오늘의 개발 조언: $content"
        echo "$advice_message"
        echo "$(date) - 개발 조언: $content" >> "logs/${user_name}_developer_advice_log.txt"

        # 메일로 보내기 여부 확인
        echo "오늘의 조언을 메일로 받아보시겠습니까? (y/n)"
        read send_email_choice

        if [[ "$send_email_choice" == "y" || "$send_email_choice" == "Y" ]]; then
            send_email
        else
            echo "조언을 종료합니다."
        fi
    fi
}

weather_advice() {
    echo "1. 0~10도"
    echo "2. 10~20도"
    echo "3. 20~30도"
    echo "4. 돌아가기"
    read weather_choice

    case $weather_choice in
        1)
            advice=$(cat advice_files/temperature_0to10.txt | shuf -n 1)
            ;;
        2)
            advice=$(cat advice_files/temperature_10to20.txt | shuf -n 1)
            ;;
        3)
            advice=$(cat advice_files/temperature_20to30.txt | shuf -n 1)
            ;;
        4) advice_menu ;;
        *) echo "잘못된 옵션입니다. 다시 시도해 주세요." ; weather_advice ;;
    esac

    weather_advice_message="$user_name 님의 오늘의 날씨 조언: $advice"
    echo "$weather_advice_message"
    echo "$(date) - 날씨 조언: $advice" >> "logs/${user_name}_weather_advice_log.txt"

    # 메일로 보내기 여부 확인
    echo "오늘의 날씨 조언을 메일로 받아보시겠습니까? (y/n)"
    read send_email_choice

    if [[ "$send_email_choice" == "y" || "$send_email_choice" == "Y" ]]; then
        send_email
    else
        echo "날씨 조언을 종료합니다."
    fi
}

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

    fortune=$(cat "zodiac/$zodiac_sign.txt" | shuf -n 1)
    fortune_message="$user_name 님의 오늘의 별자리 운세 ($zodiac_sign): $fortune"
    echo "$fortune_message"
    echo "$(date) - ${zodiac_sign}: $fortune" >> "logs/${user_name}_zodiac_log.txt"

    # 메일로 보내기 여부 확인
    echo "오늘의 별자리 운세를 메일로 받아보시겠습니까? (y/n)"
    read send_email_choice

    if [[ "$send_email_choice" == "y" || "$send_email_choice" == "Y" ]]; then
        send_email
    else
        echo "별자리 운세를 종료합니다."
    fi
}

# 메인 프로그램 실행
main_menu
