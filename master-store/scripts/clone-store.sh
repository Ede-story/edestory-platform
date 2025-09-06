#!/bin/bash

# Clone Store Script for B2B Clients
# Usage: ./clone-store.sh <client-name> <domain>
# Example: ./clone-store.sh acme-corp shop.acme-corp.com

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check arguments
if [ "$#" -ne 2 ]; then
    echo -e "${RED}Error: Missing arguments${NC}"
    echo "Usage: $0 <client-name> <domain>"
    echo "Example: $0 acme-corp shop.acme-corp.com"
    exit 1
fi

CLIENT_NAME=$1
DOMAIN=$2
CLIENT_DIR="../client-stores/$CLIENT_NAME"

echo -e "${YELLOW}🚀 Cloning store for: $CLIENT_NAME${NC}"
echo -e "${YELLOW}📍 Domain: $DOMAIN${NC}"

# Create client directory
echo -e "\n${GREEN}1. Creating client directory...${NC}"
mkdir -p "../client-stores"
if [ -d "$CLIENT_DIR" ]; then
    echo -e "${RED}Error: Client directory already exists: $CLIENT_DIR${NC}"
    echo -e "Remove it first or choose a different name"
    exit 1
fi

# Clone the master store
echo -e "\n${GREEN}2. Cloning master store...${NC}"
cp -r ../master-store "$CLIENT_DIR"

# Update environment variables
echo -e "\n${GREEN}3. Configuring environment...${NC}"
cat > "$CLIENT_DIR/frontend/.env.local" << EOF
# Saleor API Configuration
NEXT_PUBLIC_SALEOR_API_URL=https://api.saleor.cloud/graphql/
NEXT_PUBLIC_API_URI=https://api.saleor.cloud/graphql/
SALEOR_APP_TOKEN=

# Site Configuration
NEXT_PUBLIC_STOREFRONT_NAME=$CLIENT_NAME Shop
NEXT_PUBLIC_DEFAULT_CHANNEL=$CLIENT_NAME-channel
NEXT_PUBLIC_HOMEPAGE_MENU=navbar

# Payment Gateways
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=
NEXT_PUBLIC_PAYPAL_CLIENT_ID=

# Analytics
NEXT_PUBLIC_GA_TRACKING_ID=
NEXT_PUBLIC_GTM_ID=

# Localization
NEXT_PUBLIC_DEFAULT_LOCALE=es
NEXT_PUBLIC_LOCALES=es,en,ru

# Domain
NEXT_PUBLIC_VERCEL_URL=$DOMAIN
NEXT_PUBLIC_URL=https://$DOMAIN

# Profit Sharing Configuration
PROFIT_SHARING_PERCENTAGE=20
CLIENT_PERCENTAGE=80
EOF

# Update Docker Compose with unique container names
echo -e "\n${GREEN}4. Configuring Docker...${NC}"
sed -i '' "s/edestory-postgres/${CLIENT_NAME}-postgres/g" "$CLIENT_DIR/docker-compose.yml"
sed -i '' "s/edestory-redis/${CLIENT_NAME}-redis/g" "$CLIENT_DIR/docker-compose.yml"
sed -i '' "s/edestory-saleor/${CLIENT_NAME}-saleor/g" "$CLIENT_DIR/docker-compose.yml"
sed -i '' "s/edestory-dashboard/${CLIENT_NAME}-dashboard/g" "$CLIENT_DIR/docker-compose.yml"
sed -i '' "s/edestory-n8n/${CLIENT_NAME}-n8n/g" "$CLIENT_DIR/docker-compose.yml"
sed -i '' "s/edestory-network/${CLIENT_NAME}-network/g" "$CLIENT_DIR/docker-compose.yml"

# Update package.json with client name
echo -e "\n${GREEN}5. Updating package info...${NC}"
sed -i '' "s/\"name\": \"saleor-storefront\"/\"name\": \"${CLIENT_NAME}-storefront\"/g" "$CLIENT_DIR/frontend/package.json"

# Create deployment script
echo -e "\n${GREEN}6. Creating deployment script...${NC}"
cat > "$CLIENT_DIR/deploy.sh" << 'EOF'
#!/bin/bash

echo "🚀 Deploying to production..."

# Build frontend
cd frontend
npm run build

# Start services
cd ..
docker-compose up -d

