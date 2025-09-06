# 📱 Instagram Trend Watching Agent - Руководство

## 🎯 Что делает агент

Автоматический агент для анализа Instagram конкурентов, который:
- Анализирует любой Instagram аккаунт по ссылке
- Находит топ-100 конкурентов в 4 регионах (США, UK, Европа, Россия)
- Отслеживает тренды: хештеги, типы контента, время публикаций
- Определяет быстрорастущие аккаунты
- Генерирует подробные отчеты с рекомендациями

## 🚀 Быстрый старт

### 1. Настройка API ключей

Добавьте в файл `.env.n8n`:
```env
# Вариант 1: Apify (рекомендуется)
APIFY_TOKEN=your_apify_token_here

# Вариант 2: RapidAPI
RAPIDAPI_KEY=your_rapidapi_key_here

# Email для отчетов
EMAIL_FROM=reports@ede-story.com
DEFAULT_REPORT_EMAIL=your@email.com
```

### 2. Создание базы данных

```bash
# Подключитесь к PostgreSQL контейнеру
docker exec -it edestory-n8n-postgres psql -U n8n

# Выполните SQL из файла
\i /path/to/database-schema.sql
```

### 3. Импорт workflow в n8n

1. Откройте n8n: http://localhost:5678
2. Workflows → Import from File
3. Выберите один из файлов:
   - `instagram-competitor-analysis.json` (Apify метод)
   - `alternative-instagram-scraper.json` (RapidAPI метод)

### 4. Настройка credentials в n8n

1. Settings → Credentials → Add Credential
2. Добавьте необходимые:
   - PostgreSQL (уже настроен)
   - HTTP Header Auth для API
   - SMTP для email отчетов

## 📊 Как использовать

### Запуск анализа через webhook

```bash
curl -X POST http://localhost:5678/webhook/analyze-competitor \
  -H "Content-Type: application/json" \
  -d '{
    "instagram_url": "https://instagram.com/nike",
    "recipient_email": "marketing@company.com"
  }'
```

### Запуск через n8n UI

1. Откройте workflow
2. Нажмите "Execute Workflow"
3. В Test Webhook введите:
```json
{
  "instagram_url": "https://instagram.com/[username]",
  "recipient_email": "your@email.com"
}
```

## 📈 Что вы получите

### 1. Email отчет включает:
- **Топ-100 глобальных конкурентов** с метриками
- **Топ-25 по каждому региону** (США, UK, EU, РФ)
- **Трендовые хештеги** с частотой использования
- **Типы контента** которые работают лучше
- **Быстрорастущие аккаунты** для изучения
- **Персонализированные рекомендации**

### 2. Данные в базе:
- Полная история всех анализов
- Метрики роста конкурентов
- База хештегов и трендов
- Исторические данные для аналитики

## 🔍 Примеры использования

### 1. Анализ конкурента в fashion
```json
{
  "instagram_url": "https://instagram.com/zara",
  "analysis_type": "deep",
  "focus_regions": ["USA", "EU"]
}
```

### 2. Поиск микро-инфлюенсеров
```json
{
  "instagram_url": "https://instagram.com/fitness_brand",
  "min_followers": 10000,
  "max_followers": 100000,
  "engagement_rate_min": 3
}
```

### 3. Мониторинг трендов в нише
```json
{
  "instagram_url": "https://instagram.com/tech_startup",
  "track_hashtags": true,
  "track_content_types": true,
  "period": "weekly"
}
```

## 📊 SQL запросы для аналитики

### Топ конкурентов по региону
```sql
SELECT username, followers_count, engagement_rate, profile_url
FROM competitors
WHERE detected_region = 'USA'
  AND is_active = TRUE
ORDER BY relevance_score DESC
LIMIT 25;
```

### Трендовые хештеги за неделю
```sql
SELECT h.hashtag, COUNT(ch.competitor_id) as usage_count
FROM hashtags h
JOIN competitor_hashtags ch ON h.id = ch.hashtag_id
WHERE ch.last_used > NOW() - INTERVAL '7 days'
GROUP BY h.hashtag
ORDER BY usage_count DESC
LIMIT 20;
```

### Быстрорастущие аккаунты
```sql
SELECT 
  c.username,
  c.followers_count as current,
  cmh.followers_change_percent as growth
FROM competitors c
JOIN competitor_metrics_history cmh ON c.id = cmh.competitor_id
WHERE cmh.snapshot_date > NOW() - INTERVAL '30 days'
  AND cmh.followers_change_percent > 10
ORDER BY cmh.followers_change_percent DESC
LIMIT 10;
```

## 🔧 Настройки и параметры

### Параметры анализа
```javascript
{
  // Основные
  "instagram_url": "string",        // Обязательно
  "recipient_email": "string",      // Email для отчета
  
  // Фильтры
  "regions": ["USA", "UK", "EU", "RU"], // Регионы для анализа
  "max_competitors": 100,           // Максимум конкурентов
  "min_followers": 1000,            // Минимум подписчиков
  "max_followers": 10000000,        // Максимум подписчиков
  
  // Глубина анализа
  "analysis_depth": "deep",          // "shallow" или "deep"
  "include_posts": true,            // Анализировать посты
  "include_hashtags": true,         // Собирать хештеги
  "include_growth": true            // Отслеживать рост
}
```

## 🚨 Лимиты и ограничения

### API лимиты
- **Apify Free**: 100 запросов/месяц
- **RapidAPI Free**: 500 запросов/месяц
- **Рекомендуется**: 1 анализ в час максимум

### Обход ограничений
1. Используйте кэширование результатов
2. Анализируйте только новых конкурентов
3. Обновляйте данные раз в неделю
4. Используйте несколько API ключей

## 📱 Автоматизация

### Еженедельный мониторинг
1. Создайте Schedule Trigger в n8n
2. Установите запуск каждый понедельник
3. Анализируйте топ-10 ваших конкурентов
4. Получайте сводку изменений

### Уведомления о трендах
1. Настройте trigger на новые хештеги
2. Отслеживайте резкий рост конкурентов
3. Получайте alerts в Telegram/Slack

## 🛠 Troubleshooting

### Проблема: "Rate limit exceeded"
**Решение**: Уменьшите количество конкурентов или добавьте задержки

### Проблема: "Invalid Instagram URL"
**Решение**: Используйте формат `https://instagram.com/username`

### Проблема: "No competitors found"
**Решение**: Проверьте, что аккаунт публичный и имеет подписчиков

## 📞 Поддержка

- **Документация n8n**: https://docs.n8n.io
- **Instagram API docs**: https://developers.facebook.com/docs/instagram-api
- **Вопросы**: Спросите меня через чат!

---

**💡 Совет**: Начните с анализа одного конкурента, затем масштабируйте на всю нишу!