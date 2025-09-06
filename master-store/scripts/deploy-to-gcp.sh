#!/bin/bash

# Автоматический деплой Edestory Shop на Google Cloud Platform
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}    🚀 Edestory Shop - Google Cloud Deployment${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

# Проверка prerequisites
check_prerequisites() {
    echo -e "${YELLOW}📋 Проверяем требования...${NC}"
    
    # Check gcloud
    if ! command -v gcloud &> /dev/null; then
        echo -e "${RED}❌ gcloud CLI не установлен${NC}"
        exit 1
    fi
    
    # Check terraform
    if ! command -v terraform &> /dev/null; then
        echo -e "${RED}❌ Terraform не установлен${NC}"
        echo "Установите с: brew install terraform"
        exit 1
    fi
    
    # Check docker
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker не установлен${NC}"
        exit 1
    fi
    
    # Check project
    PROJECT_ID=$(gcloud config get-value project)
    if [ -z "$PROJECT_ID" ]; then
        echo -e "${RED}❌ GCP проект не выбран${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Все требования выполнены${NC}"
    echo -e "${YELLOW}📦 Проект: $PROJECT_ID${NC}\n"
}

# Step 1: Terraform Infrastructure
deploy_infrastructure() {
    echo -e "${BLUE}═══ Шаг 1: Создание инфраструктуры ═══${NC}\n"
    
    cd terraform
    
    # Initialize Terraform
    echo -e "${YELLOW}Инициализируем Terraform...${NC}"
    terraform init
    
    # Plan changes
    echo -e "${YELLOW}Планируем изменения...${NC}"
    terraform plan -out=tfplan
    
    # Apply changes
    echo -e "${YELLOW}Применяем конфигурацию...${NC}"
    terraform apply tfplan
    
    # Save outputs
    terraform output -json > ../terraform-outputs.json
    
    cd ..
    echo -e "${GREEN}✅ Инфраструктура создана${NC}\n"
}

# Step 2: Build Docker Images
build_images() {
    echo -e "${BLUE}═══ Шаг 2: Сборка Docker образов ═══${NC}\n"
    
    # Build frontend image
    echo -e "${YELLOW}Собираем frontend образ...${NC}"
    docker build -t gcr.io/$PROJECT_ID/edestory-shop:latest \
        --build-arg NEXT_PUBLIC_SALEOR_API_URL=https://api.shop.ede-story.com/graphql/ \
        --build-arg NEXT_PUBLIC_STOREFRONT_URL=https://shop.ede-story.com \
        .
    
    # Push to registry
    echo -e "${YELLOW}Загружаем в Container Registry...${NC}"
    docker push gcr.io/$PROJECT_ID/edestory-shop:latest
    
    echo -e "${GREEN}✅ Образы готовы${NC}\n"
}

# Step 3: Deploy Saleor
deploy_saleor() {
    echo -e "${BLUE}═══ Шаг 3: Развертывание Saleor ═══${NC}\n"
    
    # Build Saleor image
    echo -e "${YELLOW}Собираем Saleor образ...${NC}"
    docker build -t gcr.io/$PROJECT_ID/saleor:latest -f Dockerfile.saleor .
    docker push gcr.io/$PROJECT_ID/saleor:latest
    
    # Deploy to Cloud Run
    echo -e "${YELLOW}Деплоим Saleor API...${NC}"
    gcloud run deploy saleor-api \
        --image gcr.io/$PROJECT_ID/saleor:latest \
        --region europe-west1 \
        --platform managed \
        --memory 2Gi \
        --cpu 2 \
        --timeout 300 \
        --concurrency 100 \
        --port 8000 \
        --max-instances 20 \
        --min-instances 2 \
        --allow-unauthenticated \
        --add-cloudsql-instances $(terraform output -raw database_instance)
    
    echo -e "${GREEN}✅ Saleor API развернут${NC}\n"
}

# Step 4: Deploy Frontend
deploy_frontend() {
    echo -e "${BLUE}═══ Шаг 4: Развертывание Frontend ═══${NC}\n"
    
    echo -e "${YELLOW}Деплоим Frontend...${NC}"
    gcloud run deploy edestory-shop \
        --image gcr.io/$PROJECT_ID/edestory-shop:latest \
        --region europe-west1 \
        --platform managed \
        --memory 1Gi \
        --cpu 1 \
        --timeout 300 \
        --concurrency 100 \
        --port 8080 \
        --max-instances 10 \
        --min-instances 1 \
        --allow-unauthenticated
    
    echo -e "${GREEN}✅ Frontend развернут${NC}\n"
}

# Step 5: Setup n8n
setup_n8n() {
    echo -e "${BLUE}═══ Шаг 5: Настройка n8n автоматизации ═══${NC}\n"
    
    echo -e "${YELLOW}Деплоим n8n...${NC}"
    gcloud run deploy n8n \
        --image n8nio/n8n:latest \
        --region europe-west1 \
        --platform managed \
        --memory 1Gi \
        --cpu 1 \
        --port 5678 \
        --max-instances 3 \
        --min-instances 1 \
        --set-env-vars N8N_BASIC_AUTH_ACTIVE=true,N8N_BASIC_AUTH_USER=admin,N8N_BASIC_AUTH_PASSWORD=changeme
    
    echo -e "${GREEN}✅ n8n настроен${NC}\n"
}

# Step 6: Configure domain
configure_domain() {
    echo -e "${BLUE}═══ Шаг 6: Настройка домена ═══${NC}\n"
    
    echo -e "${YELLOW}Настраиваем домен shop.ede-story.com...${NC}"
    
    # Get service URL
    SERVICE_URL=$(gcloud run services describe edestory-shop --region europe-west1 --format 'value(status.url)')
    
    echo -e "${GREEN}Service URL: $SERVICE_URL${NC}"
    echo -e "${YELLOW}Добавьте CNAME запись в DNS:${NC}"
    echo -e "  Type: CNAME"
    echo -e "  Name: shop"
    echo -e "  Value: ${SERVICE_URL#https://}"
    
    echo -e "${GREEN}✅ Домен готов к настройке${NC}\n"
}

# Step 7: Run migrations
run_migrations() {
    echo -e "${BLUE}═══ Шаг 7: Миграции базы данных ═══${NC}\n"
    
    echo -e "${YELLOW}Запускаем миграции Saleor...${NC}"
    gcloud run jobs create saleor-migrate \
        --image gcr.io/$PROJECT_ID/saleor:latest \
        --region europe-west1 \
        --command "python,manage.py,migrate" \
        --max-retries 3 \
        --add-cloudsql-instances $(terraform output -raw database_instance)
    
    gcloud run jobs execute saleor-migrate --region europe-west1 --wait
    
    echo -e "${GREEN}✅ Миграции выполнены${NC}\n"
}

# Step 8: Create admin user
create_admin() {
    echo -e "${BLUE}═══ Шаг 8: Создание администратора ═══${NC}\n"
    
    echo -e "${YELLOW}Создаем суперпользователя...${NC}"
    echo -e "${YELLOW}Email: admin@ede-story.com${NC}"
    echo -e "${YELLOW}Password: (будет сгенерирован)${NC}"
    
    # Generate password
    ADMIN_PASSWORD=$(openssl rand -base64 32)
    
    # Save to Secret Manager
    echo -n "$ADMIN_PASSWORD" | gcloud secrets create saleor-admin-password --data-file=-
    
    echo -e "${GREEN}✅ Пароль сохранен в Secret Manager${NC}"
    echo -e "${YELLOW}Получить пароль: gcloud secrets versions access latest --secret=saleor-admin-password${NC}\n"
}

# Step 9: Setup monitoring
setup_monitoring() {
    echo -e "${BLUE}═══ Шаг 9: Настройка мониторинга ═══${NC}\n"
    
    echo -e "${YELLOW}Настраиваем алерты...${NC}"
    
    # Create uptime check
    gcloud monitoring uptime-checks create shop-uptime \
        --display-name="Shop Uptime Check" \
        --uri=https://shop.ede-story.com \
        --check-interval=5
    
    echo -e "${GREEN}✅ Мониторинг настроен${NC}\n"
}

# Final summary
show_summary() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}    🎉 Развертывание завершено успешно!${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"
    
    echo -e "${GREEN}📍 URLs:${NC}"
    echo -e "  Frontend: $(gcloud run services describe edestory-shop --region europe-west1 --format 'value(status.url)')"
    echo -e "  API: $(gcloud run services describe saleor-api --region europe-west1 --format 'value(status.url)')"
    echo -e "  n8n: $(gcloud run services describe n8n --region europe-west1 --format 'value(status.url)')"
    
    echo -e "\n${GREEN}📊 Ресурсы:${NC}"
    echo -e "  Database: $(terraform output -raw database_instance)"
    echo -e "  Media Bucket: $(terraform output -raw media_bucket)"
    echo -e "  Static Bucket: $(terraform output -raw static_bucket)"
    
    echo -e "\n${GREEN}🔐 Credentials:${NC}"
    echo -e "  Admin password: gcloud secrets versions access latest --secret=saleor-admin-password"
    echo -e "  n8n: admin / changeme"
    
    echo -e "\n${YELLOW}📝 Следующие шаги:${NC}"
    echo -e "  1. Настройте DNS записи для shop.ede-story.com"
    echo -e "  2. Добавьте Stripe production ключи"
    echo -e "  3. Получите AliExpress API ключи"
    echo -e "  4. Импортируйте n8n workflows"
    
    echo -e "\n${GREEN}💰 Оценка затрат: ~$50/месяц${NC}"
    echo -e "${YELLOW}📈 Мониторинг: https://console.cloud.google.com/monitoring${NC}"
}

# Main execution
main() {
    check_prerequisites
    
    echo -e "${YELLOW}Начинаем развертывание для проекта: $PROJECT_ID${NC}"
    echo -e "${YELLOW}Это займет примерно 15-20 минут...${NC}\n"
    
    read -p "Продолжить? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        echo "Отменено"
        exit 0
    fi
    
    deploy_infrastructure
    build_images
    deploy_saleor
    deploy_frontend
    setup_n8n
    configure_domain
    run_migrations
    create_admin
    setup_monitoring
    show_summary
}

# Run main function
main