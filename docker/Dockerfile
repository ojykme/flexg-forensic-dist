FROM python:3.13-slim

WORKDIR /app

# 시스템 의존성 설치
RUN apt-get update && apt-get install -y \
    libmagic1 \
    libgl1 \
    libglib2.0-0 \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# 패키지 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 실행 환경 설정
ENV PYTHONPATH=/app/bin:/app
RUN mkdir -p /app/logs && chmod 777 /app/logs

EXPOSE 8000

# 서버 실행 (난독화된 엔트리포인트 실행)
CMD ["python", "bin/server.py"]
