# MCP (Model Context Protocol) Guide для Edestory Platform

## 📋 Обзор

MCP (Model Context Protocol) - это протокол для расширения возможностей AI-ассистентов при работе с вашим проектом. Для Edestory Platform настроены специализированные серверы для e-commerce разработки.

## 🚀 Быстрый старт

### 1. Установка

```bash
# Запустите скрипт установки
./scripts/install-mcp.sh

# Скопируйте и настройте переменные окружения
cp .env.mcp.example .env.mcp
# Отредактируйте .env.mcp и добавьте ваши API ключи
```

### 2. Перезапустите Claude Code

После установки перезапустите Claude Code для активации MCP серверов.

## 🛠 Доступные MCP серверы

### Стандартные серверы

#### 1. **Filesystem Server**
- Работа с файловой системой проекта
- Чтение/запись файлов
- Навигация по директориям

#### 2. **GitHub Server**
- Управление репозиторием
- Создание issues и pull requests
- Работа с ветками

#### 3. **PostgreSQL Server**
- Запросы к базе данных Saleor
- Миграции
- Анализ данных

#### 4. **Web Browser Server (Puppeteer)**
- Автоматизация браузера
- E2E тестирование
- Скриншоты

#### 5. **Memory Server**
- Сохранение контекста между сессиями
- Хранение настроек
- Кэширование данных

### Кастомные E-commerce серверы

#### 1. **Saleor Server**
```javascript
// Доступные команды:
- query_products: Поиск товаров
- create_product: Создание товара
- update_inventory: Обновление склада
- get_orders: Получение заказов
```

#### 2. **n8n Server**
```javascript
// Доступные команды:
- trigger_workflow: Запуск workflow
- get_workflows: Список workflows
- get_executions: История выполнений
```

#### 3. **AliExpress Server**
```javascript
// Доступные команды:
- search_products: Поиск товаров
- get_product_details: Детали товара
- import_product: Импорт в магазин
- track_order: Отслеживание заказа
```

## 📝 Примеры использования

### Работа с товарами Saleor

```typescript
// Поиск товаров
const products = await mcp.saleor.query_products({
  search: "smartphone",
  first: 10
});

// Создание товара
const newProduct = await mcp.saleor.create_product({
  name: "iPhone 15 Pro",
  description: "Latest Apple smartphone",
  price: 999.99
});

// Обновление склада
await mcp.saleor.update_inventory({
  productId: "prod_123",
  quantity: 50
});
```

### Автоматизация с n8n

```typescript
// Запуск workflow импорта товаров
await mcp.n8n.trigger_workflow({
  workflowId: "product_import",
  data: {
    source: "aliexpress",
    category: "electronics"
  }
});

// Проверка выполнения
const executions = await mcp.n8n.get_executions({
  workflowId: "product_import"
});
```

### Dropshipping с AliExpress

```typescript
// Поиск товаров на AliExpress
const aliProducts = await mcp.aliexpress.search_products({
  keywords: "wireless earbuds",
  minPrice: 10,
  maxPrice: 50
});

// Импорт товара с наценкой
await mcp.aliexpress.import_product({
  productId: "ali_123456",
  markup: 30 // 30% наценка
});

// Отслеживание заказа
const tracking = await mcp.aliexpress.track_order({
  orderId: "order_789"
});
```

## 🔄 Workflow автоматизации

### 1. Синхронизация товаров (каждые 4 часа)
```yaml
Trigger: Schedule (*/4 * * * *)
Actions:
  1. Fetch products from AliExpress
  2. Update prices in Saleor
  3. Sync inventory levels
  4. Generate SEO descriptions
```

### 2. Обработка заказов
```yaml
Trigger: Saleor webhook (order.created)
Actions:
  1. Create AliExpress order
  2. Send confirmation email
  3. Update inventory
  4. Calculate profit share
```

### 3. Контент-генерация
```yaml
Trigger: Product import
Actions:
  1. Generate description (Claude API)
  2. Create product images (DALL-E)
  3. Translate to ES/EN/RU
  4. Post to social media
```

## 💰 Profit Sharing модель

```javascript
// Автоматический расчёт (20/80)
const profitCalculation = {
  totalRevenue: 1000,      // Общая выручка
  platformFee: 200,        // 20% платформе
  clientShare: 800,        // 80% клиенту
  paymentDate: "2025-02-01"
};
```

## 🧪 Тестирование MCP

```bash
# Запустите тестовый скрипт
./scripts/test-mcp.sh

# Проверка отдельных серверов
npx @modelcontextprotocol/server-filesystem --test
npx @modelcontextprotocol/server-github --test
```

## 🐛 Устранение неполадок

### Проблема: MCP серверы не отвечают

1. Проверьте установку:
```bash
npm list -g | grep @modelcontextprotocol
```

2. Проверьте переменные окружения:
```bash
cat .env.mcp
```

3. Перезапустите Claude Code

### Проблема: Ошибки авторизации

1. Проверьте API ключи в `.env.mcp`
2. Убедитесь, что токены актуальны
3. Проверьте права доступа

### Логи

Логи MCP находятся в:
```bash
~/.config/claude/logs/
```

## 📚 Дополнительные ресурсы

- [MCP Documentation](https://modelcontextprotocol.io/docs)
- [Saleor API Docs](https://docs.saleor.io/docs/3.x/api-reference)
- [n8n Workflow Docs](https://docs.n8n.io)
- [AliExpress API](https://business.aliexpress.com/api)

## 🔒 Безопасность

- Никогда не коммитьте `.env.mcp` в репозиторий
- Используйте отдельные API ключи для разработки и продакшена
- Регулярно обновляйте токены
- Ограничивайте права доступа API ключей

## 📊 Мониторинг

MCP предоставляет метрики:
- Количество API вызовов
- Время ответа серверов
- Ошибки и предупреждения
- Использование ресурсов

---

**Версия**: 1.0.0  
**Обновлено**: Январь 2025  
**Статус**: Активно