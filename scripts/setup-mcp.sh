#!/bin/bash

# 🎯 Скрипт установки и настройки MCP серверов для Edestory Platform
# Автор: Edestory Team
# Дата: Январь 2025

set -e

echo "🚀 Начинаем установку MCP серверов для Edestory Platform..."

# Цвета для вывода
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Проверка Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js не установлен. Установите Node.js 18+ и попробуйте снова.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Node.js найден: $(node --version)${NC}"

# Создание директорий
echo "📁 Создаём структуру директорий..."
mkdir -p mcp-servers/installed
mkdir -p mcp-config

# Переход в директорию MCP серверов
cd mcp-servers

# Инициализация package.json если не существует
if [ ! -f "package.json" ]; then
    echo "📦 Инициализируем package.json..."
    npm init -y > /dev/null 2>&1
fi

# Установка бесплатных MCP серверов
echo -e "${YELLOW}📥 Устанавливаем бесплатные MCP серверы...${NC}"

# Filesystem и Memory (официальные)
echo "  1️⃣ Filesystem MCP..."
npm install @modelcontextprotocol/server-filesystem --save

echo "  2️⃣ Memory MCP..."
npm install @modelcontextprotocol/server-memory --save

# Supabase MCP
echo "  3️⃣ Supabase MCP..."
npm install supabase-mcp --save

echo -e "${GREEN}✅ Базовые MCP серверы установлены!${NC}"

# Клонирование официальных серверов если не существует
if [ ! -d "../mcp-official-servers" ]; then
    echo -e "${YELLOW}📥 Клонируем официальные MCP серверы...${NC}"
    cd ..
    git clone https://github.com/modelcontextprotocol/servers.git mcp-official-servers
    cd mcp-official-servers
    npm install
    npm run build
    cd ../mcp-servers
else
    echo -e "${GREEN}✅ Официальные MCP серверы уже клонированы${NC}"
fi

# Создание примера конфигурации
echo "📝 Создаём пример конфигурации..."

cat > ../mcp-config/claude_desktop_config.example.json << 'EOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "@modelcontextprotocol/server-filesystem",
        "$HOME/edestory-platform"
      ]
    },
    "memory": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-memory"]
    },
    "git": {
      "command": "node",
      "args": [
        "$HOME/edestory-platform/mcp-official-servers/dist/git/index.js",
        "--repository",
        "$HOME/edestory-platform"
      ]
    },
    "fetch": {
      "command": "node",
      "args": [
        "$HOME/edestory-platform/mcp-official-servers/dist/fetch/index.js"
      ]
    },
    "supabase": {
      "command": "npx",
      "args": ["supabase-mcp"],
      "env": {
        "SUPABASE_URL": "${SUPABASE_URL}",
        "SUPABASE_ANON_KEY": "${SUPABASE_ANON_KEY}"
      }
    }
  }
}
EOF

# Создание .env.mcp.example если не существует
if [ ! -f "../.env.mcp.example" ]; then
    cat > ../.env.mcp.example << 'EOF'
# MCP Environment Variables

# Namecheap Domain Registration
NAMECHEAP_API_USER=your-username
NAMECHEAP_API_KEY=your-api-key
NAMECHEAP_CLIENT_IP=your-whitelisted-ip

# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_KEY=your-service-key

# PostgreSQL (for Saleor)
DATABASE_URL=postgresql://user:password@localhost:5432/edestory

# Cloudflare (optional)
CLOUDFLARE_API_TOKEN=your-api-token
CLOUDFLARE_ACCOUNT_ID=your-account-id

# GitHub
GITHUB_TOKEN=your-github-token

# Stripe (when needed)
STRIPE_SECRET_KEY=sk_test_your_key

# Vercel (if using)
VERCEL_TOKEN=your-vercel-token
EOF
fi

echo -e "${GREEN}✅ Конфигурация создана!${NC}"

# Инструкции по настройке
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✅ УСТАНОВКА MCP СЕРВЕРОВ ЗАВЕРШЕНА!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Следующие шаги:"
echo ""
echo "1. Скопируйте конфигурацию в Claude Desktop:"
echo -e "   ${YELLOW}cp mcp-config/claude_desktop_config.example.json ~/Library/Application\\ Support/Claude/claude_desktop_config.json${NC}"
echo ""
echo "2. Настройте переменные окружения:"
echo -e "   ${YELLOW}cp .env.mcp.example .env.mcp${NC}"
echo "   Отредактируйте .env.mcp и добавьте ваши API ключи"
echo ""
echo "3. Перезапустите Claude Desktop"
echo ""
echo "4. Проверьте логи MCP:"
echo -e "   ${YELLOW}tail -f ~/Library/Logs/Claude/mcp-*.log${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📚 Документация: docs/MCP_SERVERS_GUIDE.md"
echo "🔗 Официальный репозиторий: https://github.com/modelcontextprotocol/servers"
echo ""
echo -e "${GREEN}🎉 Готово к использованию!${NC}"