# n8n MCP Integration для Ede Story

## 🎯 Цель интеграции

Интеграция n8n с Claude через MCP (Model Context Protocol) позволяет:
- Создавать и управлять workflow через чат
- Автоматически генерировать промпты и автоматизации
- Мониторить выполнение workflow
- Управлять интеграциями и API

## 🚀 Быстрый старт

### 1. Запуск n8n
```bash
# Запустить n8n
docker-compose -f docker-compose.n8n.yml up -d

# Проверить статус
docker ps | grep n8n

# Открыть интерфейс
open http://localhost:5678
```

**Логин:** admin  
**Пароль:** edestory2025

### 2. Импорт шаблонов workflow

1. Откройте n8n UI: http://localhost:5678
2. Перейдите в Workflows → Import
3. Импортируйте файлы из `n8n-workflows/templates/`

## 📋 Доступные workflow шаблоны

### 1. Lead Generation (01-lead-generation.json)
- Webhook для захвата лидов
- Валидация email
- Сохранение в Google Sheets
- Отправка welcome email
- Создание задачи в CRM

### 2. AliExpress Sync (02-aliexpress-sync.json)
- Синхронизация каждые 4 часа
- Получение товаров из AliExpress
- Трансформация для Saleor
- Автоматическая наценка 30%
- Обновление каталога

### 3. Content Generation (03-content-generation.json)
- Ежедневная генерация контента
- SEO-оптимизация
- Публикация в CMS
- Уведомления команды

## 🤖 Команды для Claude через MCP

### Создание нового workflow
```
Создай workflow для [описание задачи]
```

### Управление существующими workflow
```
Покажи активные workflow
Остановить workflow [название]
Запустить workflow [название]
```

### Генерация промптов
```
Создай промпт для [маркетинговая задача]
```

## 🔧 API Endpoints

### Webhook endpoints
- Lead capture: `http://localhost:5678/webhook/lead-capture`
- Order processing: `http://localhost:5678/webhook/order`
- Customer support: `http://localhost:5678/webhook/support`

### REST API
- Base URL: `http://localhost:5678/api/v1`
- Auth: Basic Auth (admin/edestory2025)

## 📊 Мониторинг

### Просмотр логов
```bash
docker logs edestory-n8n -f
```

### Метрики выполнения
- Успешные выполнения: UI → Executions → Success
- Ошибки: UI → Executions → Error
- Активные workflow: UI → Workflows → Active

## 🔐 Безопасность

### Важные настройки
1. Измените пароли в `.env.n8n` перед продакшн
2. Настройте SSL для webhook
3. Используйте секретные переменные для API ключей
4. Регулярно делайте бэкапы базы данных

### Бэкап данных
```bash
# Бэкап PostgreSQL
docker exec edestory-n8n-postgres pg_dump -U n8n n8n > backup.sql

# Бэкап workflow
cp -r n8n-data/workflows backup-workflows/
```

## 🛠 Troubleshooting

### n8n не запускается
```bash
# Проверить логи
docker logs edestory-n8n

# Перезапустить
docker-compose -f docker-compose.n8n.yml restart
```

### Ошибки подключения к БД
```bash
# Проверить PostgreSQL
docker exec edestory-n8n-postgres pg_isready

# Пересоздать БД
docker-compose -f docker-compose.n8n.yml down -v
docker-compose -f docker-compose.n8n.yml up -d
```

## 📚 Полезные ресурсы

- [n8n Documentation](https://docs.n8n.io)
- [Workflow Templates](https://n8n.io/workflows)
- [Community Forum](https://community.n8n.io)
- [API Reference](https://docs.n8n.io/api/)

## 🎯 Следующие шаги

1. ✅ Настроить API ключи в `.env.n8n`
2. ✅ Импортировать и протестировать workflow
3. ✅ Настроить webhook для вашего домена
4. ✅ Создать кастомные workflow для ваших задач
5. ✅ Интегрировать с Saleor и другими сервисами

---

**Версия:** 1.0  
**Обновлено:** Январь 2025  
**Поддержка:** team@ede-story.com