
# CLAUDE.md

⚠️ **ПРАВИЛО**: Этот файл не должен превышать 500 строк. Текущий размер: ~400 строк.

## 🌐 ЯЗЫК ОБЩЕНИЯ
**ВСЕГДА отвечай на русском языке**, если не указано иное.

## 🤖 ИНСТРУКЦИЯ: Работа с двумя агентами Claude Code

### ВАЖНО: Этот агент - SHOP_AGENT (Интернет-магазин)
**МОЙ ФОКУС:** `/master-store/` и домен `shop.ede-story.com`

### Разделение задач между агентами:
1. **Чат 1 (CORP_AGENT)**: "Работаем с корпоративным сайтом"
   - Фокус: /corporate-site/, домен www.ede-story.com
   - Задачи: Landing pages, SEO, лидогенерация
   - Статус: ✅ Мигрирован с дизайном

2. **Чат 2 (SHOP_AGENT)**: "Работаем с интернет-магазином" ← **ЭТО Я**
   - Фокус: /master-store/, домен shop.ede-story.com
   - Задачи: Saleor, e-commerce, AliExpress API
   - Технологии: Next.js 15, Saleor GraphQL, PostgreSQL

## 💰 КРИТИЧЕСКАЯ СТРАТЕГИЯ: Open Source First

### Принципы экономии:
```yaml
OPEN SOURCE ONLY:
  - Используем ТОЛЬКО open-source решения
  - n8n self-hosted (не SaaS версию)
  - Все сервисы на собственном хостинге
  - Клиенты НЕ платят за подписки
  - Все включено в стоимость платформы

API ОПТИМИЗАЦИЯ:
  - Кэширование всех API запросов
  - Batch обработка вместо единичных запросов
  - Использование webhooks вместо polling
  - Rate limiting для защиты от перерасхода
  - Выбор самых дешевых API провайдеров
```

## 🎯 РАЗДЕЛЕНИЕ ПРОЕКТОВ

**Корпоративный сайт** (CORP_AGENT - Чат 1):
- Домен: www.ede-story.com
- Путь: /corporate-site/
- Стек: Next.js 14, Tailwind, self-hosted CMS

**Интернет-магазин** (SHOP_AGENT - Чат 2):
- Домен: shop.ede-story.com  
- Путь: /master-store/
- Стек: Saleor, Next.js 15, PostgreSQL, n8n self-hosted


## 🔒 ЗАЩИЩЕННЫЕ ЭЛЕМЕНТЫ
```yaml
Colors:
  graphite: "#3d3d3d"    # Secondary buttons, accents
  black: "#171717"       # Main text
  gold: "#E6A853"        # Primary CTAs, main accents
  burgundy: "#8B2635"    # Sales, special offers
  bg-primary: "#fcfcfc"  # Main background
  bg-white: "#ffffff"    # Product cards

Typography:
  font: "Montserrat, sans-serif"
  h1: "48px"
  h2: "36px"
  h3: "24px"
  body: "16px"

SEO:
  - title tags → UPDATE_SEO command only
  - meta descriptions → UPDATE_META command only
  - h1 headers → UPDATE_HEADERS command only
```

## 📁 СТРУКТУРА ПРОЕКТА
```
edestory-platform/
├── corporate-site/     # Корп. сайт (www.ede-story.com)
├── master-store/       # Шаблон магазина (shop.ede-story.com)
├── scripts/            # Скрипты клонирования
├── docs/              # Документация
│   ├── SPRINTS/       # Спринты обоих проектов
│   └── index.html     # Русскоязычный портал
└── n8n-workflows/     # Self-hosted n8n конфигурации
```

## 📋 УПРАВЛЕНИЕ СПРИНТАМИ

**Активные спринты:**
- Корп. сайт: docs/SPRINTS/CORP_SPRINT_001.md
- Магазин: docs/SPRINTS/SHOP_SPRINT_001.md

**Приоритеты:** P0 (критические) → P1 (обязательные) → P2 (желательные)

## 🧪 ОБЯЗАТЕЛЬНОЕ ТЕСТИРОВАНИЕ

### 📸 ПРАВИЛО СКРИНШОТОВ (КРИТИЧЕСКИ ВАЖНО)
**ПЕРЕД началом любой задачи по изменению UI/дизайна:**
1. Сделать скриншоты текущего состояния страницы (desktop/mobile)
2. Проанализировать визуальные баги и проблемы
3. Точно спланировать изменения с учетом дизайн-системы
4. Реализовать изменения

**ПОСЛЕ завершения задачи:**
1. Сделать новые скриншоты измененных страниц
2. Сравнить до/после для выявления новых багов
3. Проверить все breakpoints (mobile/tablet/desktop)
4. Проверить темную и светлую темы
5. Исправить любые новые визуальные проблемы

```bash
# MUST run before EVERY commit:
1. pnpm lint              # Code quality
2. pnpm typecheck        # TypeScript validation
3. pnpm test:unit        # Unit tests
4. pnpm build            # Build verification
5. pnpm test:e2e         # Critical paths (if applicable)

# Only commit if ALL tests pass
```

