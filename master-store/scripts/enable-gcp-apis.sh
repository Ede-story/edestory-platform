#!/bin/bash

# Enable Google Cloud APIs для Edestory Shop
# Запустите после создания проекта в GCP

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Включаем необходимые Google Cloud APIs${NC}\n"

# Проверяем, что gcloud установлен
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}❌ gcloud CLI не установлен!${NC}"
    echo "Установите с: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Получаем текущий проект
PROJECT_ID=$(gcloud config get-value project)
if [ -z "$PROJECT_ID" ]; then
    echo -e "${RED}❌ Проект не выбран!${NC}"
    echo "Выполните: gcloud config set project YOUR_PROJECT_ID"
    exit 1
fi

echo -e "${YELLOW}📋 Проект: $PROJECT_ID${NC}\n"

# Список необходимых API
APIS=(
    "run.googleapis.com"                    # Cloud Run
    "cloudbuild.googleapis.com"            # Cloud Build
    "secretmanager.googleapis.com"         # Secret Manager
    "sqladmin.googleapis.com"              # Cloud SQL
    "cloudscheduler.googleapis.com"        # Cloud Scheduler
    "storage-api.googleapis.com"           # Cloud Storage
    "storage-component.googleapis.com"     # Cloud Storage
    "compute.googleapis.com"               # Compute Engine
    "servicenetworking.googleapis.com"     # Service Networking
    "redis.googleapis.com"                 # Memorystore for Redis
    "vpcaccess.googleapis.com"             # VPC Access
    "cloudresourcemanager.googleapis.com"  # Resource Manager
    "iam.googleapis.com"                   # IAM
    "iamcredentials.googleapis.com"        # IAM Credentials
    "logging.googleapis.com"               # Cloud Logging
    "monitoring.googleapis.com"            # Cloud Monitoring
    "containerregistry.googleapis.com"     # Container Registry
    "artifactregistry.googleapis.com"      # Artifact Registry
)

echo -e "${YELLOW}Включаем ${#APIS[@]} APIs...${NC}\n"

for api in "${APIS[@]}"; do
    echo -n "Включаем $api... "
    if gcloud services enable "$api" --project="$PROJECT_ID" 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${YELLOW}(уже включен или ошибка)${NC}"
    fi
done

echo -e "\n${GREEN}✅ Все API включены!${NC}"

# Проверяем статус
echo -e "\n${YELLOW}📊 Проверяем статус API:${NC}"
gcloud services list --enabled --project="$PROJECT_ID" | grep -E "(run|sql|storage|redis|build|scheduler)" || true

echo -e "\n${GREEN}🎉 Готово! Теперь можно запускать Terraform.${NC}"
echo -e "${YELLOW}Следующий шаг: cd terraform && terraform init${NC}"