#!/bin/bash

# FlexG Forensic Node - Installer v1.0
# Copyright (c) 2024 Solas Forensic

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

printf "${BLUE}==================================================${NC}\n"
printf "${BLUE}      FlexG Forensic Node - Installation          ${NC}\n"
printf "${BLUE}==================================================${NC}\n"

# 1. Docker Check
if ! [ -x "$(command -v docker)" ]; then
    printf "${RED}[ERROR] Docker is not installed. Please install Docker first.${NC}\n"
    exit 1
fi

# 2. Setup Directories
printf "${GREEN}[1/4] Preparing directories...${NC}\n"
mkdir -p logs/api logs/worker data/postgres data/redis

# 3. Environment Config
if [ ! -f .env ]; then
    printf "${GREEN}[2/5] Initializing environment config...${NC}\n"
    cp docker/.env.example .env
    printf "${BLUE}[INFO] .env file created. Please edit it later if needed.${NC}\n"
fi

# 4. Domain & DNS Setup (Linode Integration)
printf "${GREEN}[3/5] Setting up Domain & DNS...${NC}\n"
read -p "Enter your desired subdomain (e.g., client1): " SUBDOMAIN
if [ ! -z "$SUBDOMAIN" ]; then
    # TODO: Detect Public IP and call Linode API to create A record
    PUBLIC_IP=$(curl -s https://ifconfig.me)
    printf "${BLUE}[INFO] Detected Public IP: $PUBLIC_IP${NC}\n"
    printf "${BLUE}[INFO] Subdomain $SUBDOMAIN will be linked to $PUBLIC_IP via Linode DNS API.${NC}\n"
    
    # Update .env with the new domain
    sed -i "s/DOMAIN=.*/DOMAIN=$SUBDOMAIN.flexg.app/" .env
fi

# 5. Generate HWID (Simplified for now)
printf "${GREEN}[4/5] Generating Server HWID...${NC}\n"
if [ -f /etc/machine-id ]; then
    HWID=$(cat /etc/machine-id | sha256sum | cut -c1-32)
else
    HWID=$(hostname | sha256sum | cut -c1-32)
fi

printf "${BLUE}--------------------------------------------------${NC}\n"
printf "${GREEN}YOUR SERVER HWID: ${BLUE}$HWID${NC}\n"
printf "${BLUE}Please provide this ID to Solas Forensic to issue your license.${NC}\n"
printf "${BLUE}--------------------------------------------------${NC}\n"

# 6. Launch Service
printf "${GREEN}[5/5] Starting services with Docker Compose...${NC}\n"
docker compose -f docker/docker-compose.yml up -d

printf "${BLUE}==================================================${NC}\n"
printf "${GREEN}Installation initiated successfully!${NC}\n"
printf "Access the HUD at: ${BLUE}https://your-server-ip${NC}\n"
printf "${BLUE}==================================================${NC}\n"
