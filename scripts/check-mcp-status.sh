#!/bin/bash

# Проверка статуса MCP серверов

echo "🔍 Проверка статуса MCP серверов..."
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Проверка конфигурации
CONFIG_FILE="$HOME/Library/Application Support/Claude/claude_desktop_config.json"

if [ -f "$CONFIG_FILE" ]; then
    echo -e "${GREEN}✅ Конфигурационный файл найден${NC}"
    echo ""
    echo "📋 Настроенные серверы:"
    cat "$CONFIG_FILE" | grep -E '"[^"]+":' | grep -v mcpServers | sed 's/.*"\([^"]*\)".*/  - \1/'
else
    echo -e "${RED}❌ Конфигурационный файл не найден${NC}"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Проверка файлов серверов:"
echo ""

# Проверка filesystem
if [ -f "/Users/vadimarhipov/edestory-platform/mcp-official-servers/src/filesystem/dist/index.js" ]; then
    echo -e "${GREEN}✅ Filesystem MCP - файл существует${NC}"
else
    echo -e "${RED}❌ Filesystem MCP - файл не найден${NC}"
fi

# Проверка memory
if [ -f "/Users/vadimarhipov/edestory-platform/mcp-official-servers/src/memory/dist/index.js" ]; then
    echo -e "${GREEN}✅ Memory MCP - файл существует${NC}"
else
    echo -e "${RED}❌ Memory MCP - файл не найден${NC}"
fi

# Проверка Google Cloud
if [ -f "/Users/vadimarhipov/edestory-platform/mcp-google-cloud/dist/index.js" ]; then
    echo -e "${GREEN}✅ Google Cloud MCP - файл существует${NC}"
else
    echo -e "${RED}❌ Google Cloud MCP - файл не найден${NC}"
fi

# Проверка sequential-thinking
if [ -f "/Users/vadimarhipov/edestory-platform/mcp-official-servers/src/sequentialthinking/dist/index.js" ]; then
    echo -e "${GREEN}✅ Sequential Thinking MCP - файл существует${NC}"
else
    echo -e "${RED}❌ Sequential Thinking MCP - файл не найден${NC}"
fi

# Проверка everything
if [ -f "/Users/vadimarhipov/edestory-platform/mcp-official-servers/src/everything/dist/index.js" ]; then
    echo -e "${GREEN}✅ Everything MCP - файл существует${NC}"
else
    echo -e "${RED}❌ Everything MCP - файл не найден${NC}"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${YELLOW}💡 Следующие шаги:${NC}"
echo "1. Проверьте статус каждого сервера в Claude Desktop"
echo "2. Если сервер показывает error - скопируйте текст ошибки"
echo "3. Для Google Cloud нужен Service Account (см. GOOGLE_CLOUD_SETUP.md)"
echo ""