# 📚 MCP Серверы для Edestory Platform - Полное руководство

## 🔴 ВАЖНО: Основной провайдер - Google Cloud Platform
- **Домены:** Google Domains (перенесены в Squarespace)
- **Хостинг:** Google Cloud Platform (GCP)
- **Compute:** Google Compute Engine / Cloud Run
- **База данных:** Cloud SQL / Spanner
- **Storage:** Google Cloud Storage

## 🎯 Статус установки

✅ **Установлены и готовы к использованию:**

### 🌟 GOOGLE CLOUD MCP СЕРВЕРЫ (ПРИОРИТЕТ 1)

#### Google Cloud MCP ✅
```bash
cd mcp-google-cloud && npm install && npm run build
node dist/index.js
```
- **Путь:** `/mcp-google-cloud`
- **Репозиторий:** https://github.com/krzko/google-cloud-mcp
- **Возможности:**
  - **Billing** - управление и анализ биллинга
  - **Cloud Run** - деплой контейнеров
  - **Compute Engine** - управление VM
  - **Cloud Storage** - работа с хранилищем
  - **Cloud SQL** - управление БД
  - **IAM** - управление доступом
  - **Logging** - просмотр логов
  - **Monitoring** - метрики и алерты
  - **Spanner** - работа с Spanner БД
- **Цена:** Оплата только за используемые ресурсы GCP

#### Google Domains / Squarespace Domains 🔍
- **Статус:** Google Domains мигрировал в Squarespace
- **Альтернативы для управления доменами:**
  - Squarespace Domains API (новый владелец Google Domains)
  - Cloud DNS API для управления DNS записями
  - Переезд на Cloudflare (рекомендуется)

### 🆓 БЕСПЛАТНЫЕ MCP Серверы

#### 1. Filesystem MCP ✅
```bash
npx @modelcontextprotocol/server-filesystem
```
- **Путь:** `/mcp-official-servers/src/filesystem`
- **Зачем:** Улучшенная работа с файлами, массовые операции
- **Возможности:**
  - Чтение/запись файлов
  - Создание директорий
  - Batch операции
  - Контроль доступа к директориям
- **Цена:** Бесплатно

#### 2. Memory MCP ✅
```bash
npx @modelcontextprotocol/server-memory
```
- **Путь:** `/mcp-official-servers/src/memory`
- **Зачем:** Сохранение контекста между сессиями
- **Возможности:**
  - Knowledge graph
  - Долговременная память
  - Связи между концептами
- **Цена:** Бесплатно

#### 3. Git MCP ✅
```bash
node /Users/vadimarhipov/edestory-platform/mcp-official-servers/src/git/dist/index.js
```
- **Путь:** `/mcp-official-servers/src/git`
- **Зачем:** Расширенная работа с Git
- **Возможности:**
  - История коммитов
  - Диффы
  - Cherry-pick
  - Поиск по коду
- **Цена:** Бесплатно

#### 4. Fetch MCP ✅
```bash
node /Users/vadimarhipov/edestory-platform/mcp-official-servers/src/fetch/dist/index.js
```
- **Путь:** `/mcp-official-servers/src/fetch`
- **Зачем:** Работа с внешними API
- **Возможности:**
  - HTTP запросы
  - Тестирование endpoints
  - Интеграции с API
- **Цена:** Бесплатно

#### 5. PostgreSQL MCP 🔍
- **Статус:** Официальный архивирован, ищем альтернативы
- **Альтернативы:**
  - Postgres MCP Pro (crystaldba/postgres-mcp)
  - MCP Toolbox for Databases
- **Зачем:** Прямая работа с БД Saleor
- **Цена:** Бесплатно

### 🟡 УСЛОВНО-БЕСПЛАТНЫЕ

#### 6. Supabase MCP ✅
```bash
npx supabase-mcp
```
- **Установлен:** `npm install supabase-mcp`
- **Зачем:** База данных и auth для корп. сайта
- **Возможности:**
  - CRUD операции
  - Realtime подписки
  - Аутентификация
  - Storage
- **Цена:** Бесплатно до 500MB

### 🌐 MCP ДЛЯ ДОМЕНОВ

#### 7. Namecheap MCP 🆕
```bash
npx mcp-namecheap-registrar
```
- **URL:** https://mcp.so/server/mcp-namecheap-registrar
- **Зачем:** Регистрация доменов
- **Возможности:**
  - Проверка доступности доменов
  - Проверка цен
  - Регистрация доменов через API
  - Управление DNS записями
- **Цена:** Бесплатно (оплата только за домены)
- **Требует:** API ключи Namecheap

#### 8. Cloudflare MCP (Альтернатива) 🆕
- **Статус:** 13 официальных MCP серверов от Cloudflare
- **Возможности:**
  - Workers deployment
  - DNS управление
  - Domain transfers
  - Zero Trust
- **Цена:** Бесплатный план доступен

### 💳 ПЛАТНЫЕ (при необходимости)

#### 9. Stripe MCP
- **Когда:** При добавлении платежей
- **Цена:** Комиссия с транзакций

#### 10. Vercel MCP
- **Статус:** У вас есть подписка €20
- **Возможности:** Деплой, preview, логи

## 📁 Структура установки

