#!/bin/bash

echo "🚀 Initializing Edestory B2B Platform..."

# Check prerequisites
command -v docker >/dev/null 2>&1 || { echo "❌ Docker required but not installed. Aborting." >&2; exit 1; }
command -v npm >/dev/null 2>&1 || { echo "❌ npm required but not installed. Aborting." >&2; exit 1; }

# Copy environment file
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
    echo "⚠️  Please edit .env file with your API keys"
fi

# Start Docker services
echo "🐳 Starting Docker services..."
docker-compose up -d

# Wait for services
echo "⏳ Waiting for services to start..."
sleep 10

# Setup Saleor
if [ -f scripts/setup-saleor.sh ]; then
    echo "🛒 Setting up Saleor..."
    bash scripts/setup-saleor.sh
fi

# Install frontend dependencies
echo "📦 Installing frontend dependencies..."
cd frontend
npm install

echo ""
echo "✅ Setup complete!"
echo ""
echo "🔗 Service URLs:"
echo "   Frontend: http://localhost:3000"
echo "   Saleor API: http://localhost:8000/graphql/"
echo "   Saleor Admin: http://localhost:8000/dashboard/"
echo "   n8n Automation: http://localhost:5678"
echo ""
echo "📚 Next steps:"
echo "   1. Edit .env file with your API keys"
echo "   2. Run 'npm run dev' in frontend/ directory"
echo "   3. Access admin panel and configure products"