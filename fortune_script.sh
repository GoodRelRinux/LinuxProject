#!/bin/bash

# 사용자 이름 입력
echo "Today's Fortune 프로그램에 오신 것을 환영합니다!"
echo "이름을 입력해 주세요:"
read user_name

# 파일 경로 정의
zodiac_file="zodiac.txt"
advice_file="advice.txt"
developer_advice_file="developer_advice.txt"

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
        1) cat love.txt | shuf -n 1 ;;
        2) cat developer.txt | shuf -n 1 ;;
        3) cat wealth.txt | shuf -n 1 ;;
        4) cat relationships.txt | shuf -n 1 ;;
        5) cat health.txt | shuf -n 1 ;;
        6) zodiac_fortune ;;
        *) echo "잘못된 옵션입니다. 다시 시도해 주세요." ; fortune_menu ;;
    esac
}

# 조언 카테고리
advice_menu() {
    echo "조언 카테고리:"
    echo "1. 개발"
    echo "2. 날씨"
    read advice_choice

    case $advice_choice in
        1) developer_advice ;;  
        *) echo "잘못된 옵션입니다. 다시 시도해 주세요." ; advice_menu ;;
    esac
}

# 개발 관련 조언 
developer_advice() {
    random_advice=$(awk -v RS="###" 'BEGIN {srand()} {if (rand() <= 1) print $0}' "$developer_advice_file")
    echo "$random_advice"
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
    else
        zodiac_sign="알 수 없음"
    fi

    echo "${user_name}님, 오늘의 ${zodiac_sign} 운세를 말씀드릴게요!"
    fortune=$(shuf -n 1 "$zodiac_file") 
    echo "$fortune"
}

main_menu
