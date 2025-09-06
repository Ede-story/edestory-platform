# 🚀 Google Cloud Setup для Edestory Shop

## 📋 Что вам нужно сделать

### 1. Создайте проект в Google Cloud Console
1. Перейдите на https://console.cloud.google.com
2. Создайте новый проект: **"edestory-platform"**
3. Запомните Project ID (например: `edestory-platform-123456`)

### 2. Включите billing
1. Перейдите в Billing → Link billing account
2. Создайте или выберите существующий billing account
3. **Важно:** Установите budget alerts на $50/месяц

### 3. Установите gcloud CLI
```bash
# macOS
brew install google-cloud-sdk

# Или скачайте с
# https://cloud.google.com/sdk/docs/install

# Авторизация
gcloud auth login
gcloud config set project edestory-platform
```

### 4. Создайте Service Account для Terraform
```bash
# Выполните эти команды:
gcloud iam service-accounts create terraform-sa \
  --display-name="Terraform Service Account"

gcloud projects add-iam-policy-binding edestory-platform \
  --member="serviceAccount:terraform-sa@edestory-platform.iam.gserviceaccount.com" \
  --role="roles/owner"

gcloud iam service-accounts keys create ~/terraform-key.json \
  --iam-account=terraform-sa@edestory-platform.iam.gserviceaccount.com

# Экспортируйте путь к ключу
export GOOGLE_APPLICATION_CREDENTIALS=~/terraform-key.json
```

### 5. Включите необходимые API
```bash
# Я создал скрипт, запустите его:
./scripts/enable-gcp-apis.sh
```

### 6. Создайте bucket для Terraform state
```bash
gsutil mb -l EU gs://edestory-terraform-state
gsutil versioning set on gs://edestory-terraform-state
```

---

## 🤖 Что я сделаю автоматически

После того как вы выполните шаги выше, я:

1. **Запущу Terraform** для создания всей инфраструктуры
2. **Настрою Cloud Build** для автоматического деплоя
3. **Создам базы данных** PostgreSQL и Redis
4. **Настрою Cloud Run** для хостинга
5. **Создам Cloud Storage** buckets для медиафайлов
6. **Настрою Cloud Scheduler** для n8n автоматизации
7. **Настрою Load Balancer** с CDN

---

## 💰 Оценка затрат (месяц)

### Минимальная конфигурация (~$30-50/месяц):
- Cloud Run: ~$10 (1 instance, 1GB RAM)
- Cloud SQL: ~$15 (db-g1-small)
- Cloud Storage: ~$2 (10GB)
- Redis: ~$5 (1GB BASIC)
- Load Balancer: ~$18
- **Итого: ~$50/месяц**

### С бесплатными квотами (первые 3 месяца):
- $300 кредитов для новых аккаунтов
- Cloud Run: 2M requests free
- Cloud SQL: некоторые инстансы со скидкой
- **Реальные затраты: ~$20-30/месяц**

---

## 🎯 Команды для запуска

После выполнения всех шагов выше, сообщите мне, и я запущу:

```bash
# 1. Инициализация Terraform
cd master-store/terraform
terraform init

# 2. Планирование изменений
terraform plan

# 3. Применение конфигурации
terraform apply -auto-approve

# 4. Build и deploy приложения
gcloud builds submit --config=cloudbuild.yaml

# 5. Настройка домена
gcloud run services update edestory-shop \
  --platform managed \
  --region europe-west1 \
  --add-custom-audiences shop.ede-story.com
```

---

## 📱 Что проверить после деплоя

1. **Frontend**: https://edestory-shop-xxxxx-ew.a.run.app
2. **API**: https://saleor-api-xxxxx-ew.a.run.app/graphql/
3. **Cloud SQL**: В консоли GCP → SQL
4. **Logs**: В консоли GCP → Logging

---

## ⚠️ Важные моменты

1. **Секреты**: Все пароли хранятся в Secret Manager
2. **Backup**: Автоматический backup БД каждую ночь
3. **Scaling**: Автоматическое масштабирование от 1 до 10 инстансов
4. **Region**: europe-west1 (Бельгия) для минимальной задержки в Испании

---

## 📝 Чеклист для вас

- [ ] Создан проект в Google Cloud
- [ ] Включен billing
- [ ] Установлен gcloud CLI
- [ ] Создан Service Account
- [ ] Создан terraform state bucket
- [ ] Готовы API ключи (Stripe, AliExpress)

**Когда все готово, напишите мне "GCP готов", и я запущу автоматическое развертывание!**