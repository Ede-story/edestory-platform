# 🚀 Edestory Platform

> B2B платформа для автоматизации dropshipping из Азии в Европу с моделью profit-sharing 20/80

## 📊 Структура проекта

```
edestory-platform/
├── corporate-site/      # 🏢 Корпоративный сайт (www.ede-story.com)
├── master-store/        # 🛍️ Шаблон магазина (shop.ede-story.com)
├── scripts/             # 🔧 Скрипты автоматизации и клонирования
├── docs/               # 📚 Документация
│   ├── SPRINTS/        # Активные спринты обоих проектов
│   └── index.html      # Русскоязычный портал управления
├── n8n-workflows/      # 🔄 Self-hosted n8n конфигурации  
├── mcp-servers/        # 🤖 MCP интеграции
└── CLAUDE.md           # 📋 Инструкции для Claude Code
```

## 🎯 Ключевые особенности

- **Open Source First**: Только self-hosted решения, никаких SaaS подписок
- **Profit Sharing**: 20% платформа / 80% клиент
- **Автоматизация**: 90% процессов без участия человека
- **Масштабирование**: Готовность к 2000+ магазинов к 2036 году

## 🚀 Быстрый старт

### Просмотр документации
```bash
open docs/index.html
```

### Работа с двумя агентами Claude Code

**Чат 1 (CORP_AGENT)** - Корпоративный сайт:
```bash
cd corporate-site
pnpm install
pnpm dev
```

**Чат 2 (SHOP_AGENT)** - Интернет-магазин:
```bash
cd master-store/frontend
pnpm install
pnpm dev
```

## 🛠 Технологический стек

### Корпоративный сайт
- Next.js 14, Tailwind CSS, Framer Motion
- Self-hosted CMS (Strapi/Directus)

### E-commerce магазин
- Saleor 3.19 (e-commerce core)
- Next.js 15, React 19
- PostgreSQL, Redis
- n8n self-hosted для автоматизации

## 📋 Текущие спринты

- **Корп. сайт**: [CORP_SPRINT_001.md](docs/SPRINTS/CORP_SPRINT_001.md)
- **Магазин**: [SHOP_SPRINT_001.md](docs/SPRINTS/SHOP_SPRINT_001.md)

## 🔄 Автоматизация (n8n Self-Hosted)

Все workflows работают на нашем сервере без внешних подписок:
- Синхронизация товаров AliExpress → Saleor
- Генерация контента через Claude API
- Обработка заказов и платежей
- Автоматическое клонирование магазинов

## 📊 Метрики успеха

- **Технические**: Lighthouse > 90, Deploy < 5 мин
- **Бизнес**: Клонирование < 10 мин, 2000 магазинов к 2036

## 🤝 Контакты

- Email: support@ede-story.com
- GitHub: [Ede-story/edestory-platform](https://github.com/Ede-story/edestory-platform)

---

**Версия**: 1.0  
**Обновлено**: Январь 2025  
**Язык общения**: Русский