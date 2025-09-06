#!/bin/bash

# Edestory Shop - Vercel Deployment Script
# Usage: ./scripts/deploy.sh [preview|production]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
FRONTEND_DIR="./frontend"
ENVIRONMENT=${1:-preview}

echo -e "${GREEN}🚀 Edestory Shop Deployment Script${NC}"
echo -e "${YELLOW}Environment: $ENVIRONMENT${NC}\n"

# Check if we're in the right directory
if [ ! -d "$FRONTEND_DIR" ]; then
    echo -e "${RED}Error: Frontend directory not found!${NC}"
    echo "Please run this script from the master-store directory"
    exit 1
fi

cd $FRONTEND_DIR

# Run tests before deployment
echo -e "${YELLOW}📋 Running pre-deployment checks...${NC}"

echo "1. Checking TypeScript..."
pnpm typecheck || {
    echo -e "${RED}❌ TypeScript errors found!${NC}"
    exit 1
}

echo "2. Running linter..."
pnpm lint || {
    echo -e "${RED}❌ Linting errors found!${NC}"
    exit 1
}

echo "3. Building project..."
pnpm build || {
    echo -e "${RED}❌ Build failed!${NC}"
    exit 1
}

echo -e "${GREEN}✅ All checks passed!${NC}\n"

# Deploy to Vercel
if [ "$ENVIRONMENT" == "production" ]; then
    echo -e "${YELLOW}🌍 Deploying to PRODUCTION...${NC}"
    echo -e "${RED}⚠️  This will affect live users!${NC}"
    read -p "Are you sure? (yes/no): " confirm
    
    if [ "$confirm" != "yes" ]; then
        echo "Deployment cancelled"
        exit 0
    fi
    
    vercel --prod
else
    echo -e "${YELLOW}👁️  Creating preview deployment...${NC}"
    vercel
fi

echo -e "\n${GREEN}✅ Deployment complete!${NC}"

# Show deployment info
echo -e "\n${YELLOW}📊 Deployment Info:${NC}"
echo "- Environment: $ENVIRONMENT"
echo "- Timestamp: $(date)"

# If production, remind about monitoring
if [ "$ENVIRONMENT" == "production" ]; then
    echo -e "\n${YELLOW}📈 Next steps:${NC}"
    echo "1. Check deployment at: https://shop.ede-story.com"
    echo "2. Monitor analytics at: https://vercel.com/edestory/shop/analytics"
    echo "3. Check logs: vercel logs --follow"
    echo "4. Test checkout flow with test card: 4242 4242 4242 4242"
fi

echo -e "\n${GREEN}🎉 Done!${NC}"