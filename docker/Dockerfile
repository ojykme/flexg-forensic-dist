FROM python:3.12-slim

WORKDIR /app

# 시스템 의존성 설치 (이미지 처리용 libmagic, libgl 등)
RUN apt-get update && apt-get install -y \
    libmagic1 \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# 패키지 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 실행 권한 설정
RUN mkdir -p /app/logs && chmod 777 /app/logs

# 고객 서버에서는 bin/ 폴더가 볼륨으로 마운트되거나 복사됨
ENV PYTHONPATH=/app

CMD ["python", "bin/server.py"]
