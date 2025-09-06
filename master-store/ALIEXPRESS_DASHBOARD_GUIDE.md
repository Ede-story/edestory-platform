# 📱 Настройка AliExpress Affiliate Dashboard

## После входа в личный кабинет

### 1️⃣ Первый вход - Заполните профиль

Ищите разделы (могут быть на английском или китайском):

**Account Settings / Profile / 账户设置**

Заполните:
```
Account Type: Individual / 个人
Full Name: [Ваше имя]
Country: Spain / 西班牙
City: Barcelona/Madrid
Phone: +34 xxx xxx xxx (можно пропустить)
```

### 2️⃣ Настройте источники трафика

**Traffic Source / Media Management / 流量来源**

Добавьте ваш сайт:
```
Media Type: Website/Blog
Website Name: Edestory Shop
Website URL: https://shop.ede-story.com
Description: E-commerce dropshipping platform for Spanish market
Monthly Visitors: 10,000-50,000
Categories: 
  ✅ Consumer Electronics / 消费电子
  ✅ Women's Clothing / 女装
  ✅ Home & Garden / 家居园艺
  ✅ Phone Accessories / 手机配件
  ✅ Men's Clothing / 男装
```

### 3️⃣ Создайте App для API доступа

**App Management / API Center / 应用管理**

Нажмите "Create App" / "创建应用" и заполните:
```
App Name: Edestory Shop API
App Type: Website
Description: Automated product import for e-commerce
Website URL: https://shop.ede-story.com
Callback URL: https://shop.ede-story.com/callback (необязательно)
```

### 4️⃣ После создания App получите ключи

В разделе App Management вы увидите:
- **App Key:** 12345678 (8 цифр)
- **App Secret:** abcdef123456... (длинная строка)
- **Tracking ID:** edestory (или автоматически сгенерированный)

## 🔍 Если не можете найти нужные разделы

### Возможные названия меню:

**Английский:**
- Dashboard / Home
- Account Management
- Profile Settings
- Media Management
- Traffic Source
- App Management
- API Center
- Create App
- My Apps

**Китайский (может быть):**
- 仪表板
- 账户管理
- 个人资料
- 媒体管理
- 流量来源
- 应用管理
- API中心

**Русский (иногда):**
- Панель управления
- Управление аккаунтом
- Профиль
- Управление медиа
- Источники трафика
- Управление приложениями

## 📊 Статусы заявки

После заполнения профиля ваш статус может быть:

- **Pending / В ожидании** - ждите 1-3 дня
- **Under Review / На рассмотрении** - проверяют данные
- **Approved / Одобрено** - можно работать!
- **Rejected / Отклонено** - нужно исправить данные

## ⚠️ Частые проблемы и решения

### Проблема: Не вижу меню App Management

**Решение:** Ваш аккаунт еще не одобрен. Дождитесь письма с подтверждением (1-3 дня).

### Проблема: Страница загружается с ошибками

**Решение:** 
1. Используйте Chrome
2. Отключите VPN если используете
3. Очистите куки для aliexpress.com

### Проблема: Не могу создать App

**Решение:** Сначала нужно заполнить профиль и дождаться одобрения аккаунта.

## 📧 Проверьте email

На **api.edestory@gmail.com** должны прийти письма:
1. Подтверждение регистрации
2. Статус рассмотрения заявки (через 1-3 дня)
3. Одобрение и инструкции

## 🎯 Что делать после одобрения

Как только получите письмо об одобрении:

1. Войдите в кабинет
2. Создайте App
3. Получите API ключи
4. Запустите тест:

```bash
cd /Users/vadimarhipov/edestory-platform/master-store
node scripts/aliexpress-test.js
```

Введите полученные ключи и всё заработает!