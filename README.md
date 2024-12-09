# 웹사이트 연동하는 방법.
1. todays_fortune 디렉토리로 이동한다.
2. live-server --host=0.0.0.0 --port=8080  -> 이 코드를 친다.(live-server를 꼭 설치하셔야 됩니다.)
3. 퍼블릭 IPv4 주소:8080 -> 브라우저를 열고 왼쪽 텍스트를 쳐 8080포트로 연다. (개인 인스턴스에 인바운드 규칙에서 8080포트 연결허용을 추가해야 됩니다.)
4. index.html 로 들어간다.

# live-server 설치 방법
1. Node.js 설치
|| curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
|| sudo apt install -y nodejs
3. 설치 확인
|| node -v
|| npm -v
5. Live Server 설치
|| npm install -g live-server
6. Live Server 실행
|| cd today_fortune
|| live-server --host=0.0.0.0 --port=8080

# 인바운드 규칙 설정하기
<img width="1309" alt="스크린샷 2024-12-09 오후 7 58 04" src="https://github.com/user-attachments/assets/b4c38320-8a2d-445d-92e0-e334511ebffa">


# 로그인 화면
1. goldcard를 입력하면 love운세가 다 수집된 황금카드를 볼 수 있습니다.
