#!/bin/bash

echo "🚀 Setting up Saleor backend..."

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL..."
until docker exec edestory-postgres pg_isready -U saleor; do
  sleep 2
done

echo "✅ PostgreSQL is ready"

# Run migrations
echo "Running database migrations..."
docker exec edestory-saleor python manage.py migrate

# Create superuser
echo "Creating admin user..."
docker exec -it edestory-saleor python manage.py createsuperuser --email admin@example.com --username admin

# Create default channel
echo "Setting up default channel..."
docker exec edestory-saleor python manage.py shell << EOF
from saleor.channel.models import Channel
from decimal import Decimal

channel, created = Channel.objects.get_or_create(
    slug='default-channel',
    defaults={
        'name': 'Default Channel',
        'is_active': True,
        'currency_code': 'USD',
        'default_country': 'US',
    }
)

if created:
    print("✅ Default channel created")
else:
    print("ℹ️ Default channel already exists")
EOF

# Create sample categories
echo "Creating product categories..."
docker exec edestory-saleor python manage.py shell << EOF
from saleor.product.models import Category

categories = [
    {'name': 'Electronics', 'slug': 'electronics'},
    {'name': 'Fashion', 'slug': 'fashion'},
    {'name': 'Home & Garden', 'slug': 'home-garden'},
    {'name': 'Sports', 'slug': 'sports'},
    {'name': 'Beauty', 'slug': 'beauty'},
]

for cat_data in categories:
    category, created = Category.objects.get_or_create(
        slug=cat_data['slug'],
        defaults={'name': cat_data['name']}
    )
    if created:
        print(f"✅ Created category: {cat_data['name']}")
EOF

echo "🎉 Saleor setup complete!"
echo ""
echo "Access points:"
echo "- GraphQL API: http://localhost:8000/graphql/"
echo "- Admin Dashboard: http://localhost:8000/dashboard/"
echo "- Default credentials: admin / (password you set)"