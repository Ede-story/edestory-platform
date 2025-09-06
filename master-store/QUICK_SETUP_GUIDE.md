#!/bin/bash

# Полная проверка системы Edestory Shop

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   ${GREEN}🔍 Проверка системы Edestory Shop${BLUE}                 ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════╝${NC}\n"

# Проверка Docker
echo -n "🐳 Docker: "
if docker ps > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
    
    # Проверка контейнеров
    echo -n "   PostgreSQL: "
    if docker ps | grep -q "postgres"; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ (запустите: docker-compose up -d)${NC}"
    fi
    
    echo -n "   Redis: "
    if docker ps | grep -q "redis"; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
    fi
    
    echo -n "   Saleor: "
    if docker ps | grep -q "saleor"; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${YELLOW}⚠ (опционально)${NC}"
    fi
    
    echo -n "   n8n: "
    if docker ps | grep -q "n8n"; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${YELLOW}⚠ (опционально)${NC}"
    fi
else
    echo -e "${RED}✗ (установите Docker)${NC}"
fi

# Проверка Node.js
echo -n "📦 Node.js: "
if node --version > /dev/null 2>&1; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✓ ($NODE_VERSION)${NC}"
else
    echo -e "${RED}✗${NC}"
fi

# Проверка pnpm
echo -n "📦 pnpm: "
if pnpm --version > /dev/null 2>&1; then
    PNPM_VERSION=$(pnpm --version)
    echo -e "${GREEN}✓ (v$PNPM_VERSION)${NC}"
else
    echo -e "${RED}✗ (установите: npm i -g pnpm)${NC}"
fi

# Проверка .env файлов
echo -n "🔧 Конфигурация: "
if [ -f "frontend/.env.local" ]; then
    echo -e "${GREEN}✓${NC}"
    
    # Проверка ключевых переменных
    echo -n "   Email API: "
    if grep -q "api.edestory@gmail.com" frontend/.env.local; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
    fi
    
    echo -n "   Stripe keys: "
    if grep -q "pk_test_" frontend/.env.local; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${YELLOW}⚠ (добавьте после регистрации)${NC}"
    fi
    
    echo -n "   AliExpress keys: "
    if grep -q "ALIEXPRESS_APP_KEY=" frontend/.env.local && grep -q "ALIEXPRESS_APP_KEY=." frontend/.env.local; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${YELLOW}⚠ (ожидает одобрения)${NC}"
    fi
else
    echo -e "${RED}✗ (не найден .env.local)${NC}"
fi

# Проверка портов
echo -n "🌐 Порты: "
PORTS_OK=true

echo ""
echo -n "   3002 (Frontend): "
if lsof -Pi :3002 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${GREEN}✓ занят${NC}"
else
    echo -e "${YELLOW}свободен${NC}"
fi

echo -n "   8000 (Saleor): "
if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${GREEN}✓ занят${NC}"
else
    echo -e "${YELLOW}свободен${NC}"
fi

echo -n "   5678 (n8n): "
if lsof -Pi :5678 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${GREEN}✓ занят${NC}"
else
    echo -e "${YELLOW}свободен${NC}"
fi

# Проверка скриптов
echo -n "📜 Скрипты: "
SCRIPTS_OK=true
for script in aliexpress-test.js import-products.js test-email.js save-stripe-keys.js; do
    if [ ! -f "scripts/$script" ]; then
        SCRIPTS_OK=false
        break
    fi
done

if [ "$SCRIPTS_OK" = true ]; then
    echo -e "${GREEN}✓ все на месте${NC}"
else
    echo -e "${RED}✗ некоторые отсутствуют${NC}"
fi

# Итоговый статус
echo -e "\n${BLUE}═══════════════════════════════════════════════════════${NC}"

READY=true

# Проверка критических компонентов
if ! docker ps > /dev/null 2>&1; then
    READY=false
    echo -e "${RED}❌ Docker не запущен${NC}"
fi

if [ ! -f "frontend/.env.local" ]; then
    READY=false
    echo -e "${RED}❌ Конфигурация не найдена${NC}"
fi

if [ "$READY" = true ]; then
    echo -e "${GREEN}✅ СИСТЕМА ГОТОВА К РАБОТЕ!${NC}\n"
    
    echo -e "${YELLOW}📝 Что осталось сделать:${NC}"
    
    if ! grep -q "ALIEXPRESS_APP_KEY=." frontend/.env.local 2>/dev/null; then
        echo -e "1. Дождаться одобрения AliExpress (1-3 дня)"
        echo -e "   После одобрения: ${CYAN}node scripts/aliexpress-test.js${NC}"
    fi
    
    if ! grep -q "pk_test_" frontend/.env.local 2>/dev/null; then
        echo -e "2. Добавить Stripe ключи"
        echo -e "   Команда: ${CYAN}node scripts/save-stripe-keys.js${NC}"
    fi
    
    echo -e "\n${GREEN}🚀 Запуск магазина:${NC}"
    echo -e "   ${CYAN}cd frontend && pnpm dev${NC}"
    echo -e "   Откройте: ${BLUE}http://localhost:3002${NC}"
else
    echo -e "${RED}❌ ТРЕБУЕТСЯ НАСТРОЙКА${NC}\n"
    echo -e "Запустите Docker: ${CYAN}docker-compose up -d${NC}"
fi

echo -e "\n${BLUE}═══════════════════════════════════════════════════════${NC}"