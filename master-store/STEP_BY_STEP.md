# 🚀 ПОШАГОВАЯ ИНСТРУКЦИЯ: От нуля до первых продаж

## ✅ Что у вас уже готово:
- Email: **api.edestory@gmail.com** 
- App Password: **afwyjnuobahddxzm**
- Все скрипты автоматизации
- Docker конфигурация

---

## 📋 ШАГ 1: Регистрация в AliExpress Affiliate (5 минут)

### Откройте браузер и перейдите:
🔗 **https://portals.aliexpress.com**

### Нажмите "Join Now" → "Register"

### Заполните форму:
```
Email: api.edestory@gmail.com
Password: AliEx#2025$Shop!  (или придумайте свой)
Confirm Password: (повторите)
Account Type: ✅ Individual (ВАЖНО!)
Country: Spain
✅ I agree to terms
```

### После регистрации заполните профиль:
```
Full Name: [Ваше имя]
Website URL: shop.ede-story.com
Website Type: E-commerce
Monthly Traffic: 10,000 - 50,000
Traffic Sources: 
  ✅ SEO
  ✅ Social Media  
  ✅ Email Marketing
Product Categories:
  ✅ Consumer Electronics
  ✅ Women's Clothing
  ✅ Home & Garden
```

### Подтвердите email
Проверьте **api.edestory@gmail.com** - кликните по ссылке в письме

**⏰ ОЖИДАНИЕ: 1-3 дня на одобрение**

---

## 📋 ШАГ 2: Stripe - настройка платежей (10 минут)

### Создайте аккаунт:
🔗 **https://dashboard.stripe.com/register**

```
Email: api.edestory@gmail.com
Full name: [Ваше имя]
Country: Spain
Password: Stripe#2025$Pay!
```

### После входа активируйте Test Mode:
1. В правом верхнем углу включите переключатель "Test mode"
2. Перейдите: Developers → API keys
3. Скопируйте оба ключа

### Сохраните ключи автоматически:
```bash
cd /Users/vadimarhipov/edestory-platform/master-store
node scripts/save-stripe-keys.js
```
Вставьте скопированные ключи когда попросит

---

## 📋 ШАГ 3: Запустите Docker (2 минуты)

```bash
cd /Users/vadimarhipov/edestory-platform/master-store
docker-compose up -d
```

Проверьте что запустилось:
```bash
docker ps
```

Должны работать:
- postgres
- redis  
- saleor (опционально)
- n8n (опционально)

---

## 📋 ШАГ 4: Запустите магазин (1 минута)

```bash
cd frontend
pnpm install  # если еще не установлено
pnpm dev
```

Откройте в браузере: **http://localhost:3002**

---

## 📋 ШАГ 5: После одобрения AliExpress (через 1-3 дня)

### Получите API ключи:
1. Войдите: https://portals.aliexpress.com
2. Перейдите: App Management
3. Create New App:
   - App Name: **Edestory Shop**
   - Description: **E-commerce platform**
4. Получите:
   - App Key
   - App Secret
   - Tracking ID

### Протестируйте API:
```bash
cd /Users/vadimarhipov/edestory-platform/master-store
node scripts/aliexpress-test.js
```
Введите полученные ключи

### Импортируйте первые товары:
```bash
node scripts/import-products.js
```

---

## 📋 ШАГ 6: Настройте автоматизацию (5 минут)

### Откройте n8n:
http://localhost:5678
- Login: admin
- Password: changeme

### Импортируйте workflows:
1. Settings → Import
2. Выберите файлы:
   - `n8n-workflows/aliexpress-product-sync.json`
   - `n8n-workflows/order-processing.json`

### Добавьте credentials:
1. Credentials → New
2. Создайте:
   - AliExpress API (ваши ключи)
   - SMTP (Gmail с app password)
   - Stripe (тестовые ключи)

### Активируйте workflows

---

## 🎯 БЫСТРЫЕ КОМАНДЫ

### Проверка системы:
```bash
cd /Users/vadimarhipov/edestory-platform/master-store
bash scripts/check-system.sh
```

### Тест email:
```bash
node scripts/test-email.js
```

### После получения AliExpress ключей:
```bash
node scripts/aliexpress-test.js
node scripts/import-products.js
```

### Запуск магазина:
```bash
cd frontend && pnpm dev
```

---

## 📱 ЧЕКЛИСТ

### Сегодня (15 минут):
- [ ] Зарегистрироваться в AliExpress Affiliate
- [ ] Создать Stripe аккаунт
- [ ] Запустить Docker
- [ ] Запустить магазин локально

### Через 1-3 дня (после одобрения):
- [ ] Получить AliExpress API ключи
- [ ] Протестировать API
- [ ] Импортировать товары
- [ ] Настроить n8n автоматизацию

### Через неделю:
- [ ] Первые тестовые заказы
- [ ] Настроить Google Cloud (опционально)
- [ ] Запустить на production

---

## 🆘 ЕСЛИ ЧТО-ТО НЕ РАБОТАЕТ

### Docker не запускается:
```bash
# Проверьте что Docker Desktop запущен
# macOS: откройте Docker из Applications
docker --version
docker-compose --version
```

### Порт занят:
```bash
# Найти процесс на порту 3002
lsof -i :3002
# Убить процесс
kill -9 [PID]
```

### npm/pnpm ошибки:
```bash
# Очистить кэш
pnpm store prune
rm -rf node_modules pnpm-lock.yaml
pnpm install
```

### AliExpress отклонил заявку:
- Убедитесь что выбрали "Individual" а не "Business"
- Укажите реальный сайт
- Подождите 24 часа и попробуйте снова

---

## ✅ ГОТОВО!

После выполнения всех шагов у вас будет:
- 🛍️ Работающий магазин
- 💳 Настроенные платежи (тест)
- 📦 Импорт товаров из AliExpress
- 📧 Email уведомления
- 🤖 Автоматизация через n8n

**Начните с Шага 1 прямо сейчас!**