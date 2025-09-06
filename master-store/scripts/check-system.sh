#!/bin/bash

# Полная проверка системы Edestory Shop

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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
        echo -e "${GREEN}✓ работает${NC}"
    else
        echo -e "${YELLOW}⚠ не запущен${NC}"
    fi
    
    echo -n "   Redis: "
    if docker ps | grep -q "redis"; then
        echo -e "${GREEN}✓ работает${NC}"
    else
        echo -e "${YELLOW}⚠ не запущен${NC}"
    fi
else
    echo -e "${RED}✗ Docker не запущен${NC}"
    echo -e "${YELLOW}   Запустите: docker-compose up -d${NC}"
fi

# Проверка Node.js
echo -n "📦 Node.js: "
if node --version > /dev/null 2>&1; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✓ $NODE_VERSION${NC}"
else
    echo -e "${RED}✗ не установлен${NC}"
fi

# Проверка pnpm
echo -n "📦 pnpm: "
if pnpm --version > /dev/null 2>&1; then
    PNPM_VERSION=$(pnpm --version)
    echo -e "${GREEN}✓ v$PNPM_VERSION${NC}"
else
    echo -e "${RED}✗ установите: npm i -g pnpm${NC}"
fi

# Проверка Email настроек
echo -n "📧 Email API: "
if [ -f "frontend/.env.local" ] && grep -q "api.edestory@gmail.com" frontend/.env.local; then
    echo -e "${GREEN}✓ настроен${NC}"
    
    echo -n "   SMTP пароль: "
    if grep -q "SMTP_PASSWORD=." frontend/.env.local; then
        echo -e "${GREEN}✓ сохранен${NC}"
    else
        echo -e "${RED}✗ отсутствует${NC}"
    fi
else
    echo -e "${RED}✗ не настроен${NC}"
fi

# Проверка Stripe
echo -n "💳 Stripe: "
if [ -f "frontend/.env.local" ] && grep -q "pk_test_" frontend/.env.local; then
    echo -e "${GREEN}✓ тестовые ключи${NC}"
else
    echo -e "${YELLOW}⚠ ожидает настройки${NC}"
    echo -e "   ${CYAN}Запустите: node scripts/save-stripe-keys.js${NC}"
fi

# Проверка AliExpress
echo -n "📦 AliExpress: "
if [ -f "frontend/.env.local" ] && grep -q "ALIEXPRESS_APP_KEY=." frontend/.env.local; then
    echo -e "${GREEN}✓ API ключи сохранены${NC}"
else
    echo -e "${YELLOW}⚠ ожидает одобрения (1-3 дня)${NC}"
    echo -e "   ${CYAN}После одобрения: node scripts/aliexpress-test.js${NC}"
fi

# Проверка портов
echo -n "🌐 Порты: "
FREE_PORTS=true

if lsof -Pi :3002 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${YELLOW}3002 занят${NC}"
    FREE_PORTS=false
else
    echo -e "${GREEN}3002 свободен${NC}"
fi

# Проверка скриптов
echo -n "📜 Скрипты: "
MISSING_SCRIPTS=""
for script in aliexpress-test.js import-products.js test-email.js save-stripe-keys.js; do
    if [ ! -f "scripts/$script" ]; then
        MISSING_SCRIPTS="$MISSING_SCRIPTS $script"
    fi
done

if [ -z "$MISSING_SCRIPTS" ]; then
    echo -e "${GREEN}✓ все готовы${NC}"
else
    echo -e "${RED}✗ отсутствуют:$MISSING_SCRIPTS${NC}"
fi

# ИТОГИ
echo -e "\n${BLUE}═══════════════════════════════════════════════════════${NC}"

# Подсчет готовности
READY_COUNT=0
TOTAL_COUNT=5

if docker ps > /dev/null 2>&1; then
    ((READY_COUNT++))
fi

if [ -f "frontend/.env.local" ] && grep -q "api.edestory@gmail.com" frontend/.env.local; then
    ((READY_COUNT++))
fi

if [ -f "frontend/.env.local" ] && grep -q "SMTP_PASSWORD=." frontend/.env.local; then
    ((READY_COUNT++))
fi

if pnpm --version > /dev/null 2>&1; then
    ((READY_COUNT++))
fi

if [ -z "$MISSING_SCRIPTS" ]; then
    ((READY_COUNT++))
fi

PERCENTAGE=$((READY_COUNT * 100 / TOTAL_COUNT))

if [ $PERCENTAGE -eq 100 ]; then
    echo -e "${GREEN}✅ СИСТЕМА ПОЛНОСТЬЮ ГОТОВА! (100%)${NC}\n"
    echo -e "${YELLOW}📝 Что делать дальше:${NC}"
    
    if ! grep -q "ALIEXPRESS_APP_KEY=." frontend/.env.local 2>/dev/null; then
        echo -e "\n1. ${CYAN}Зарегистрируйтесь в AliExpress:${NC}"
        echo -e "   🔗 https://portals.aliexpress.com"
        echo -e "   Email: api.edestory@gmail.com"
    fi
    
    if ! grep -q "pk_test_" frontend/.env.local 2>/dev/null; then
        echo -e "\n2. ${CYAN}Настройте Stripe:${NC}"
        echo -e "   🔗 https://dashboard.stripe.com/register"
        echo -e "   После регистрации: node scripts/save-stripe-keys.js"
    fi
    
    echo -e "\n${GREEN}🚀 Запустить магазин:${NC}"
    echo -e "   ${CYAN}cd frontend && pnpm dev${NC}"
    echo -e "   Откройте: ${BLUE}http://localhost:3002${NC}"
    
elif [ $PERCENTAGE -ge 80 ]; then
    echo -e "${YELLOW}⚠ ПОЧТИ ГОТОВО! ($PERCENTAGE%)${NC}\n"
    echo -e "Осталось немного настроек"
    
elif [ $PERCENTAGE -ge 50 ]; then
    echo -e "${YELLOW}⚠ ЧАСТИЧНО ГОТОВО ($PERCENTAGE%)${NC}\n"
    echo -e "Требуется дополнительная настройка"
    
else
    echo -e "${RED}❌ ТРЕБУЕТСЯ НАСТРОЙКА ($PERCENTAGE%)${NC}\n"
    
    if ! docker ps > /dev/null 2>&1; then
        echo -e "${RED}1. Запустите Docker Desktop${NC}"
        echo -e "   Затем: ${CYAN}docker-compose up -d${NC}"
    fi
    
    if ! pnpm --version > /dev/null 2>&1; then
        echo -e "${RED}2. Установите pnpm:${NC}"
        echo -e "   ${CYAN}npm install -g pnpm${NC}"
    fi
fi

echo -e "\n${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Справка:${NC} Полная инструкция в ${CYAN}STEP_BY_STEP.md${NC}"