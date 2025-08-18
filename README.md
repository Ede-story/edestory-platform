# Edestory Platform

Этот репозиторий содержит монорепозиторий (pnpm + Turborepo) для e‑commerce платформы **Edestory**.  Внутри собраны несколько приложений и пакетов:

- `apps/storefront` – витрина на Next.js, построенная поверх Saleor storefront.  Потребляет данные через GraphQL и отображает их с помощью презентеров.
- `apps/orchestrator` – бэкенд на FastAPI для координации моделей ИИ и реестра дизайна.
- `packages/design-tokens` – JSON‑файл с дизайн‑токенами (`theme.json`) и `ThemeProvider`, который превращает их в CSS‑переменные.
- `packages/design-presenters-default` – набор React‑презентеров, реализующий UI‑блоки (hero, список товаров, PDP, корзина, checkout) без логики data‑fetching.
- `packages/saleor-sdk` – лёгкий клиент для работы с GraphQL API Saleor.
- `infra/cloudrun` – Dockerfile‑ы для построения контейнеров storefront и orchestrator.
- `.github/workflows` – файлы CI/CD: build/test, design‑lock, публикация дизайн‑пакета, предпросмотр (Vercel) и деплой Cloud Run.

## Локальный запуск

Для работы понадобится Node.js ≥20 и pnpm.  После клонирования:

```bash
pnpm install
pnpm turbo run dev
```

В storefront необходимо создать `.env` на основе `.env.example` и указать `NEXT_PUBLIC_SALEOR_API_URL`, канал и URL сайта.

## Разработка

Все изменения дизайна (папки `packages/design-*`) требуют метки `design-approved` в Pull Request.  Логика загрузки данных должна находиться только в контейнерах (hooks), а презентеры должны быть чистыми UI‑компонентами с типизированными пропсами.

Для более подробной информации смотрите README в соответствующих папках.