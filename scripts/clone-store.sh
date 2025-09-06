#!/bin/bash

# Clone Store Script - Простое клонирование магазина для нового клиента
# Usage: ./clone-store.sh <client-name> <domain>

CLIENT_NAME=$1
DOMAIN=$2

if [ -z "$CLIENT_NAME" ] || [ -z "$DOMAIN" ]; then
    echo "Usage: ./clone-store.sh <client-name> <domain>"
    echo "Example: ./clone-store.sh alibaba-shop shop.alibaba.com"
    exit 1
fi

echo "🚀 Клонирование магазина для: $CLIENT_NAME"

# 1. Копируем master-store
echo "📦 Копирование master-store..."
cp -r master-store client-stores/$CLIENT_NAME

# 2. Обновляем конфигурацию
echo "⚙️ Настройка конфигурации..."
cd client-stores/$CLIENT_NAME

# Заменяем домен в конфигах
find . -type f -name "*.json" -o -name "*.env" | xargs sed -i "" "s/master-store/$CLIENT_NAME/g"
find . -type f -name "*.json" -o -name "*.env" | xargs sed -i "" "s/example.com/$DOMAIN/g"

# 3. Создаем .env файл
echo "🔐 Создание .env файла..."
cat > .env << EOF
# Client Configuration
CLIENT_NAME=$CLIENT_NAME
DOMAIN=$DOMAIN

# Profit Sharing
PROFIT_SHARE_PERCENT=20

# Saleor
NEXT_PUBLIC_SALEOR_API_URL=https://$DOMAIN/graphql/
NEXT_PUBLIC_SALEOR_CHANNEL=$CLIENT_NAME-channel

# Payments
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=

# AliExpress
ALIEXPRESS_API_KEY=
ALIEXPRESS_TRACKING_ID=

# n8n
N8N_WEBHOOK_URL=
EOF

echo "✅ Магазин для $CLIENT_NAME успешно создан!"
echo ""
echo "Следующие шаги:"
echo "1. Настройте DNS для $DOMAIN"
echo "2. Заполните API ключи в .env файле"
echo "3. Запустите: cd client-stores/$CLIENT_NAME && docker-compose up -d"
echo "4. Настройте SSL: certbot --nginx -d $DOMAIN"
echo ""
echo "📊 Profit-sharing: 20% (наша комиссия) / 80% (клиент)"