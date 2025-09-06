# Stripe Test Mode Setup для Edestory Shop

## 1. Stripe Test Keys
Для работы в тестовом режиме не требуется юрлицо. Вы можете:
- Создать аккаунт на stripe.com с любым email
- Использовать тестовые ключи для разработки
- Тестировать весь checkout процесс с тестовыми картами

## 2. Тестовые переменные окружения
```env
# Stripe Test Mode (начинаются с pk_test_ и sk_test_)
STRIPE_SECRET_KEY=sk_test_...
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Saleor Payment App
PAYMENT_APP_URL=http://localhost:3003
```

## 3. Тестовые карты Stripe
```
Успешный платеж: 4242 4242 4242 4242
Требует 3D Secure: 4000 0025 0000 3155
Отклоненная карта: 4000 0000 0000 9995
```

## 4. Интеграция с Saleor

### Установка Saleor Payment App
```bash
# Клонируем официальный Saleor payment app
git clone https://github.com/saleor/saleor-app-payment.git
cd saleor-app-payment

# Устанавливаем зависимости
pnpm install

# Конфигурируем Stripe
cp .env.example .env
# Добавьте ваши тестовые ключи Stripe в .env
```

### Настройка webhook в Saleor
```graphql
mutation {
  webhookCreate(input: {
    name: "Stripe Payment"
    targetUrl: "http://localhost:3003/api/webhooks/stripe"
    events: [CHECKOUT_CREATED, PAYMENT_AUTHORIZE, PAYMENT_CAPTURE]
    isActive: true
  }) {
    webhook {
      id
      name
    }
  }
}
```

## 5. Конфигурация в коде

### frontend/lib/stripe.ts
```typescript
import { loadStripe } from '@stripe/stripe-js';

export const stripePromise = loadStripe(
  process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY!
);
```

### frontend/components/checkout/payment.tsx
```typescript
import { Elements } from '@stripe/react-stripe-js';
import { stripePromise } from '@/lib/stripe';

export function PaymentForm() {
  return (
    <Elements stripe={stripePromise}>
      {/* Ваш компонент оплаты */}
    </Elements>
  );
}
```

## 6. Автоматизация через n8n

### Webhook для обработки платежей
```json
{
  "nodes": [
    {
      "name": "Stripe Webhook",
      "type": "n8n-nodes-base.webhook",
      "webhookId": "stripe-payment",
      "parameters": {
        "httpMethod": "POST",
        "path": "stripe-payment"
      }
    },
    {
      "name": "Process Payment",
      "type": "n8n-nodes-base.function",
      "parameters": {
        "functionCode": "// Обработка платежа\nconst event = items[0].json;\nif (event.type === 'payment_intent.succeeded') {\n  // Обновляем статус заказа в Saleor\n  return [{json: {status: 'paid'}}];\n}"
      }
    }
  ]
}
```

## 7. Команды для запуска

```bash
# Terminal 1: Saleor backend
cd master-store
docker-compose up -d

# Terminal 2: Payment app
cd saleor-app-payment
pnpm dev # Запустится на порту 3003

# Terminal 3: Frontend
cd master-store/frontend
pnpm dev # Запустится на порту 3002

# Terminal 4: Stripe CLI для webhook testing
stripe listen --forward-to localhost:3003/api/webhooks/stripe
```

## 8. Что можно тестировать без юрлица
✅ Полный checkout процесс
✅ Обработка платежей (тестовые карты)
✅ Webhooks и уведомления
✅ Refunds и возвраты
✅ Подписки и recurring payments
✅ 3D Secure аутентификация
✅ Все payment methods (карты, SEPA, etc.)

## 9. Переход на Production
Когда будет готово юрлицо:
1. Зарегистрировать компанию в Stripe
2. Пройти верификацию бизнеса
3. Заменить test keys на production keys
4. Обновить webhook endpoints
5. Протестировать с реальными картами

---
**Статус:** Готово к реализации в Test Mode
**Блокеры:** Нет (юрлицо НЕ требуется для разработки)