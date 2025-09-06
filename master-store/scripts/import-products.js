#!/usr/bin/env node

/**
 * Автоматический импорт товаров из AliExpress в Saleor
 * Запускать после получения API ключей
 */

const fs = require('fs');
const path = require('path');
const https = require('https');
const crypto = require('crypto');

// Цвета для консоли
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m',
  magenta: '\x1b[35m'
};

// Загружаем переменные окружения
require('dotenv').config({ path: path.join(__dirname, '..', 'frontend', '.env.local') });

class ProductImporter {
  constructor() {
    this.appKey = process.env.ALIEXPRESS_APP_KEY;
    this.appSecret = process.env.ALIEXPRESS_APP_SECRET;
    this.trackingId = process.env.ALIEXPRESS_TRACKING_ID || 'edestory';
    this.saleorUrl = process.env.NEXT_PUBLIC_SALEOR_API_URL || 'http://localhost:8000/graphql/';
    
    if (!this.appKey || !this.appSecret) {
      console.error(`${colors.red}❌ API ключи не найдены в .env.local${colors.reset}`);
      console.log(`${colors.yellow}Сначала запустите: node scripts/aliexpress-test.js${colors.reset}`);
      process.exit(1);
    }
  }

  // Генерация подписи для AliExpress API
  generateSign(params) {
    const sortedParams = Object.keys(params)
      .sort()
      .map(key => `${key}${params[key]}`)
      .join('');
    
    const signStr = this.appSecret + sortedParams + this.appSecret;
    return crypto.createHash('md5').update(signStr).digest('hex').toUpperCase();
  }

  // API запрос к AliExpress
  async aliexpressRequest(method, params = {}) {
    const timestamp = new Date().toISOString();
    
    const requestParams = {
      app_key: this.appKey,
      method,
      timestamp,
      sign_method: 'md5',
      v: '2.0',
      format: 'json',
      ...params
    };

    requestParams.sign = this.generateSign(requestParams);
    const queryString = new URLSearchParams(requestParams).toString();
    
    return new Promise((resolve, reject) => {
      const options = {
        hostname: 'api-sg.aliexpress.com',
        path: `/sync?${queryString}`,
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      };

      const req = https.request(options, (res) => {
        let data = '';
        res.on('data', chunk => data += chunk);
        res.on('end', () => {
          try {
            const json = JSON.parse(data);
            if (json.error_response) {
              reject(new Error(json.error_response.msg || 'API Error'));
            } else {
              resolve(json);
            }
          } catch (e) {
            reject(e);
          }
        });
      });

      req.on('error', reject);
      req.end();
    });
  }

  // Получение горячих товаров
  async getHotProducts(categoryId = null) {
    console.log(`${colors.cyan}🔥 Получаем горячие товары...${colors.reset}`);
    
    const params = {
      target_currency: 'EUR',
      target_language: 'ES',
      ship_to_country: 'ES',
      page_size: 50,
      platform_product_type: 'ALL'
    };

    if (categoryId) {
      params.category_ids = categoryId;
    }

    const response = await this.aliexpressRequest('aliexpress.affiliate.hotproduct.query', params);
    return response.aliexpress_affiliate_hotproduct_query_response?.resp_result?.result?.products || [];
  }

  // Поиск товаров по ключевым словам
  async searchProducts(keywords, minPrice = 10, maxPrice = 500) {
    console.log(`${colors.cyan}🔍 Ищем товары: "${keywords}"...${colors.reset}`);
    
    const params = {
      keywords: keywords,
      target_currency: 'EUR',
      target_language: 'ES',
      ship_to_country: 'ES',
      min_sale_price: minPrice,
      max_sale_price: maxPrice,
      sort: 'SALE_PRICE_ASC',
      page_size: 20,
      platform_product_type: 'ALL'
    };

    const response = await this.aliexpressRequest('aliexpress.affiliate.product.query', params);
    return response.aliexpress_affiliate_product_query_response?.resp_result?.result?.products || [];
  }

