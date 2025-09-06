# Master Store - B2B Dropshipping Platform

## Быстрый старт

### 1. Установка зависимостей
```bash
cd master-store
npm install
```

### 2. Настройка окружения
```bash
cp .env.example .env
# Отредактируйте .env и добавьте ваши API ключи
```

### 3. Запуск сервисов
```bash
# Запуск Docker контейнеров (Saleor, PostgreSQL, Redis, n8n)
docker-compose up -d

# Инициализация базы данных Saleor
docker exec -it edestory-saleor python manage.py migrate
docker exec -it edestory-saleor python manage.py createsuperuser

# Запуск frontend
cd frontend
npm run dev
```

### 4. Доступ к сервисам
- Frontend: http://localhost:3000
- Saleor API: http://localhost:8000/graphql/
- Saleor Admin: http://localhost:8000/dashboard/
- n8n Automation: http://localhost:5678

## Клонирование для нового клиента

```bash
./scripts/clone-store.sh <client-name> <domain>
```

Пример:
```bash
./scripts/clone-store.sh alibaba-shop shop.alibaba.com
```

## Структура проекта

```
master-store/
├── frontend/          # Next.js storefront
├── backend/          # Saleor расширения
├── docker/           # Docker конфигурации
├── scripts/          # Утилиты и скрипты
└── integrations/     # AliExpress, платежи
```

## Profit Sharing

- **20%** - наша комиссия
- **80%** - производителю

Автоматический расчет через Stripe Connect

## Интеграции

### AliExpress
- Автоимпорт товаров
- Отслеживание заказов
- Синхронизация остатков

### n8n Workflows
- Генерация контента через AI
- Email маркетинг
- Отчеты о продажах
- SEO оптимизация

## Поддержка

Документация: `/docs`
Issues: GitHub Issues