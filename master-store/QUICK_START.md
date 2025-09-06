# 🚀 Quick Start - Edestory Shop

## ✅ Что уже настроено (без юрлица)

### 1. **Stripe Test Mode** ✅
- Тестовые ключи добавлены в `.env.local`
- Интеграция готова в `src/lib/stripe.ts`
- Документация: `stripe-setup.md`

### 2. **AliExpress Affiliate API** ✅  
- Сервис API создан в `src/services/aliexpress-api.ts`
- Требуется регистрация на portals.aliexpress.com (1-3 дня)
- Документация: `aliexpress-setup.md`

### 3. **n8n Workflows** ✅
- Product sync: `n8n-workflows/aliexpress-product-sync.json`
- Order processing: `n8n-workflows/order-processing.json`
- Документация: `n8n-setup.md`

### 4. **Vercel Deployment** ✅
- Конфигурация: `vercel.json`
- Deploy скрипт: `scripts/deploy.sh`
- Документация: `vercel-deployment.md`

## 🎯 Запуск за 5 минут

### Шаг 1: Запустить Docker сервисы
```bash
cd master-store
docker-compose up -d
```

Проверьте:
- Saleor API: http://localhost:8000/graphql/
- n8n: http://localhost:5678 (admin/changeme)

### Шаг 2: Запустить frontend
```bash
cd frontend
pnpm install
pnpm dev
```

Магазин доступен: http://localhost:3002/default-channel

### Шаг 3: Настроить тестовые данные
```bash
# Создать суперпользователя Saleor
docker exec -it edestory-saleor python manage.py createsuperuser

# Email: admin@ede-story.com
# Password: выберите сложный пароль
```

## 📝 Следующие шаги (по приоритету)

### 1. Регистрация в AliExpress Affiliate (1-3 дня)
1. Зайдите на https://portals.aliexpress.com
2. Регистрируйтесь как Individual
3. Укажите сайт: shop.ede-story.com
4. После одобрения получите API ключи

### 2. Создание Stripe аккаунта (15 минут)
1. Регистрация на https://stripe.com
2. Активируйте Test Mode
3. Получите тестовые ключи из Dashboard
4. Обновите `.env.local`

### 3. Настройка Vercel (30 минут)
```bash
# Установить Vercel CLI
npm i -g vercel

# Деплой preview версии
cd frontend
vercel

# Production деплой (когда готовы)
vercel --prod
```

### 4. Импорт n8n workflows (10 минут)
1. Откройте n8n: http://localhost:5678
2. Settings → Workflows → Import
3. Импортируйте файлы из `/n8n-workflows/`
4. Настройте credentials для API

## 🧪 Тестирование

### Тестовые карты Stripe:
- ✅ Успешная: `4242 4242 4242 4242`
- 🔒 3D Secure: `4000 0025 0000 3155`
- ❌ Отклоненная: `4000 0000 0000 9995`

### Проверка интеграций:
```bash
# Stripe webhook test
stripe listen --forward-to localhost:3002/api/webhook/stripe

# AliExpress API test (после получения ключей)
curl -X POST http://localhost:3002/api/aliexpress/test
```

## 💰 Бизнес-модель (работает без юрлица)

### Affiliate комиссии:
- AliExpress платит 3-8% комиссии
- Наценка на товары 30-50%
- Итоговая маржа: 33-58%

### Пример расчета:
```
Товар на AliExpress: €20
Наша цена: €30 (50% наценка)
Комиссия от AliExpress: €0.60-1.60
Чистая прибыль: €10.60-11.60 на товар
```

## 🔥 Production Checklist

Когда будет юрлицо:

- [ ] Stripe production keys
- [ ] AliExpress business account  
- [ ] Домен shop.ede-story.com на Vercel
- [ ] SSL сертификат (автоматически от Vercel)
- [ ] Google Analytics
- [ ] Email provider (SendGrid)
- [ ] Backup стратегия
- [ ] Мониторинг (Sentry)

## 📞 Поддержка

### Документация:
- `/docs/` - вся документация проекта
- `/docs/SPRINTS/SHOP_SPRINT_001.md` - текущий спринт

### Команды:
```bash
pnpm dev        # Разработка
pnpm build      # Сборка
pnpm test       # Тесты
pnpm deploy     # Деплой на Vercel
```

---

**Готово к разработке!** 🎉
Все критические компоненты настроены для работы без юрлица.
Можете начинать импорт товаров и тестирование checkout процесса.