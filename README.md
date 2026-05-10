# FlexG Forensic Service - Release Distribution

본 저장소는 FlexG Forensic Service의 엔터프라이즈 배포를 위한 패키지를 포함하고 있습니다. 소스 코드가 포함되지 않은 바이너리 배포판이며, 정식 라이선스가 필요합니다.

## 🚀 빠른 설치 (One-Line Install)
지원되는 리눅스 환경(Ubuntu 22.04+ 권장)에서 아래 명령어를 실행하십시오.

```bash
curl -s https://raw.githubusercontent.com/ojykme/flexg-forensic-dist/main/scripts/install.sh | bash
```

## 📦 구성 요소
- Forensic Engine: 고성능 DNA 분석 엔진 (Rust Binary)
- API Server: 엔터프라이즈 통합 인터페이스 (Obfuscated Python)
- Admin HUD: 관리자용 실시간 모니터링 대시보드
- Security Gateway: SSL/HTTPS 자동 적용 (Caddy)

## 🛠️ 요구 사항
- Docker 24.0+ 및 Docker Compose v2.20+
- 4GB 이상의 RAM (8GB 권장)
- 포트 80, 443 개방 필요

## 🔑 라이선스 문의
정식 라이선스 발급 및 기술 지원은 아래로 문의 바랍니다.
- Email: support@example.com