### Commit Message Format with Test Report
```markdown
feat: [description]

Testing Report:
✅ Lint: 0 errors, 0 warnings
✅ TypeScript: No type errors  
✅ Unit tests: 12/12 passed
✅ Build: Successful (42s)
✅ E2E: 3/3 critical paths passed

Fixed during testing:
- [Issue 1 and solution]
- [Issue 2 and solution]

Sprint: SPRINT_001_DEC2025
Task: [Task ID from sprint]
Time spent: Xh Xm
```

### Test Report Storage
```yaml
Location: docs/REPORTS/tests/[DATE].md
Format: Markdown with metrics
Retention: 30 days
Dashboard: docs/index.html#testing
```

## 📊 ДОКУМЕНТАЦИЯ

**Просмотр:** `open docs/index.html` (откроет русскоязычный портал)

**Ключевые файлы:**
- Спринты: docs/SPRINTS/
- Архитектура: docs/ARCHITECTURE.md
- Тестирование: docs/TESTING_PROTOCOL.md

## 🛠 ПРИНЦИПЫ РАЗРАБОТКИ

### 1. Open Source решения
- ТОЛЬКО self-hosted версии (n8n, Supabase, etc.)
- Проверенные библиотеки (>100 звезд на GitHub)
- Никаких SaaS подписок для клиентов

### 2. Оптимизация затрат
- API кэширование обязательно
- Batch обработка данных
- Минимизация внешних запросов
- Выбор самых дешевых провайдеров


## 🔧 COMMANDS

### Development
```bash
# Project navigation
cd corporate-site       # Corporate website
cd master-store        # E-commerce template

# Development
pnpm install           # Install dependencies
pnpm dev              # Start dev server
pnpm build            # Production build
pnpm test             # Run all tests

# Testing (RUN BEFORE EVERY COMMIT)
pnpm test:all         # Complete test suite
pnpm lint             # Code quality
pnpm typecheck        # TypeScript
pnpm test:unit        # Unit tests
pnpm test:e2e         # E2E tests
pnpm lighthouse       # Performance

# Documentation
pnpm docs:serve       # Serve docs locally
pnpm docs:build       # Build docs site
```

### Клонирование магазина
```bash
./scripts/clone-store.sh {client} {domain}
```

## 🤖 MCP СЕРВЕРЫ (Model Context Protocol)

### Активные MCP серверы:
```yaml
FILESYSTEM:
  Статус: ✅ Running
  Описание: Прямой доступ к файловой системе проекта
  Использование: "Используя Filesystem MCP, покажи файлы в /corporate-site"

MEMORY:
  Статус: ✅ Running  
  Описание: Сохранение контекста между сессиями
  Использование: "Используя Memory MCP, запомни что основной цвет #E6A853"

GOOGLE_CLOUD:
  Статус: ⚠️ Требует Service Account
  Описание: Управление GCP (Cloud Run, Storage, DNS)
  Использование: "Используя Google Cloud MCP, покажи статус проекта"

PLAYWRIGHT:
  Статус: ✅ Running
  Описание: Автоматизация браузера и тестирование
  Использование: "Сделай скриншот страницы shop.ede-story.com"

CONTEXT7:
  Статус: ✅ Running
  Описание: Документация библиотек
  Использование: "Найди документацию по Next.js 15"
```

### Правила использования MCP:
1. **ВСЕГДА** используй Filesystem MCP для чтения/записи файлов
2. **ВСЕГДА** используй Memory MCP для сохранения важной информации
3. **НЕ** используй обычные команды Read/Write если есть Filesystem MCP
4. Проверяй статус MCP перед использованием

## 🔄 АВТОМАТИЗАЦИЯ (n8n Self-Hosted)

**Важно:** Используем ТОЛЬКО self-hosted версию n8n на нашем сервере!

**Workflows:**
- Синхронизация товаров: AliExpress → Saleor (каждые 4ч)
- Генерация контента: Claude API → Блог (ежедневно)
- Обработка заказов: Order → Payment → Fulfillment
- Клонирование магазинов: Автоматическое развертывание

## 🚫 NEVER DO
- ❌ Commit without running ALL tests
- ❌ Skip test report in commit message
- ❌ Change brand colors without approval
- ❌ Modify SEO without UPDATE_SEO command
- ❌ Deploy without passing tests
- ❌ Mix corporate and shop code
- ❌ Use proprietary over open source

## ✅ ALWAYS DO
- ✅ Run full test suite before EVERY commit
- ✅ Include test report in commit message
- ✅ Update sprint document daily
- ✅ Check documentation before starting
- ✅ Use appropriate agent context
- ✅ Update metrics dashboard
- ✅ Follow the testing protocol

## 📋 ТЕКУЩИЕ ПРИОРИТЕТЫ

**Неделя 1:** Настройка инфраструктуры
**Неделя 2:** MVP магазина + корп. сайт
**Неделя 3:** Автоматизация + первый клон

## 🏪 ДОМЕНЫ

- **Корпоративный:** www.ede-story.com (Vercel)
- **Магазин:** shop.ede-story.com (Self-hosted VPS)
- **Клиенты:** {client}.ede-story.com (Auto-provisioned)


## 🎯 МЕТРИКИ УСПЕХА

**Технические:** Lighthouse > 90, Тесты > 80%, Deploy < 5 мин
**Бизнес:** Клонирование < 10 мин, 2000 магазинов к 2036

---

**Версия**: 7.0  
**Обновлено**: Январь 2025
**Статус**: АКТИВНЫЙ - Open Source First стратегия
**Важно**: Максимум 500 строк!