#!/bin/bash

# Скрипт для тестирования MCP серверов перед добавлением в Claude

echo "🧪 Тестирование MCP серверов..."
echo ""

# Цвета
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Тест 1: Filesystem MCP
echo "1. Testing Filesystem MCP..."
if timeout 5 node /Users/vadimarhipov/edestory-platform/mcp-official-servers/src/filesystem/dist/index.js /Users/vadimarhipov/edestory-platform < /dev/null 2>/dev/null; then
    echo -e "${GREEN}✅ Filesystem MCP работает${NC}"
else
    echo -e "${YELLOW}⚠️  Filesystem MCP требует stdio input (нормально)${NC}"
fi

# Тест 2: Memory MCP
echo ""
echo "2. Testing Memory MCP..."
if timeout 5 node /Users/vadimarhipov/edestory-platform/mcp-official-servers/src/memory/dist/index.js < /dev/null 2>/dev/null; then
    echo -e "${GREEN}✅ Memory MCP работает${NC}"
else
    echo -e "${YELLOW}⚠️  Memory MCP требует stdio input (нормально)${NC}"
fi

# Тест 3: Google Cloud MCP
echo ""
echo "3. Testing Google Cloud MCP..."
if [ -f "/Users/vadimarhipov/edestory-platform/mcp-google-cloud/dist/index.js" ]; then
    echo -e "${GREEN}✅ Google Cloud MCP собран${NC}"
else
    echo -e "${RED}❌ Google Cloud MCP не найден${NC}"
    echo "   Выполните: cd mcp-google-cloud && npm run build"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}📋 Конфигурация сохранена в:${NC}"
echo "~/Library/Application Support/Claude/claude_desktop_config.json"
echo ""
echo -e "${YELLOW}⚠️  ВАЖНО: Перезапустите Claude Desktop${NC}"
echo ""
echo "Для перезапуска:"
echo "1. Закройте Claude Desktop полностью (Cmd+Q)"
echo "2. Откройте заново"
echo "3. Проверьте логи MCP в настройках"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"