# 🌟 Google Cloud MCP - Руководство по настройке

## 📋 Предварительные требования

1. **Google Cloud Account**
   - Активный аккаунт Google Cloud
   - Проект создан (например: `edestory-platform`)
   - Billing включен

2. **Service Account**
   - Создан Service Account для MCP
   - Скачан JSON ключ
   - Настроены необходимые роли

## 🔧 Пошаговая настройка

### Шаг 1: Создание Service Account

```bash
# Войдите в gcloud
gcloud auth login

# Установите проект
gcloud config set project edestory-platform

# Создайте Service Account
gcloud iam service-accounts create mcp-server \
    --display-name="MCP Server for Claude" \
    --description="Service account for Model Context Protocol integration"

# Создайте и скачайте ключ
gcloud iam service-accounts keys create ~/edestory-sa-key.json \
    --iam-account=mcp-server@edestory-platform.iam.gserviceaccount.com
```

### Шаг 2: Назначение ролей

```bash
# Базовые роли для MCP
gcloud projects add-iam-policy-binding edestory-platform \
    --member="serviceAccount:mcp-server@edestory-platform.iam.gserviceaccount.com" \
    --role="roles/viewer"

# Cloud Run (для деплоя)
gcloud projects add-iam-policy-binding edestory-platform \
    --member="serviceAccount:mcp-server@edestory-platform.iam.gserviceaccount.com" \
    --role="roles/run.developer"

# Cloud Storage
gcloud projects add-iam-policy-binding edestory-platform \
    --member="serviceAccount:mcp-server@edestory-platform.iam.gserviceaccount.com" \
    --role="roles/storage.admin"

# Cloud SQL
gcloud projects add-iam-policy-binding edestory-platform \
    --member="serviceAccount:mcp-server@edestory-platform.iam.gserviceaccount.com" \
    --role="roles/cloudsql.client"

# Logging и Monitoring
gcloud projects add-iam-policy-binding edestory-platform \
    --member="serviceAccount:mcp-server@edestory-platform.iam.gserviceaccount.com" \
    --role="roles/logging.viewer"

gcloud projects add-iam-policy-binding edestory-platform \
    --member="serviceAccount:mcp-server@edestory-platform.iam.gserviceaccount.com" \
    --role="roles/monitoring.viewer"

# DNS для управления доменами
gcloud projects add-iam-policy-binding edestory-platform \
    --member="serviceAccount:mcp-server@edestory-platform.iam.gserviceaccount.com" \
    --role="roles/dns.admin"
```

### Шаг 3: Установка Google Cloud MCP

```bash
cd /Users/vadimarhipov/edestory-platform/mcp-google-cloud

# Установка зависимостей
npm install

# Сборка
npm run build
```

### Шаг 4: Конфигурация переменных окружения

Создайте файл `.env` в директории `mcp-google-cloud`:

```bash
# Google Cloud Configuration
GOOGLE_CLOUD_PROJECT=edestory-platform
GOOGLE_APPLICATION_CREDENTIALS=/Users/vadimarhipov/edestory-sa-key.json
GOOGLE_CLOUD_REGION=europe-west1
GOOGLE_CLOUD_ZONE=europe-west1-b

# Optional: Specific service configurations
CLOUD_RUN_SERVICE_NAME=edestory-web
CLOUD_SQL_INSTANCE=edestory-platform:europe-west1:edestory-db
STORAGE_BUCKET=edestory-assets
```

### Шаг 5: Конфигурация Claude Desktop

Добавьте в `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "google-cloud": {
      "command": "node",
      "args": [
        "/Users/vadimarhipov/edestory-platform/mcp-google-cloud/dist/index.js"
      ],
      "env": {
        "GOOGLE_APPLICATION_CREDENTIALS": "/Users/vadimarhipov/edestory-sa-key.json",
        "GOOGLE_CLOUD_PROJECT": "edestory-platform",
        "GOOGLE_CLOUD_REGION": "europe-west1"
      }
    }
  }
}
```

## 📦 Управление доменами через Google Cloud DNS

### Создание DNS зоны

```bash
# Создать зону для ede-story.com
gcloud dns managed-zones create edestory-zone \
    --dns-name="ede-story.com." \
    --description="Main domain for Edestory platform"

# Получить Name Servers
gcloud dns managed-zones describe edestory-zone
```

### Управление DNS записями через MCP

После настройки вы можете использовать команды в Claude:

```text
"Добавь A запись для shop.ede-story.com указывающую на 35.195.123.45"
"Покажи все DNS записи для ede-story.com"
"Настрой MX записи для Google Workspace"
"Добавь TXT запись для верификации домена"
```

## 🚀 Полезные команды MCP

### Billing и расходы
- "Покажи расходы за последний месяц"
- "Анализируй аномалии в биллинге"
- "Дай рекомендации по оптимизации расходов"

### Cloud Run деплой
- "Задеплой контейнер corporate-site на Cloud Run"
- "Покажи статус сервиса edestory-web"
- "Обнови переменные окружения для сервиса"

### Storage управление
- "Загрузи файлы из /public в bucket edestory-assets"
- "Настрой CDN для bucket"
- "Создай backup bucket"

### Monitoring
- "Покажи логи ошибок за последний час"
- "Проверь CPU использование Cloud Run сервисов"
- "Настрой алерт на высокую латентность"

## ⚠️ Важные замечания

1. **Безопасность ключей**
   - НИКОГДА не коммитьте service account ключи
   - Добавьте `*.json` в `.gitignore`
   - Используйте Secret Manager для production

2. **Права доступа**
   - Используйте принцип минимальных привилегий
   - Регулярно аудитьте IAM роли
   - Создавайте отдельные SA для разных сред

3. **Региональность**
   - Выбирайте регион ближе к пользователям
   - europe-west1 (Бельгия) - хороший выбор для Европы
   - Учитывайте GDPR требования

## 🔗 Полезные ссылки

- [Google Cloud Console](https://console.cloud.google.com)
- [Cloud DNS Documentation](https://cloud.google.com/dns/docs)
- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [IAM Best Practices](https://cloud.google.com/iam/docs/best-practices)
- [Google Cloud MCP GitHub](https://github.com/krzko/google-cloud-mcp)

## 📞 Поддержка

- Email: dev@ede-story.com
- Slack: #gcp-support
- Google Cloud Support: [Support Center](https://cloud.google.com/support)

---

**Обновлено:** Январь 2025
**Версия:** 1.0
**Статус:** Готово к использованию