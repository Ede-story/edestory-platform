# Storefront

Это Next.js‑витрина Edestory, основанная на Saleor React Storefront ( пинованная ревизия).  Приложение использует [app router](https://nextjs.org/docs/app) и базируется на React 18.

## Запуск

1. Скопируйте `.env.example` в `.env` и установите значения:
   - `NEXT_PUBLIC_SALEOR_API_URL` – GraphQL endpoint Saleor ( например, `https://demo.saleor.io/graphql/`).
   - `SALEOR_CHANNEL` – slug канала (`default-channel`).
   - `NEXT_PUBLIC_SITE_URL` – публичный URL витрины.
2. Установите зависимости и запустите dev‑сервер:

   ```bash
   pnpm install
   pnpm --filter=@edestory/storefront dev
   ```

Страницы доступны по адресу `http://localhost:3000`.

## Структура

- `src/app` – корень маршрутов Next.js.  `layout.tsx` подключает `ThemeProvider` из `@edestory/design-tokens`.
- `src/styles/globals.css` – подключает Tailwind CSS.  Переменные темы определяются как CSS custom properties.
- `presenters` не находятся в этом пакете; они импортируются из `@edestory/design-presenters-default` и передаются в контейнеры.

## TODO

- Реализовать контейнеры (`HomeContainer`, `ProductListContainer`, `ProductDetailsContainer`, `CartContainer`, `CheckoutContainer`) в каталоге `src/containers`.  Они должны вызывать GraphQL‑hooks из `@edestory/saleor-sdk`, маппировать результат в формат пропов и передавать презентерам.
- Подключить pinned‑ревизию `@saleor/storefront` ( замените хеш в `package.json` на нужный commit/tag).
- Добавить дополнительные презентеры и слот‑мап при необходимости.
