#!/bin/bash

# Скрипт для инициализации Terraform backend в Google Cloud Storage

set -e

PROJECT_ID="rosy-stronghold-467817-k6"
BUCKET_NAME="edestory-terraform-state"
REGION="us-central1"

echo "🚀 Инициализация Terraform Backend для проекта Edestory"
echo "============================================="

# Проверяем, авторизован ли gcloud
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo "❌ Вы не авторизованы в gcloud. Выполните:"
    echo "   gcloud auth login"
    exit 1
fi

# Устанавливаем проект
echo "📦 Устанавливаем проект: $PROJECT_ID"
gcloud config set project $PROJECT_ID

# Проверяем, существует ли bucket
if gsutil ls -b gs://$BUCKET_NAME &>/dev/null; then
    echo "✅ Bucket $BUCKET_NAME уже существует"
else
    echo "📦 Создаем bucket для Terraform state..."
    gsutil mb -p $PROJECT_ID -l $REGION -b on gs://$BUCKET_NAME
    
    # Включаем версионирование для безопасности
    echo "🔒 Включаем версионирование..."
    gsutil versioning set on gs://$BUCKET_NAME
    
    # Устанавливаем lifecycle правила
    echo "⏰ Настраиваем lifecycle правила..."
    cat > /tmp/lifecycle.json << EOF
{
  "lifecycle": {
    "rule": [
      {
        "action": {"type": "Delete"},
        "condition": {
          "numNewerVersions": 10,
          "isLive": false
        }
      }
    ]
  }
}
EOF
    gsutil lifecycle set /tmp/lifecycle.json gs://$BUCKET_NAME
    rm /tmp/lifecycle.json
    
    echo "✅ Bucket создан и настроен"
fi

# Включаем необходимые API
echo "🔧 Включаем необходимые Google Cloud APIs..."
gcloud services enable storage-api.googleapis.com
gcloud services enable storage-component.googleapis.com

echo ""
echo "✅ Backend готов к использованию!"
echo ""
echo "Теперь вы можете инициализировать Terraform:"
echo "  cd terraform/"
echo "  terraform init"
echo ""