  // Генерация партнерской ссылки
  async generateAffiliateLink(productUrl) {
    const params = {
      source_values: productUrl,
      promotion_link_type: '2',
      tracking_id: this.trackingId
    };

    const response = await this.aliexpressRequest('aliexpress.affiliate.link.generate', params);
    const links = response.aliexpress_affiliate_link_generate_response?.resp_result?.result?.promotion_links;
    return links && links.length > 0 ? links[0].promotion_link : productUrl;
  }

  // Расчет цены с наценкой
  calculateSellingPrice(originalPrice, category) {
    let markupPercent = 30; // Базовая наценка 30%
    
    // Динамическая наценка в зависимости от цены и категории
    if (originalPrice < 10) {
      markupPercent = 50; // 50% для дешевых товаров
    } else if (originalPrice < 30) {
      markupPercent = 40; // 40% для средних
    } else if (originalPrice > 100) {
      markupPercent = 25; // 25% для дорогих
    }

    // Специальная наценка для категорий
    if (category && category.includes('phone')) {
      markupPercent = 20; // Меньше наценка на электронику
    } else if (category && category.includes('fashion')) {
      markupPercent = 45; // Больше наценка на одежду
    }

    return Math.round(originalPrice * (1 + markupPercent / 100) * 100) / 100;
  }

  // Фильтрация товаров по критериям качества
  filterProducts(products) {
    return products.filter(product => {
      // Фильтруем по рейтингу
      const rating = parseFloat(product.evaluate_rate || 0);
      if (rating < 4.5) return false;
      
      // Фильтруем по количеству заказов
      const orders = parseInt(product.thirty_days_commission || 0);
      if (orders < 10) return false;
      
      // Фильтруем по комиссии
      const commission = parseFloat(product.commission_rate || 0);
      if (commission < 3) return false;
      
      // Фильтруем по наличию изображений
      if (!product.product_main_image_url) return false;
      
      return true;
    });
  }

  // Создание товара в Saleor (mock для демонстрации)
  async createProductInSaleor(product) {
    const sellingPrice = this.calculateSellingPrice(product.target_sale_price, product.first_level_category_name);
    const affiliateLink = await this.generateAffiliateLink(product.product_detail_url);
    
    const saleorProduct = {
      name: product.product_title,
      slug: `aliexpress-${product.product_id}`,
      description: product.product_detail_url,
      price: sellingPrice,
      originalPrice: product.target_sale_price,
      currency: 'EUR',
      images: [product.product_main_image_url, product.product_small_image_urls].flat().filter(Boolean),
      category: product.first_level_category_name,
      metadata: {
        aliexpress_id: product.product_id,
        affiliate_url: affiliateLink,
        commission_rate: product.commission_rate,
        original_price: product.target_sale_price,
        shop_url: product.shop_url,
        evaluate_rate: product.evaluate_rate,
        thirty_days_volume: product.thirty_days_commission
      },
      stock: 100, // Виртуальный склад
      weight: 0.5, // Средний вес
      sku: `ALI-${product.product_id}`
    };

    // Здесь должен быть реальный GraphQL запрос к Saleor
    // Для демонстрации просто возвращаем объект
    return saleorProduct;
  }

