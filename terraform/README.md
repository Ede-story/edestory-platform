# Terraform Infrastructure для Edestory Platform

## 📋 Описание

Автоматизированное развертывание инфраструктуры в Google Cloud Platform с использованием Terraform.

## 🏗️ Архитектура

```
┌─────────────────────────────────────────────────────────────┐
│                        Google Cloud                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐     ┌──────────────┐    ┌──────────────┐ │
│  │  Cloud Run   │     │  Cloud Run   │    │   Cloud SQL  │ │
│  │   (Shop)     │────▶│  (Corporate) │────▶│  PostgreSQL  │ │
│  └──────────────┘     └──────────────┘    └──────────────┘ │
│         │                     │                    │        │
│         └─────────────────────┴────────────────────┘        │
│                              │                              │
│                    ┌─────────────────┐                      │
│                    │   VPC Network   │                      │
│                    └─────────────────┘                      │
│                              │                              │
│         ┌────────────────────┴────────────────────┐         │
│         │                                          │         │
│  ┌──────────────┐                      ┌──────────────┐    │
│  │ Cloud Storage│                      │ Load Balancer│    │
│  │   (Assets)   │                      │     (CDN)    │    │
│  └──────────────┘                      └──────────────┘    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## 🚀 Быстрый старт

### 1. Предварительные требования

- Google Cloud SDK (`gcloud`)
- Terraform >= 1.5.0
- Доступ к GCP проекту
- Service Account с необходимыми правами

### 2. Инициализация Backend

```bash
# Создаем bucket для Terraform state
cd terraform/scripts
./init-backend.sh
```

### 3. Настройка переменных

Отредактируйте файлы в `terraform/environments/`:
- `dev/terraform.tfvars` - для разработки
- `prod/terraform.tfvars` - для продакшена

### 4. Развертывание

```bash
cd terraform/

# Инициализация
terraform init

# Планирование (dev окружение)
terraform plan -var-file="environments/dev/terraform.tfvars"

# Применение
terraform apply -var-file="environments/dev/terraform.tfvars"
```

## 📦 Модули

### Network Module
- VPC с приватными подсетями
- Cloud NAT для исходящего трафика
- VPC Connector для Cloud Run
- Firewall правила

### Database Module
- Cloud SQL PostgreSQL
- Автоматическое резервное копирование
- High Availability (для prod)
- Секреты в Secret Manager

### Storage Module
- GCS buckets (main, public, backup)
- CDN интеграция
- Lifecycle правила
- CORS настройки

### Cloud Run Module
- Автомасштабирование
- VPC интеграция
- Мониторинг и алерты
- Custom domains

## 🔐 Безопасность

### Service Account

Создайте Service Account с правами:
```bash
gcloud iam service-accounts create terraform-sa \
  --display-name="Terraform Service Account"

# Назначаем роли
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:terraform-sa@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/editor"

# Создаем ключ
gcloud iam service-accounts keys create key.json \
  --iam-account=terraform-sa@PROJECT_ID.iam.gserviceaccount.com
```

### GitHub Secrets

Добавьте в GitHub repository secrets:
- `GCP_SA_KEY` - содержимое key.json
- `GCP_PROJECT_ID` - ID проекта

## 🔄 CI/CD

### Автоматическое развертывание

При push в `main`:
1. Terraform plan
2. Terraform apply (с подтверждением)
3. Docker build & push
4. Deploy to Cloud Run

### Ручное развертывание

```bash
# Через GitHub Actions
gh workflow run terraform-deploy.yml -f environment=prod

# Локально
terraform apply -var-file="environments/prod/terraform.tfvars"
```

## 📊 Мониторинг

### Dashboards

Terraform автоматически создает:
- Uptime checks
- Alert policies
- Log-based metrics

### Просмотр логов

```bash
# Cloud Run логи
gcloud logging read "resource.type=cloud_run_revision" --limit 50

# Database логи
gcloud logging read "resource.type=cloudsql_database" --limit 50
```

## 🛠️ Обслуживание

### Обновление инфраструктуры

```bash
# Проверка изменений
terraform plan -var-file="environments/prod/terraform.tfvars"

# Применение изменений
terraform apply -var-file="environments/prod/terraform.tfvars"
```

### Откат изменений

```bash
# Просмотр истории state
terraform state list

# Откат к предыдущей версии
terraform state pull > backup.tfstate
# Восстановление из backup при необходимости
```

### Уничтожение инфраструктуры

⚠️ **ВНИМАНИЕ**: Это удалит ВСЮ инфраструктуру!

```bash
terraform destroy -var-file="environments/dev/terraform.tfvars"
```

## 📈 Масштабирование

### Увеличение ресурсов

В `terraform.tfvars`:
```hcl
# Database
db_tier = "db-n1-standard-2"  # Больше CPU/RAM

# Cloud Run
cpu_limit = "2"
memory_limit = "1Gi"
max_instances = 200
```

### Multi-region setup

Добавьте новые регионы в модули:
```hcl
regions = ["us-central1", "europe-west1", "asia-northeast1"]
```

## 🔍 Troubleshooting

### Проблема: State lock

```bash
# Разблокировка state
terraform force-unlock LOCK_ID
```

### Проблема: Недостаточно прав

```bash
# Проверка прав service account
gcloud projects get-iam-policy PROJECT_ID \
  --flatten="bindings[].members" \
  --filter="bindings.members:serviceAccount:terraform-sa@*"
```

### Проблема: API не включены

```bash
# Включение необходимых API
gcloud services enable compute.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable sqladmin.googleapis.com
```

## 📝 Структура проекта

```
terraform/
├── main.tf                 # Основная конфигурация
├── variables.tf            # Переменные
├── outputs.tf              # Выходные данные
├── environments/           # Окружения
│   ├── dev/
│   │   └── terraform.tfvars
│   └── prod/
│       └── terraform.tfvars
├── modules/               # Terraform модули
│   ├── network/
│   ├── database/
│   ├── storage/
│   └── cloudrun/
└── scripts/              # Вспомогательные скрипты
    └── init-backend.sh

```

## 💰 Оптимизация расходов

1. **Используйте Committed Use Discounts** для prod
2. **Настройте автомасштабирование** с min_instances=0 для dev
3. **Включите lifecycle правила** для storage
4. **Используйте Spot VMs** где возможно
5. **Мониторьте расходы** через Billing Alerts

## 📞 Поддержка

- Документация: `/docs/`
- Issues: GitHub Issues
- Email: support@ede-story.com

---

**Версия**: 1.0.0  
**Обновлено**: Январь 2025  
**Автор**: Edestory Platform Team