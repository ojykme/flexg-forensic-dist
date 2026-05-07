#!/bin/bash

# FlexG Forensic Node - Installer v1.0
# Copyright (c) 2024 Solas Forensic

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}==================================================${NC}"
echo -e "${BLUE}      FlexG Forensic Node - Installation          ${NC}"
echo -e "${BLUE}==================================================${NC}"

# 1. Docker Check
if ! [ -x "$(command -v docker)" ]; then
    echo -e "${RED}[ERROR] Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# 2. Setup Directories
echo -e "${GREEN}[1/4] Preparing directories...${NC}"
mkdir -p logs/api logs/worker data/postgres data/redis

# 3. Environment Config
if [ ! -f .env ]; then
    echo -e "${GREEN}[2/4] Initializing environment config...${NC}"
    cp docker/.env.example .env
    echo -e "${BLUE}[INFO] .env file created. Please edit it later if needed.${NC}"
fi

# 4. Generate HWID (Simplified for now)
echo -e "${GREEN}[3/4] Generating Server HWID...${NC}"
if [ -f /etc/machine-id ]; then
    HWID=$(cat /etc/machine-id | sha256sum | cut -c1-32)
else
    HWID=$(hostname | sha256sum | cut -c1-32)
fi

echo -e "${BLUE}--------------------------------------------------${NC}"
echo -e "${GREEN}YOUR SERVER HWID: ${BLUE}$HWID${NC}"
echo -e "${BLUE}Please provide this ID to Solas Forensic to issue your license.${NC}"
echo -e "${BLUE}--------------------------------------------------${NC}"

# 5. Launch Service
echo -e "${GREEN}[4/4] Starting services with Docker Compose...${NC}"
docker compose -f docker/docker-compose.yml up -d

echo -e "${BLUE}==================================================${NC}"
echo -e "${GREEN}Installation initiated successfully!${NC}"
echo -e "Access the HUD at: ${BLUE}https://your-server-ip${NC}"
echo -e "${BLUE}==================================================${NC}"