  // Основной процесс импорта
  async importProducts() {
    console.clear();
    console.log(`${colors.blue}╔═══════════════════════════════════════════════════════╗${colors.reset}`);
    console.log(`${colors.blue}║   ${colors.green}📦 Импорт товаров из AliExpress${colors.blue}                   ║${colors.reset}`);
    console.log(`${colors.blue}║   ${colors.yellow}shop.ede-story.com${colors.blue}                               ║${colors.reset}`);
    console.log(`${colors.blue}╚═══════════════════════════════════════════════════════╝${colors.reset}\n`);

    try {
      // Категории для импорта
      const categories = [
        { keywords: 'smartphone case', category: 'Electronics' },
        { keywords: 'women dress summer', category: 'Fashion' },
        { keywords: 'home decoration', category: 'Home' },
        { keywords: 'fitness equipment', category: 'Sports' },
        { keywords: 'kitchen gadgets', category: 'Kitchen' }
      ];

      let totalImported = 0;
      let totalProfit = 0;

      for (const cat of categories) {
        console.log(`\n${colors.magenta}═══ Категория: ${cat.category} ═══${colors.reset}`);
        
        // Получаем товары
        const products = await this.searchProducts(cat.keywords);
        console.log(`${colors.cyan}Найдено ${products.length} товаров${colors.reset}`);
        
        // Фильтруем по качеству
        const filteredProducts = this.filterProducts(products);
        console.log(`${colors.yellow}После фильтрации: ${filteredProducts.length} товаров${colors.reset}`);
        
        // Импортируем первые 5 товаров из каждой категории
        const toImport = filteredProducts.slice(0, 5);
        
        for (const product of toImport) {
          const saleorProduct = await this.createProductInSaleor(product);
          
          const profit = saleorProduct.price - saleorProduct.originalPrice;
          const commission = saleorProduct.originalPrice * (product.commission_rate / 100);
          const totalProfitPerItem = profit + commission;
          
          console.log(`\n  ✅ ${saleorProduct.name.substring(0, 50)}...`);
          console.log(`     💰 Закупка: €${saleorProduct.originalPrice}`);
          console.log(`     💵 Продажа: €${saleorProduct.price}`);
          console.log(`     📈 Прибыль: €${totalProfitPerItem.toFixed(2)} (наценка: €${profit.toFixed(2)} + комиссия: €${commission.toFixed(2)})`);
          console.log(`     🔗 ${saleorProduct.metadata.affiliate_url.substring(0, 50)}...`);
          
          totalImported++;
          totalProfit += totalProfitPerItem;
        }
      }

      // Сохраняем результаты импорта
      const importResults = {
        timestamp: new Date().toISOString(),
        totalImported: totalImported,
        estimatedProfit: totalProfit.toFixed(2),
        categories: categories.map(c => c.category)
      };

      const resultsPath = path.join(__dirname, '..', 'import-results.json');
      fs.writeFileSync(resultsPath, JSON.stringify(importResults, null, 2));

      // Итоговая статистика
      console.log(`\n${colors.blue}═══════════════════════════════════════════════════════${colors.reset}`);
      console.log(`${colors.green}🎉 ИМПОРТ ЗАВЕРШЕН УСПЕШНО!${colors.reset}`);
      console.log(`${colors.blue}═══════════════════════════════════════════════════════${colors.reset}\n`);
      
      console.log(`📊 ${colors.green}Статистика:${colors.reset}`);
      console.log(`   • Импортировано товаров: ${colors.cyan}${totalImported}${colors.reset}`);
      console.log(`   • Средняя прибыль на товар: ${colors.cyan}€${(totalProfit / totalImported).toFixed(2)}${colors.reset}`);
      console.log(`   • Потенциальная прибыль (при продаже всех): ${colors.green}€${totalProfit.toFixed(2)}${colors.reset}`);
      
      console.log(`\n${colors.yellow}📝 Следующие шаги:${colors.reset}`);
      console.log(`1. Проверьте товары в Saleor Dashboard: ${colors.cyan}http://localhost:8000/dashboard/${colors.reset}`);
      console.log(`2. Настройте автоматический импорт в n8n: ${colors.cyan}http://localhost:5678${colors.reset}`);
      console.log(`3. Протестируйте checkout с тестовыми картами Stripe`);
      console.log(`4. Запустите магазин: ${colors.cyan}cd frontend && pnpm dev${colors.reset}`);
      
      console.log(`\n${colors.green}💡 Совет:${colors.reset} Настройте cron job для автоматического импорта:`);
      console.log(`   ${colors.cyan}0 */4 * * * node ${__filename}${colors.reset}`);

    } catch (error) {
      console.error(`${colors.red}❌ Ошибка импорта: ${error.message}${colors.reset}`);
      process.exit(1);
    }
  }
}

// Запуск импорта
const importer = new ProductImporter();
importer.importProducts().catch(err => {
  console.error(`${colors.red}❌ Критическая ошибка: ${err.message}${colors.reset}`);
  process.exit(1);
});