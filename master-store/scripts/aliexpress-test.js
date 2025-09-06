#!/usr/bin/env node

/**
 * AliExpress Affiliate API Test Script
 * Проверяет работоспособность API после получения ключей
 */

const crypto = require('crypto');
const https = require('https');
const readline = require('readline');

// Цвета для консоли
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m'
};

// Интерфейс для ввода
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Функция для запроса данных у пользователя
const question = (query) => new Promise(resolve => rl.question(query, resolve));

class AliExpressAPI {
  constructor(appKey, appSecret) {
    this.appKey = appKey;
    this.appSecret = appSecret;
    this.apiUrl = 'api-sg.aliexpress.com';
  }

  // Генерация подписи
  generateSign(params) {
    const sortedParams = Object.keys(params)
      .sort()
      .map(key => `${key}${params[key]}`)
      .join('');
    
    const signStr = this.appSecret + sortedParams + this.appSecret;
    return crypto.createHash('md5').update(signStr).digest('hex').toUpperCase();
  }

  // Выполнение API запроса
  async makeRequest(method, params = {}) {
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
        hostname: this.apiUrl,
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

  // Тест 1: Получение категорий
  async testGetCategories() {
    console.log(`\n${colors.cyan}📂 Тест 1: Получение категорий...${colors.reset}`);
    try {
      const response = await this.makeRequest('aliexpress.affiliate.category.get');
      const categories = response.aliexpress_affiliate_category_get_response?.resp_result?.result?.categories;
      
      if (categories && categories.length > 0) {
        console.log(`${colors.green}✅ Успешно! Найдено ${categories.length} категорий${colors.reset}`);
        console.log(`Примеры категорий:`);
        categories.slice(0, 5).forEach(cat => {
          console.log(`  - ${cat.category_name} (ID: ${cat.category_id})`);
        });
        return true;
      }
    } catch (error) {
      console.log(`${colors.red}❌ Ошибка: ${error.message}${colors.reset}`);
      return false;
    }
  }

  // Тест 2: Поиск горячих товаров
  async testHotProducts() {
    console.log(`\n${colors.cyan}🔥 Тест 2: Поиск горячих товаров...${colors.reset}`);
    try {
      const response = await this.makeRequest('aliexpress.affiliate.hotproduct.query', {
        target_currency: 'EUR',
        target_language: 'ES',
        ship_to_country: 'ES',
        page_size: 10
      });
      
      const products = response.aliexpress_affiliate_hotproduct_query_response?.resp_result?.result?.products;
      
      if (products && products.length > 0) {
        console.log(`${colors.green}✅ Успешно! Найдено ${products.length} горячих товаров${colors.reset}`);
        console.log(`Примеры товаров:`);
        products.slice(0, 3).forEach(product => {
          console.log(`  - ${product.product_title.substring(0, 50)}...`);
          console.log(`    Цена: €${product.target_sale_price} | Комиссия: ${product.commission_rate}%`);
        });
        return true;
      }
    } catch (error) {
      console.log(`${colors.red}❌ Ошибка: ${error.message}${colors.reset}`);
      return false;
    }
  }

  // Тест 3: Поиск товаров по ключевым словам
  async testProductSearch(keywords = 'phone case') {
    console.log(`\n${colors.cyan}🔍 Тест 3: Поиск товаров по запросу "${keywords}"...${colors.reset}`);
    try {
      const response = await this.makeRequest('aliexpress.affiliate.product.query', {
        keywords: keywords,
        target_currency: 'EUR',
        target_language: 'ES',
        ship_to_country: 'ES',
        page_size: 5
      });
      
      const products = response.aliexpress_affiliate_product_query_response?.resp_result?.result?.products;
      
      if (products && products.length > 0) {
        console.log(`${colors.green}✅ Успешно! Найдено ${products.length} товаров${colors.reset}`);
        products.forEach(product => {
          const profit = (product.target_sale_price * 0.3).toFixed(2); // 30% наценка
          const commission = (product.target_sale_price * product.commission_rate / 100).toFixed(2);
          console.log(`\n  📦 ${product.product_title.substring(0, 60)}...`);
          console.log(`     💰 Цена: €${product.target_sale_price}`);
          console.log(`     📈 Наша цена (с наценкой 30%): €${(product.target_sale_price * 1.3).toFixed(2)}`);
          console.log(`     💵 Комиссия AliExpress: €${commission} (${product.commission_rate}%)`);
          console.log(`     ✨ Чистая прибыль: €${(parseFloat(profit) + parseFloat(commission)).toFixed(2)}`);
        });
        return true;
      }
    } catch (error) {
      console.log(`${colors.red}❌ Ошибка: ${error.message}${colors.reset}`);
      return false;
    }
  }

  // Тест 4: Генерация партнерской ссылки
  async testGenerateLink() {
    console.log(`\n${colors.cyan}🔗 Тест 4: Генерация партнерской ссылки...${colors.reset}`);
    try {
      const testUrl = 'https://www.aliexpress.com/item/1005001.html';
      const response = await this.makeRequest('aliexpress.affiliate.link.generate', {
        source_values: testUrl,
        promotion_link_type: '2'
      });
      
      const links = response.aliexpress_affiliate_link_generate_response?.resp_result?.result?.promotion_links;
      
      if (links && links.length > 0) {
        console.log(`${colors.green}✅ Успешно! Партнерская ссылка создана${colors.reset}`);
        console.log(`  🔗 ${links[0].promotion_link}`);
        return true;
      }
    } catch (error) {
      console.log(`${colors.red}❌ Ошибка: ${error.message}${colors.reset}`);
      return false;
    }
  }
}

// Главная функция
async function main() {
  console.clear();
  console.log(`${colors.blue}╔═══════════════════════════════════════════════════════╗${colors.reset}`);
  console.log(`${colors.blue}║   ${colors.green}🚀 AliExpress Affiliate API Тестер${colors.blue}                 ║${colors.reset}`);
  console.log(`${colors.blue}║   ${colors.yellow}Для Edestory Shop - shop.ede-story.com${colors.blue}            ║${colors.reset}`);
  console.log(`${colors.blue}╚═══════════════════════════════════════════════════════╝${colors.reset}\n`);

  console.log(`${colors.yellow}📝 Введите ваши API ключи из AliExpress Affiliate Portal:${colors.reset}`);
  console.log(`${colors.cyan}(Получить на: https://portals.aliexpress.com/affiportals/web/appManage.htm)${colors.reset}\n`);

  const appKey = await question(`App Key: `);
  const appSecret = await question(`App Secret: `);

  if (!appKey || !appSecret) {
    console.log(`${colors.red}\n❌ Ключи не введены. Используем тестовый режим...${colors.reset}`);
    console.log(`${colors.yellow}⚠️  Для полноценной работы необходимо получить реальные ключи${colors.reset}`);
    rl.close();
    return;
  }

  console.log(`\n${colors.green}✅ Ключи получены. Начинаем тестирование...${colors.reset}`);

  const api = new AliExpressAPI(appKey.trim(), appSecret.trim());
  
  // Выполняем все тесты
  const results = [];
  results.push(await api.testGetCategories());
  results.push(await api.testHotProducts());
  results.push(await api.testProductSearch('smartphone'));
  results.push(await api.testGenerateLink());

  // Итоги
  console.log(`\n${colors.blue}═══════════════════════════════════════════════════════${colors.reset}`);
  console.log(`${colors.green}📊 РЕЗУЛЬТАТЫ ТЕСТИРОВАНИЯ:${colors.reset}`);
  
  const successCount = results.filter(r => r).length;
  const totalCount = results.length;
  
  if (successCount === totalCount) {
    console.log(`${colors.green}🎉 Все тесты пройдены успешно! (${successCount}/${totalCount})${colors.reset}`);
    console.log(`\n${colors.cyan}✅ API ключи рабочие и готовы к использованию!${colors.reset}`);
    
    // Сохраняем ключи в .env
    console.log(`\n${colors.yellow}💾 Сохраняю ключи в .env.local...${colors.reset}`);
    
    const fs = require('fs');
    const path = require('path');
    const envPath = path.join(__dirname, '..', 'frontend', '.env.local');
    
    // Читаем существующий .env.local
    let envContent = fs.readFileSync(envPath, 'utf8');
    
    // Обновляем ключи
    envContent = envContent.replace(/ALIEXPRESS_APP_KEY=.*/, `ALIEXPRESS_APP_KEY=${appKey}`);
    envContent = envContent.replace(/ALIEXPRESS_APP_SECRET=.*/, `ALIEXPRESS_APP_SECRET=${appSecret}`);
    
    fs.writeFileSync(envPath, envContent);
    console.log(`${colors.green}✅ Ключи сохранены в frontend/.env.local${colors.reset}`);
    
    console.log(`\n${colors.green}🚀 СЛЕДУЮЩИЕ ШАГИ:${colors.reset}`);
    console.log(`1. Запустите импорт товаров: ${colors.cyan}npm run import:products${colors.reset}`);
    console.log(`2. Проверьте товары в Saleor: ${colors.cyan}http://localhost:8000/dashboard/${colors.reset}`);
    console.log(`3. Настройте n8n для автоматизации: ${colors.cyan}http://localhost:5678${colors.reset}`);
  } else {
    console.log(`${colors.red}⚠️  Некоторые тесты не прошли (${successCount}/${totalCount})${colors.reset}`);
    console.log(`${colors.yellow}Проверьте правильность API ключей и попробуйте снова${colors.reset}`);
  }

  console.log(`\n${colors.blue}═══════════════════════════════════════════════════════${colors.reset}`);
  
  // Спрашиваем про Tracking ID
  const trackingId = await question(`\n${colors.yellow}Введите Tracking ID (опционально, нажмите Enter чтобы пропустить): ${colors.reset}`);
  
  if (trackingId) {
    const envPath = path.join(__dirname, '..', 'frontend', '.env.local');
    let envContent = fs.readFileSync(envPath, 'utf8');
    envContent = envContent.replace(/ALIEXPRESS_TRACKING_ID=.*/, `ALIEXPRESS_TRACKING_ID=${trackingId}`);
    fs.writeFileSync(envPath, envContent);
    console.log(`${colors.green}✅ Tracking ID сохранен${colors.reset}`);
  }

  rl.close();
}

// Обработка ошибок
process.on('unhandledRejection', (err) => {
  console.error(`${colors.red}❌ Критическая ошибка: ${err.message}${colors.reset}`);
  process.exit(1);
});

// Запуск
main().catch(err => {
  console.error(`${colors.red}❌ Ошибка: ${err.message}${colors.reset}`);
  process.exit(1);
});