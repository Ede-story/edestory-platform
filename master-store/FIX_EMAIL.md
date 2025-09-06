# 🔧 Исправление проблемы с отправкой Email

## Проблема:
Google блокирует вход с паролем приложения. Ошибка:
```
Invalid login: 535-5.7.8 Username and Password not accepted
```

## Решение:

### Вариант 1: Создайте новый App Password (рекомендуется)

1. **Войдите в Google Account:**
   https://myaccount.google.com/

2. **Включите 2FA (если еще не включена):**
   - Security → 2-Step Verification → Turn On

3. **Создайте App Password:**
   https://myaccount.google.com/apppasswords
   
   - Выберите: "Mail" 
   - Имя: "Edestory Shop"
   - Скопируйте новый 16-символьный пароль

4. **Обновите пароль:**
   ```bash
   cd /Users/vadimarhipov/edestory-platform/master-store
   node scripts/save-smtp-password.js
   ```
   Вставьте новый пароль БЕЗ пробелов

### Вариант 2: Используйте другой email сервис

#### SendGrid (рекомендуется для production)
```bash
# Регистрация: https://sendgrid.com
# Бесплатно: 100 писем/день

# После регистрации обновите .env.local:
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USER=apikey
SMTP_PASSWORD=[ваш_sendgrid_api_key]
```

#### Mailgun
```bash
# Регистрация: https://mailgun.com
# Бесплатно: 5000 писем/месяц

SMTP_HOST=smtp.mailgun.org
SMTP_PORT=587
SMTP_USER=[ваш_mailgun_user]
SMTP_PASSWORD=[ваш_mailgun_password]
```

### Вариант 3: Проверьте настройки Gmail

1. **Разрешите доступ:**
   https://myaccount.google.com/lesssecureapps
   
   ⚠️ НЕ рекомендуется для безопасности

2. **Разблокируйте CAPTCHA:**
   https://accounts.google.com/DisplayUnlockCaptcha
   
   Нажмите "Continue"

3. **Проверьте активность:**
   https://myaccount.google.com/notifications
   
   Подтвердите что это были вы

## Тестирование после исправления:

```bash
cd /Users/vadimarhipov/edestory-platform/master-store
node scripts/test-email.js
```

Должны увидеть:
```
✅ Welcome Email отправлен!
✅ Order Confirmation отправлен!
✅ Commission Notification отправлен!
```

## Альтернатива: Временно отключите email

Если срочно нужно продолжить работу без email:

```bash
# В frontend/.env.local добавьте:
EMAIL_ENABLED=false

# Это отключит отправку, но позволит работать остальному функционалу
```

---

**Важно:** App Password - это НЕ ваш обычный пароль от Gmail! Это специальный 16-символьный код для приложений.