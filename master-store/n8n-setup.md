# n8n Self-Hosted Setup для Edestory Shop

## 🎯 Важно: Self-Hosted версия
Используем **ТОЛЬКО self-hosted** версию n8n для экономии и контроля данных

## 1. Запуск n8n через Docker

```bash
# Из директории master-store
docker-compose up -d n8n

# n8n будет доступен на http://localhost:5678
# Login: admin / Password: changeme
```

## 2. Настройка переменных окружения

В n8n interface перейдите в Settings → Environment Variables:

```env
# AliExpress
ALIEXPRESS_APP_KEY=your_key
ALIEXPRESS_APP_SECRET=your_secret
ALIEXPRESS_TRACKING_ID=your_tracking_id

# Saleor
SALEOR_API_URL=http://localhost:8000/graphql/
SALEOR_ADMIN_TOKEN=your_token

# Stripe
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Email (используем SendGrid Free Tier - 100 emails/day)
SENDGRID_API_KEY=your_sendgrid_key
EMAIL_FROM=orders@shop.ede-story.com

# Telegram (optional, для уведомлений)
TELEGRAM_BOT_TOKEN=your_bot_token
TELEGRAM_CHAT_ID=your_chat_id

# Google Sheets (для отчетов)
GOOGLE_SHEET_ID=your_sheet_id
```

## 3. Импорт Workflows

### Через UI:
1. Settings → Workflows
2. Import from File
3. Выберите файлы из `/n8n-workflows/`

### Через CLI:
```bash
# Импорт всех workflows
docker exec -it edestory-n8n n8n import:workflow \
  --input=/home/node/.n8n/workflows/
```

## 4. Основные Workflows

### 📦 Product Sync (каждые 4 часа)
- **Файл:** `aliexpress-product-sync.json`
- **Функция:** Импорт горячих товаров из AliExpress
- **Фильтры:**
  - Минимальная цена: €10
  - Комиссия: >5%
  - Рейтинг: >4.5
- **Наценка:** 30-50% в зависимости от цены

### 🛒 Order Processing (real-time)
- **Файл:** `order-processing.json`
- **Функция:** Обработка новых заказов
- **Действия:**
  - Проверка оплаты
  - Создание заказа на AliExpress
  - Email клиенту
  - Расчет profit sharing
  - Логирование в Google Sheets

### 🤖 Content Factory (ежедневно)
- **Файл:** `content-factory.json`
- **Функция:** AI генерация контента
- **Действия:**
  - Генерация описаний через Claude API
  - SEO оптимизация
  - Перевод на ES/EN/RU
  - Обновление в Saleor

### 📊 Sales Reporter (еженедельно)
- **Файл:** `sales-reporter.json` 
- **Функция:** Отчеты о продажах
- **Метрики:**
  - Общая выручка
  - Profit sharing (20/80)
  - Топ товары
  - Конверсия

## 5. Webhooks Setup

### Saleor → n8n
```graphql
mutation CreateWebhook {
  webhookCreate(input: {
    name: "n8n Order Processor"
    targetUrl: "http://localhost:5678/webhook/order-webhook"
    events: [ORDER_CREATED, ORDER_FULLY_PAID]
    isActive: true
  }) {
    webhook {
      id
      secretKey
    }
  }
}
```

### Stripe → n8n
```bash
# Используем Stripe CLI для локальной разработки
stripe listen --forward-to localhost:5678/webhook/stripe-webhook
```

## 6. Credentials Setup

### AliExpress API
1. Workflows → Credentials → New
2. Type: HTTP Header Auth
3. Name: AliExpress API
4. Header Name: `X-API-KEY`
5. Header Value: Your API Key

### Saleor GraphQL
1. Type: HTTP Header Auth
2. Name: Saleor API
3. Header Name: `Authorization`
4. Header Value: `Bearer YOUR_TOKEN`

### SendGrid Email
1. Type: SendGrid API
2. API Key: Your SendGrid Key

## 7. Мониторинг и отладка

### Просмотр выполнений
- Workflows → Executions
- Фильтр по статусу: Success/Error/Running

### Логирование
```bash
# Просмотр логов n8n
docker logs -f edestory-n8n

# Просмотр объема данных
docker exec edestory-n8n du -sh /home/node/.n8n
```

### Бэкапы
```bash
# Backup всех workflows и credentials
docker exec edestory-n8n n8n export:workflow --all \
  --output=/backup/workflows.json

docker exec edestory-n8n n8n export:credentials --all \
  --output=/backup/credentials.json
```

## 8. Оптимизация производительности

### Настройки для production
```env
# В docker-compose.yml
N8N_METRICS=true
EXECUTIONS_DATA_PRUNE=true
EXECUTIONS_DATA_MAX_AGE=168  # 7 дней
N8N_PAYLOAD_SIZE_MAX=16
GENERIC_TIMEZONE=Europe/Madrid
```

### Ограничения
- Max execution time: 5 минут
- Max payload size: 16MB
- Concurrent executions: 10

## 9. Интеграция с Google Cloud

### Используем бесплатные квоты
- Cloud Functions: 2M вызовов/месяц бесплатно
- Cloud Scheduler: 3 задачи бесплатно
- Cloud Logging: 50GB/месяц бесплатно

### Deployment на GCP
```yaml
# cloud-function.yaml
runtime: nodejs18
entryPoint: n8nWebhook
memoryMB: 256
timeout: 300s
environmentVariables:
  N8N_WEBHOOK_URL: https://your-function.cloudfunctions.net
```

## 10. Безопасность

### Защита n8n
```nginx
# nginx.conf для reverse proxy
location /n8n/ {
    proxy_pass http://localhost:5678/;
    auth_basic "n8n Admin";
    auth_basic_user_file /etc/nginx/.htpasswd;
    
    # Rate limiting
    limit_req zone=n8n burst=10;
}
```

### Webhook валидация
```javascript
// Проверка подписи webhook
const crypto = require('crypto');

function validateWebhook(payload, signature, secret) {
  const hash = crypto
    .createHmac('sha256', secret)
    .update(payload)
    .digest('hex');
  return hash === signature;
}
```

## 📊 KPI и метрики

### Что отслеживаем
- Успешность импорта: >95%
- Время обработки заказа: <30 сек
- Email delivery rate: >98%
- API errors: <1%

### Dashboard в n8n
Settings → Metrics → Enable
Доступен на: http://localhost:5678/metrics

---

**Статус:** Готово к запуску
**Требуется:** Docker, 2GB RAM минимум
**Поддержка:** docs.n8n.io