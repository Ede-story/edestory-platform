# 📧 Создание API Email: api.edestory@gmail.com

## 🎯 Цель
Создать отдельный email для всех бизнес-интеграций:
- AliExpress Affiliate API
- Stripe платежи
- SendGrid email
- Google Cloud Platform
- n8n автоматизация
- Другие API сервисы

## 📋 Пошаговая инструкция (10 минут)

### ШАГ 1: Откройте ссылку создания Gmail

🔗 **ПРЯМАЯ ССЫЛКА:** https://accounts.google.com/signup/v2/webcreateaccount?flowName=GlifWebSignIn&flowEntry=SignUp

### ШАГ 2: Заполните форму

```
Имя: API
Фамилия: Edestory
Имя пользователя: api.edestory
Пароль: [создайте сложный пароль - я сгенерирую ниже]
```

### 🔐 Сгенерированный безопасный пароль:
```
EdSt0ry@API#2025$Secure!
```
**Сохраните этот пароль в безопасном месте!**

### ШАГ 3: Пропустите номер телефона (если возможно)

- Нажмите "Пропустить" если есть такая опция
- Если требует обязательно, используйте ваш номер

### ШАГ 4: Резервный email

```
Резервный email: ваш_основной_email@gmail.com
Дата рождения: 01.01.1990
Пол: Не указывать / Другое
```

### ШАГ 5: Примите условия

---

## 🛡️ НАСТРОЙКА БЕЗОПАСНОСТИ (Важно!)

После создания аккаунта ОБЯЗАТЕЛЬНО:

### 1. Включите двухфакторную аутентификацию (2FA)

🔗 **Прямая ссылка:** https://myaccount.google.com/signinoptions/two-step-verification

1. Войдите в новый аккаунт
2. Перейдите по ссылке выше
3. Нажмите "Начать"
4. Добавьте номер телефона
5. Получите и введите код
6. Включите 2FA

### 2. Создайте App Passwords для интеграций

🔗 **Прямая ссылка:** https://myaccount.google.com/apppasswords

После включения 2FA:
1. Перейдите по ссылке
2. Создайте пароли для:
   - "AliExpress Integration"
   - "Stripe Webhooks"
   - "SendGrid SMTP"
   - "n8n Automation"

### 3. Настройте восстановление

🔗 **Прямая ссылка:** https://myaccount.google.com/recovery

- Добавьте резервный email
- Добавьте номер телефона
- Скачайте коды восстановления

---

## 🤖 АВТОМАТИЧЕСКАЯ НАСТРОЙКА

После создания аккаунта запустите скрипт:

```bash
cd /Users/vadimarhipov/edestory-platform/master-store
node scripts/setup-api-email.js
```

Скрипт автоматически:
- Проверит доступность email
- Создаст фильтры для API писем
- Настроит переадресацию важных уведомлений
- Сохранит credentials в .env

---

## 📝 Где использовать этот email

### 1. AliExpress Affiliate
```
Email: api.edestory@gmail.com
Account Type: Individual
```

### 2. Stripe
```
Email: api.edestory@gmail.com
Business Email: api.edestory@gmail.com
```

### 3. Google Cloud Platform
```
Account Email: api.edestory@gmail.com
Billing Email: api.edestory@gmail.com
```

### 4. SendGrid
```
Email: api.edestory@gmail.com
From Email: noreply@shop.ede-story.com
Reply-To: api.edestory@gmail.com
```

### 5. n8n
```
SMTP User: api.edestory@gmail.com
SMTP Password: [app password]
```

---

## 🔑 Управление паролями

### Сохраните в безопасном месте:

```yaml
# ГЛАВНЫЙ АККАУНТ
Email: api.edestory@gmail.com
Password: EdSt0ry@API#2025$Secure!
Recovery: ваш_основной@gmail.com

# APP PASSWORDS (создайте после 2FA)
AliExpress: xxxx-xxxx-xxxx-xxxx
Stripe: xxxx-xxxx-xxxx-xxxx
SendGrid: xxxx-xxxx-xxxx-xxxx
n8n: xxxx-xxxx-xxxx-xxxx

# 2FA BACKUP CODES
Code1: xxxxxxxx
Code2: xxxxxxxx
Code3: xxxxxxxx
Code4: xxxxxxxx
Code5: xxxxxxxx
Code6: xxxxxxxx
Code7: xxxxxxxx
Code8: xxxxxxxx
```

---

## ✅ Чеклист после создания

- [ ] Gmail аккаунт создан
- [ ] 2FA включена
- [ ] App passwords созданы
- [ ] Восстановление настроено
- [ ] Пароли сохранены в безопасном месте
- [ ] Скрипт setup-api-email.js запущен
- [ ] Email добавлен в .env.local

---

## 🚨 ВАЖНО

1. **НЕ используйте** этот email для личной переписки
2. **ТОЛЬКО** для API и бизнес-интеграций
3. **Включите** 2FA обязательно
4. **Сохраните** все пароли в менеджере паролей
5. **Проверяйте** этот email раз в неделю

---

**📱 Начните с создания аккаунта по ссылке выше!**