```
edestory-platform/
├── mcp-servers/
│   ├── package.json
│   ├── node_modules/
│   │   ├── @modelcontextprotocol/
│   │   │   ├── server-filesystem/
│   │   │   └── server-memory/
│   │   └── supabase-mcp/
│   ├── aliexpress-server.js (custom)
│   ├── n8n-server.js (custom)
│   └── saleor-server.js (custom)
└── mcp-official-servers/
    ├── src/
    │   ├── filesystem/
    │   ├── memory/
    │   ├── git/
    │   ├── fetch/
    │   ├── time/
    │   ├── sequentialthinking/
    │   └── everything/
    └── package.json
```

## 🔧 Конфигурация Claude Desktop

### Пример конфигурации для claude_desktop_config.json:

```json
{
  "mcpServers": {
    "google-cloud": {
      "command": "node",
      "args": [
        "/Users/vadimarhipov/edestory-platform/mcp-google-cloud/dist/index.js"
      ],
      "env": {
        "GOOGLE_APPLICATION_CREDENTIALS": "/path/to/service-account-key.json",
        "GOOGLE_CLOUD_PROJECT": "edestory-platform"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "@modelcontextprotocol/server-filesystem",
        "/Users/vadimarhipov/edestory-platform"
      ]
    },
    "memory": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-memory"]
    },
    "git": {
      "command": "node",
      "args": [
        "/Users/vadimarhipov/edestory-platform/mcp-official-servers/src/git/dist/index.js",
        "--repository",
        "/Users/vadimarhipov/edestory-platform"
      ]
    },
    "supabase": {
      "command": "npx",
      "args": ["supabase-mcp"],
      "env": {
        "SUPABASE_URL": "your-project-url",
        "SUPABASE_ANON_KEY": "your-anon-key"
      }
    },
    "namecheap": {
      "command": "npx",
      "args": ["mcp-namecheap-registrar"],
      "env": {
        "NAMECHEAP_API_USER": "your-username",
        "NAMECHEAP_API_KEY": "your-api-key",
        "NAMECHEAP_CLIENT_IP": "your-ip"
      }
    }
  }
}
```

## 🚀 Команды для тестирования

### Проверка установки:
```bash
# Filesystem
npx @modelcontextprotocol/server-filesystem --help

# Memory
npx @modelcontextprotocol/server-memory --help

# Git
node mcp-official-servers/src/git/dist/index.js --help

# Supabase
npx supabase-mcp --help
```

### Сборка официальных серверов:
```bash
cd mcp-official-servers
npm run build
```

## 🔐 Переменные окружения

Добавьте в `.env.mcp`:

```bash
# Google Cloud Platform (ОСНОВНОЙ ПРОВАЙДЕР)
GOOGLE_CLOUD_PROJECT=edestory-platform
GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json
GOOGLE_CLOUD_REGION=europe-west1
GOOGLE_CLOUD_ZONE=europe-west1-b

# Namecheap API (альтернатива для доменов)
NAMECHEAP_API_USER=your-username
NAMECHEAP_API_KEY=your-api-key
NAMECHEAP_CLIENT_IP=your-whitelisted-ip

# Supabase
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_KEY=your-service-key

# Cloudflare (optional)
CLOUDFLARE_API_TOKEN=your-api-token
CLOUDFLARE_ACCOUNT_ID=your-account-id
```

## 📊 Сравнение регистраторов доменов

| Регистратор | MCP Поддержка | Цена .com | API | Особенности |
|-------------|---------------|-----------|-----|-------------|
| **Google/Squarespace** | ⚠️ Cloud DNS MCP | $12/год | ✅ | Текущий провайдер, мигрировал в Squarespace |
| **Cloudflare** | ✅ 13 MCP серверов | $9.77/год | ✅ | At-cost pricing, лучшая MCP поддержка |
| **Namecheap** | ✅ Есть MCP | $9-13/год | ✅ | Whois Guard бесплатно |
| **GoDaddy** | ❌ Нет MCP | $12-20/год | ✅ | Дорого, но популярно |
| **Porkbun** | ❌ Нет MCP | $9.73/год | ✅ | Дешево, хороший API |

### Рекомендация для Edestory: 
1. **Оставаться на Google/Squarespace** - если домены уже там и всё работает
2. **Переезд на Cloudflare** - для лучшей MCP интеграции и экономии (~$2/год на домен)

## 🎯 Следующие шаги

1. ✅ Установка базовых MCP серверов - **ГОТОВО**
2. ⏳ Настройка конфигурации в Claude Desktop
3. ⏳ Получение API ключей для Namecheap/Cloudflare
4. ⏳ Тестирование всех серверов
5. ⏳ Интеграция с проектом

## 💡 Полезные команды

```bash
# Обновить все MCP пакеты
cd mcp-servers && npm update

# Проверить установленные версии
npm list --depth=0

# Логи MCP серверов (в Claude Desktop)
tail -f ~/Library/Logs/Claude/mcp-*.log
```

## 🔗 Полезные ссылки

- [Официальный репозиторий MCP](https://github.com/modelcontextprotocol/servers)
- [MCP Registry](https://mcp.so)
- [Awesome MCP Servers](https://github.com/wong2/awesome-mcp-servers)
- [Cloudflare MCP Docs](https://developers.cloudflare.com/agents/model-context-protocol/)
- [Namecheap API Docs](https://www.namecheap.com/support/api/)

---

**Обновлено:** Январь 2025
**Статус:** MCP серверы установлены, требуется конфигурация