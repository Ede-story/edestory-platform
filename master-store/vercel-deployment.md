# Vercel Deployment Guide для Edestory Shop

## 🚀 Быстрый деплой

```bash
# Установка Vercel CLI
npm i -g vercel

# Из директории frontend
cd master-store/frontend

# Первый деплой
vercel

# Production деплой
vercel --prod
```

## 📋 Предварительные требования

1. **Аккаунт Vercel** (бесплатный план включает):
   - 100GB bandwidth/месяц
   - Unlimited deployments
   - Automatic HTTPS
   - Edge Functions

2. **Домен настроен** (shop.ede-story.com)

## 🔧 Настройка проекта

### 1. Инициализация
```bash
vercel init

# Выберите:
# - Link to existing project? No
# - Project name: edestory-shop
# - Directory: ./
# - Framework: Next.js
# - Build command: pnpm build
# - Output directory: .next
# - Development command: pnpm dev
```

### 2. Переменные окружения

#### Через Dashboard (рекомендуется):
1. Перейдите на https://vercel.com/dashboard
2. Выберите проект edestory-shop
3. Settings → Environment Variables
4. Добавьте переменные:

```env
# Production переменные
NEXT_PUBLIC_SALEOR_API_URL=https://api.ede-story.com/graphql/
NEXT_PUBLIC_STOREFRONT_URL=https://shop.ede-story.com
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...
ALIEXPRESS_APP_KEY=your_production_key
ALIEXPRESS_APP_SECRET=your_production_secret
ALIEXPRESS_TRACKING_ID=your_tracking_id
SALEOR_APP_TOKEN=your_app_token

# Домен
NEXT_PUBLIC_VERCEL_URL=${VERCEL_URL}
```

#### Через CLI:
```bash
# Добавление переменных
vercel env add NEXT_PUBLIC_SALEOR_API_URL production
vercel env add STRIPE_SECRET_KEY production
# ... и т.д.

# Проверка переменных
vercel env ls production
```

### 3. Настройка домена

```bash
# Добавление домена
vercel domains add shop.ede-story.com

# Проверка DNS
vercel domains inspect shop.ede-story.com
```

#### DNS записи (добавьте в Google Cloud DNS):
```
Type: CNAME
Name: shop
Value: cname.vercel-dns.com
TTL: 3600
```

или для apex домена:
```
Type: A
Name: @
Value: 76.76.21.21
```

## 🔄 CI/CD Pipeline

### GitHub Actions
Создайте `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Vercel

on:
  push:
    branches: [main]
    paths:
      - 'master-store/frontend/**'

env:
  VERCEL_ORG_ID: ${{ secrets.VERCEL_ORG_ID }}
  VERCEL_PROJECT_ID: ${{ secrets.VERCEL_PROJECT_ID }}

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup pnpm
        uses: pnpm/action-setup@v2
        with:
          version: 8
      
      - name: Install Vercel CLI
        run: npm install --global vercel@latest
      
      - name: Pull Vercel Environment
        run: vercel pull --yes --environment=production --token=${{ secrets.VERCEL_TOKEN }}
        working-directory: ./master-store/frontend
      
      - name: Build Project
        run: vercel build --prod --token=${{ secrets.VERCEL_TOKEN }}
        working-directory: ./master-store/frontend
      
      - name: Deploy to Vercel
        run: vercel deploy --prebuilt --prod --token=${{ secrets.VERCEL_TOKEN }}
        working-directory: ./master-store/frontend
```

### Получение токенов:
```bash
# Vercel Token
# https://vercel.com/account/tokens

# Organization ID
vercel whoami

# Project ID
vercel project ls
```

## 📊 Мониторинг

### Analytics
```javascript
// app/layout.tsx
import { Analytics } from '@vercel/analytics/react';
import { SpeedInsights } from '@vercel/speed-insights/next';

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        {children}
        <Analytics />
        <SpeedInsights />
      </body>
    </html>
  );
}
```

### Установка пакетов:
```bash
pnpm add @vercel/analytics @vercel/speed-insights
```

## 🛡️ Безопасность

### Защита API routes
```typescript
// app/api/admin/route.ts
import { verifyAuth } from '@/lib/auth';

export async function POST(request: Request) {
  const auth = await verifyAuth(request);
  if (!auth.isAdmin) {
    return new Response('Unauthorized', { status: 401 });
  }
  // ... rest of the code
}
```

### Rate Limiting
```typescript
// middleware.ts
import { Ratelimit } from '@upstash/ratelimit';
import { Redis } from '@upstash/redis';

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, '10 s'),
});

export async function middleware(request: NextRequest) {
  const ip = request.ip ?? '127.0.0.1';
  const { success } = await ratelimit.limit(ip);
  
  if (!success) {
    return new Response('Too Many Requests', { status: 429 });
  }
}

export const config = {
  matcher: '/api/:path*',
};
```

## 🚦 Проверки перед деплоем

### Чеклист:
```bash
# 1. Тесты проходят
pnpm test

# 2. Build успешен
pnpm build

# 3. TypeScript без ошибок
pnpm typecheck

# 4. Lint чистый
pnpm lint

# 5. Lighthouse score > 90
pnpm lighthouse
```

### Preview deployments:
```bash
# Создать preview
vercel

# URL будет типа: edestory-shop-git-feature-branch.vercel.app
```

## 🔥 Production оптимизации

### Image Optimization
```javascript
// next.config.js
module.exports = {
  images: {
    domains: ['ae01.alicdn.com', 'storefront1.saleor.cloud'],
    formats: ['image/avif', 'image/webp'],
  },
};
```

### Edge Functions для геолокации
```typescript
// app/api/geo/route.ts
import { geolocation } from '@vercel/edge';

export const runtime = 'edge';

export async function GET(request: Request) {
  const { country, city } = geolocation(request);
  
  return Response.json({
    country: country || 'ES',
    city: city || 'Barcelona',
    currency: country === 'ES' ? 'EUR' : 'USD',
  });
}
```

## 📈 Масштабирование

### Serverless Functions настройки:
```json
// vercel.json
{
  "functions": {
    "app/api/checkout/route.ts": {
      "maxDuration": 30,
      "memory": 1024
    },
    "app/api/products/import/route.ts": {
      "maxDuration": 60,
      "memory": 3008
    }
  }
}
```

### ISR (Incremental Static Regeneration):
```typescript
// app/products/[slug]/page.tsx
export const revalidate = 3600; // Обновлять каждый час

export async function generateStaticParams() {
  const products = await getTopProducts(100);
  return products.map((product) => ({
    slug: product.slug,
  }));
}
```

## 🐛 Отладка

### Логи:
```bash
# Просмотр логов в реальном времени
vercel logs --follow

# Функции логи
vercel logs --source=function

# Build логи
vercel logs --source=build
```

### Rollback:
```bash
# Список деплоев
vercel ls

# Откат к предыдущей версии
vercel rollback [deployment-url]
```

## 💰 Оптимизация затрат

### Бесплатный план включает:
- 100GB bandwidth
- 100 hours функций
- Unlimited static сайты
- SSL сертификаты

### Для экономии:
1. Используйте ISR вместо SSR где возможно
2. Кэшируйте API responses
3. Оптимизируйте изображения
4. Используйте Edge functions для легких операций

## 🎯 KPIs для мониторинга

- **TTFB**: < 200ms
- **FCP**: < 1.8s
- **LCP**: < 2.5s
- **CLS**: < 0.1
- **Uptime**: > 99.9%

---

**Статус:** Готов к деплою
**Команда:** `vercel --prod`
**Домен:** shop.ede-story.com
**Регион:** Madrid (mad1)