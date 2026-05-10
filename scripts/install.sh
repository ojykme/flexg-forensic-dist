#!/bin/bash

# FlexG Forensic Node - Installer v1.1
# Copyright (c) 2024 Solas Forensic

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

printf "${BLUE}==================================================${NC}\n"
printf "${BLUE}      FlexG Forensic Node - Installation          ${NC}\n"
printf "${BLUE}==================================================${NC}\n"

# 1. Docker 체크 및 자동 설치
if ! [ -x "$(command -v docker)" ]; then
    printf "${YELLOW}[INFO] Docker is not installed. Attempting automatic installation...${NC}\n"
    if [ -f /etc/debian_version ]; then
        apt-get update && apt-get install -y ca-certificates curl gnupg
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
        chmod a+r /etc/apt/keyrings/docker.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
        apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    else
        printf "${RED}[ERROR] Automatic installation is only supported on Debian/Ubuntu. Please install Docker manually.${NC}\n"
        exit 1
    fi
    printf "${GREEN}[SUCCESS] Docker installed successfully.${NC}\n"
fi

# 2. 디렉토리 준비
printf "${GREEN}[1/4] Preparing directories...${NC}\n"
mkdir -p logs/api logs/worker data/postgres data/redis

# 3. 환경 설정 초기화
if [ ! -f .env ]; then
    printf "${GREEN}[2/4] Initializing environment config...${NC}\n"
    if [ -f docker/.env.example ]; then
        cp docker/.env.example .env
    else
        touch .env
    fi
    printf "${BLUE}[INFO] .env file created. Please configure it.${NC}\n"
fi

# 4. HWID 생성 (라이선스용)
printf "${GREEN}[3/4] Generating Server HWID...${NC}\n"
if [ -f /etc/machine-id ]; then
    HWID=$(cat /etc/machine-id | sha256sum | cut -c1-32)
else
    HWID=$(hostname | sha256sum | cut -c1-32)
fi

printf "${BLUE}--------------------------------------------------${NC}\n"
printf "${GREEN}YOUR SERVER HWID: ${BLUE}$HWID${NC}\n"
printf "${BLUE}Please provide this ID to Solas Forensic.${NC}\n"
printf "${BLUE}--------------------------------------------------${NC}\n"

# 5. 서비스 시작
printf "${GREEN}[4/4] Starting services with Docker Compose...${NC}\n"
if [ -f docker/docker-compose.yml ]; then
    docker compose -f docker/docker-compose.yml up -d --build
else
    printf "${RED}[ERROR] docker/docker-compose.yml not found.${NC}\n"
    exit 1
fi

printf "${BLUE}==================================================${NC}\n"
printf "${GREEN}Installation complete!${NC}\n"
printf "${BLUE}==================================================${NC}\n"