echo "✅ Deployment complete!"
echo "📍 Storefront: http://localhost:3000"
echo "📍 Admin: http://localhost:9000"
echo "📍 API: http://localhost:8000/graphql/"
echo "📍 n8n: http://localhost:5678"
EOF

chmod +x "$CLIENT_DIR/deploy.sh"

# Create profit sharing calculator
echo -e "\n${GREEN}7. Creating profit sharing calculator...${NC}"
cat > "$CLIENT_DIR/profit-calculator.js" << 'EOF'
#!/usr/bin/env node

// Profit Sharing Calculator (20/80 split)
const PLATFORM_SHARE = 0.20; // 20% for Edestory
const CLIENT_SHARE = 0.80;   // 80% for client

function calculateProfit(revenue, costs) {
    const profit = revenue - costs;
    const platformEarnings = profit * PLATFORM_SHARE;
    const clientEarnings = profit * CLIENT_SHARE;
    
    console.log(`
    📊 Profit Sharing Report
    ========================
    Revenue:          €${revenue.toFixed(2)}
    Costs:           -€${costs.toFixed(2)}
    --------------------------------
    Profit:           €${profit.toFixed(2)}
    
    💰 Distribution:
    Client (80%):     €${clientEarnings.toFixed(2)}
    Platform (20%):   €${platformEarnings.toFixed(2)}
    `);
    
    return {
        profit,
        clientEarnings,
        platformEarnings
    };
}

// Example calculation
if (require.main === module) {
    const args = process.argv.slice(2);
    if (args.length !== 2) {
        console.log("Usage: node profit-calculator.js <revenue> <costs>");
        console.log("Example: node profit-calculator.js 10000 6000");
        process.exit(1);
    }
    
    const revenue = parseFloat(args[0]);
    const costs = parseFloat(args[1]);
    
    calculateProfit(revenue, costs);
}

module.exports = { calculateProfit };
EOF

chmod +x "$CLIENT_DIR/profit-calculator.js"

# Create README for client
echo -e "\n${GREEN}8. Creating documentation...${NC}"
cat > "$CLIENT_DIR/README.md" << EOF
# $CLIENT_NAME E-commerce Store

Welcome to your dropshipping store powered by Edestory platform!

## 🚀 Quick Start

1. **Install dependencies:**
   \`\`\`bash
   cd frontend
   npm install
   \`\`\`

2. **Configure environment:**
   - Edit \`frontend/.env.local\` with your API keys
   - Update Stripe/PayPal credentials
   - Configure Google Analytics

3. **Start development:**
   \`\`\`bash
   npm run dev
   \`\`\`

4. **Deploy to production:**
   \`\`\`bash
   ./deploy.sh
   \`\`\`

## 📊 Profit Sharing

Your store operates on a 20/80 profit sharing model:
- **Your share:** 80% of profits
- **Platform fee:** 20% of profits

Calculate your earnings:
\`\`\`bash
node profit-calculator.js <revenue> <costs>
\`\`\`

## 🔗 Important URLs

- **Your store:** https://$DOMAIN
- **Admin panel:** https://$DOMAIN/admin
- **API endpoint:** https://$DOMAIN/graphql/
- **Automation:** https://$DOMAIN:5678

## 📞 Support

- **Email:** support@ede-story.com
- **Documentation:** https://docs.ede-story.com
- **Emergency:** +34 XXX XXX XXX

## 🎯 Features

- ✅ Multi-language support (ES/EN/RU)
- ✅ Fast shipping from Spain (1-3 days)
- ✅ Automated order processing
- ✅ AI-powered content generation
- ✅ Social media automation
- ✅ Real-time analytics

---
Powered by Edestory Platform © 2025
EOF

# Summary
echo -e "\n${GREEN}✅ Store cloned successfully!${NC}"
echo -e "\n📁 Location: ${YELLOW}$CLIENT_DIR${NC}"
echo -e "\n📋 Next steps:"
echo -e "  1. cd $CLIENT_DIR"
echo -e "  2. Edit frontend/.env.local with API keys"
echo -e "  3. cd frontend && npm install"
echo -e "  4. npm run dev"
echo -e "\n💰 Profit sharing: ${GREEN}80% client / 20% platform${NC}"
echo -e "\n🚀 Ready to launch at: ${YELLOW}https://$DOMAIN${NC}"