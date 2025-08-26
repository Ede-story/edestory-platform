# 📋 Checklist для завершения инвентаризации

## ✅ Выполнено автоматически

- **A2.2**: Workflows очищены (остались `edestory-converge.yml`, `00-diagnose.yml`)
- **A2.3**: Зависимости исправлены (pnpm@8.15.5, node>=20, .npmrc)
- **A2.4**: Monorepo метаданные настроены
- **D**: Добавлены smoke-тесты (Playwright) и Lighthouse CI

## ⚠️ Требует ручного выполнения

### A1. GitHub Repositories Inventory

**Что делать:**
1. Перейти на https://github.com/Ede-story → Repositories
2. Сделать скриншот страницы
3. Экспортировать список в CSV
4. Отметить для архивации все репозитории кроме `edestory-platform`

**Команды для архивации:**
```bash
# Для каждого репозитория (кроме edestory-platform):
# Settings → General → Archive this repository
```

### A2.1. GitHub Branches Cleanup

**Что делать:**
1. Перейти на https://github.com/Ede-story/edestory-platform → Branches
2. Удалить все ветки кроме `main` и активных feature/preview веток
3. Сделать скриншот до/после

### A2.5. GitHub Secrets/Variables

**Переменные для добавления** (Repository → Settings → Secrets and variables → Actions):

**Variables:**
- `GCP_PROJECT_ID`: `rosy-stronghold-467817-k6`
- `WIF_PROVIDER`: `projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/github-pool/providers/github-provider`
- `GCP_SA_EMAIL`: `github-actions@rosy-stronghold-467817-k6.iam.gserviceaccount.com`
- `BUILD_GCS_BUCKET`: bucket name for build artifacts

**Secrets:**
- `GH_PAT`: GitHub Personal Access Token для bot commits
- `LHCI_GITHUB_APP_TOKEN`: Lighthouse CI GitHub App token (опционально)

### B1. Vercel Projects Inventory

**Что делать:**
1. Перейти на https://vercel.com/ede-story
2. Сделать скриншот всех проектов
3. KEEP: `edestory-platform-storefront`
4. Для остальных:
   - Settings → Environment Variables → Export
   - Settings → Git → Disconnect
   - Settings → General → Remove

### B2. Vercel Project Settings

**Настройки для `edestory-platform-storefront`:**

**Git Settings:**
- Repository: `Ede-story/edestory-platform`
- Production Branch: `main`
- Preview Deployments: `Automatically create Preview Deployments = ON`

**Build & Output Settings:**
- Build Command: `pnpm -C apps/storefront build`
- Output Directory: `apps/storefront/.next`
- Install Command: `corepack enable && pnpm install --no-frozen-lockfile`
- Root Directory: `apps/storefront`

**Environment Variables (Preview):**
- `NEXT_PUBLIC_API_BASE_URL`: `https://diary-api-preview-rwa4ofq7sa-ew.a.run.app`

### C. GCP Resources Audit

**Проверить и оставить** (Project: `rosy-stronghold-467817-k6`):

**Cloud Run Services:**
- `diary-api-preview` (europe-west1) - KEEP

**Secret Manager:**
- `preview-DIARY_TOKEN` - KEEP
- `preview-DATABASE_URL` - KEEP

**Artifact Registry:**
- `diary-registry` (europe-west1) - KEEP

**IAM Workload Identity Federation:**
- Pool: `github-pool` - KEEP
- Provider: `github-provider` - KEEP
- Condition: `repository="Ede-story/edestory-platform"`

**APIs (должны быть включены):**
- Cloud Run API
- Cloud Build API
- Artifact Registry API
- Secret Manager API

## 🧪 Тестирование

После завершения настроек:

1. **Создать тестовый PR** для проверки Vercel Preview Deployments
2. **Запустить workflow** `test-and-quality.yml`
3. **Проверить Lighthouse результаты** (цель ≥90%)

## 📊 Результат

Когда все выполнено:
- [ ] Все лишние ресурсы архивированы/удалены
- [ ] Канонический репозиторий очищен и настроен
- [ ] CI/CD пайплайн работает
- [ ] Preview deployments функционируют
- [ ] Smoke-тесты проходят
- [ ] Lighthouse ≥90%
