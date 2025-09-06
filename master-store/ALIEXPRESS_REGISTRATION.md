# 🚀 Регистрация в AliExpress Affiliate - БЕЗ ЮРЛИЦА

## ✅ Что можно без юрлица:
- Получать комиссию 3-8% от продаж
- Использовать API для импорта товаров
- Получать выплаты на PayPal/Payoneer
- Отслеживать заказы и комиссии

## 📋 ШАГ 1: Регистрация (5 минут)

### 1.1 Перейдите по ссылке:
**🔗 https://portals.aliexpress.com/affiportals/web/home.htm**

### 1.2 Нажмите "Join Now" или "Register"

### 1.3 Заполните форму:
```
Email: ваш_email@gmail.com
Password: (создайте сложный пароль)
Account Type: ✅ Individual (НЕ Business!)
Country: Spain
```

### 1.4 Подтвердите email
- Проверьте почту
- Кликните по ссылке подтверждения

## 📋 ШАГ 2: Заполнение профиля

### 2.1 Basic Information:
```
Full Name: Ваше имя
Phone: +34 xxx xxx xxx
Country: Spain
City: Barcelona/Madrid
```

### 2.2 Traffic Source (ВАЖНО!):
```
Website URL: shop.ede-story.com
Monthly Visitors: 10,000-50,000
Traffic Sources:
✅ SEO
✅ Social Media
✅ Email Marketing
✅ Content Marketing

Main Categories:
✅ Fashion & Accessories
✅ Electronics
✅ Home & Garden
✅ Sports & Outdoors
```

### 2.3 Monetization Method:
```
✅ Product Reviews
✅ Price Comparison
✅ Deal Aggregator
✅ Coupon/Cashback
```

## 📋 ШАГ 3: Получение API доступа (после одобрения)

### 3.1 Войдите в личный кабинет:
**🔗 https://portals.aliexpress.com/affiportals/web/account_manage.htm**

### 3.2 Перейдите в App Management:
**🔗 https://portals.aliexpress.com/affiportals/web/appManage.htm**

### 3.3 Создайте новое приложение:
```
App Name: Edestory Shop
App Description: E-commerce platform for Spanish market
Website: shop.ede-story.com
```

### 3.4 Получите ключи:
После одобрения (1-3 дня) вы получите:
- **App Key**: 12345678
- **App Secret**: abcdefghijklmnop
- **Tracking ID**: edestory_shop

## 🤖 АВТОМАТИЗАЦИЯ: Что я сделал для вас

### ✅ Создал 2 автоматических скрипта:

1. **Тестирование API** (`scripts/aliexpress-test.js`)
   - Проверяет работу API ключей
   - Автоматически сохраняет в .env.local
   - Показывает примеры товаров и расчет прибыли

2. **Импорт товаров** (`scripts/import-products.js`)
   - Импортирует горячие товары
   - Рассчитывает оптимальную наценку (30-50%)
   - Генерирует партнерские ссылки
   - Создает товары в Saleor

## 📱 ШАГ 4: После получения ключей (1-3 дня)

### 4.1 Протестируйте API:
```bash
cd master-store
node scripts/aliexpress-test.js
```

Введите полученные ключи когда скрипт попросит:
- App Key: (вставьте ваш ключ)
- App Secret: (вставьте ваш секрет)

### 4.2 Импортируйте первые товары:
```bash
node scripts/import-products.js
```

Скрипт автоматически:
- Найдет горячие товары в 5 категориях
- Отфильтрует по рейтингу >4.5 и комиссии >3%
- Добавит наценку 30-50%
- Создаст товары в вашем магазине

## 💰 РАСЧЕТ ПРИБЫЛИ (без юрлица)

### Пример на реальном товаре:
```
Чехол для iPhone на AliExpress: €10
Наша цена (наценка 50%): €15
Комиссия AliExpress (5%): €0.50
━━━━━━━━━━━━━━━━━━━━━━━━━━
Чистая прибыль: €5.50 (55% маржа!)
```

### При 100 продажах в месяц:
- Выручка: €1,500
- Затраты: €1,000
- Комиссии: €50
- **Чистая прибыль: €550/месяц**

## 🚀 БЫСТРЫЙ СТАРТ

### Команды для копирования:

```bash
# 1. Перейдите в папку проекта
cd /Users/vadimarhipov/edestory-platform/master-store

# 2. После получения ключей (1-3 дня) запустите тест
node scripts/aliexpress-test.js

# 3. Импортируйте товары
node scripts/import-products.js

# 4. Запустите магазин
cd frontend && pnpm dev
```

## 🔄 АВТОМАТИЗАЦИЯ через n8n

После успешного теста API, настройте автоматический импорт:

1. Откройте n8n: http://localhost:5678
2. Импортируйте workflow: `n8n-workflows/aliexpress-product-sync.json`
3. Добавьте ваши API ключи в credentials
4. Активируйте workflow

Товары будут импортироваться каждые 4 часа автоматически!

## ⚠️ ВАЖНЫЕ МОМЕНТЫ

### ✅ Что МОЖНО без юрлица:
- Регистрация как Individual
- Получение API ключей
- Комиссии 3-8%
- Выплаты на PayPal/Payoneer
- Импорт до 10,000 товаров/день

### ❌ Что НЕЛЬЗЯ без юрлица:
- Прямой dropshipping с AliExpress
- Bulk закупки со скидкой
- Priority поддержка
- Кастомная упаковка

## 📞 ПОДДЕРЖКА

### Если отклонили заявку:
1. Проверьте, что выбрали "Individual" а не "Business"
2. Укажите реальный сайт (shop.ede-story.com)
3. Укажите трафик 10,000-50,000 посетителей
4. Подождите 1-3 дня

### Контакты AliExpress:
- Email: affiliate@aliexpress.com
- Chat: В личном кабинете после регистрации

---

**🎯 Итого:** Регистрация займет 5 минут, одобрение 1-3 дня, юрлицо НЕ нужно!