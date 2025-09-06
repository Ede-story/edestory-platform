#!/usr/bin/env node

/**
 * 💳 Скрипт для сохранения Stripe ключей
 * Stripe работает в тестовом режиме без юрлица
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const question = (query) => new Promise(resolve => rl.question(query, resolve));

console.log('\x1b[34m╔═══════════════════════════════════════════════════════╗\x1b[0m');
console.log('\x1b[34m║   \x1b[32m💳 Настройка Stripe для платежей\x1b[34m                 ║\x1b[0m');
console.log('\x1b[34m╚═══════════════════════════════════════════════════════╝\x1b[0m\n');

console.log('\x1b[36m📝 Инструкция:\x1b[0m');
console.log('1. Зарегистрируйтесь: \x1b[36mhttps://dashboard.stripe.com/register\x1b[0m');
console.log('2. Активируйте \x1b[33mTest Mode\x1b[0m в правом верхнем углу');
console.log('3. Перейдите: Developers → API keys');
console.log('4. Скопируйте оба ключа\n');

async function saveStripeKeys() {
  try {
    console.log('\x1b[33m⚠️  Используйте ТЕСТОВЫЕ ключи (начинаются с pk_test_ и sk_test_)\x1b[0m\n');
    
    // Запрашиваем ключи
    const publicKey = await question('\x1b[36mPublishable key (pk_test_...):\x1b[0m ');
    const secretKey = await question('\x1b[36mSecret key (sk_test_...):\x1b[0m ');
    
    // Валидация
    if (!publicKey.startsWith('pk_test_')) {
      console.log('\x1b[31m❌ Publishable key должен начинаться с pk_test_\x1b[0m');
      console.log('\x1b[33mУбедитесь что Test Mode включен!\x1b[0m');
      process.exit(1);
    }
    
    if (!secretKey.startsWith('sk_test_')) {
      console.log('\x1b[31m❌ Secret key должен начинаться с sk_test_\x1b[0m');
      console.log('\x1b[33mУбедитесь что Test Mode включен!\x1b[0m');
      process.exit(1);
    }
    
    // Путь к .env.local
    const envPath = path.join(__dirname, '..', 'frontend', '.env.local');
    
    // Читаем существующий файл
    let envContent = '';
    if (fs.existsSync(envPath)) {
      envContent = fs.readFileSync(envPath, 'utf8');
    }
    
    // Обновляем или добавляем ключи
    const updateEnvVar = (content, key, value) => {
      const regex = new RegExp(`^${key}=.*$`, 'gm');
      if (regex.test(content)) {
        return content.replace(regex, `${key}=${value}`);
      } else {
        return content + (content.endsWith('\n') ? '' : '\n') + `${key}=${value}\n`;
      }
    };
    
    envContent = updateEnvVar(envContent, 'STRIPE_PUBLIC_KEY', publicKey);
    envContent = updateEnvVar(envContent, 'STRIPE_SECRET_KEY', secretKey);
    envContent = updateEnvVar(envContent, 'STRIPE_WEBHOOK_SECRET', 'whsec_test_secret');
    envContent = updateEnvVar(envContent, 'STRIPE_MODE', 'test');
    
    // Сохраняем
    fs.writeFileSync(envPath, envContent);
    
    console.log('\n\x1b[32m✅ Stripe ключи сохранены!\x1b[0m\n');
    
    // Тестовые карты
    console.log('\x1b[34m═══════════════════════════════════════════════════════\x1b[0m');
    console.log('\x1b[36m💳 Тестовые карты для проверки:\x1b[0m\n');
    console.log('  \x1b[32m✅ Успешный платеж:\x1b[0m 4242 4242 4242 4242');
    console.log('  \x1b[31m❌ Отклонение:\x1b[0m 4000 0000 0000 0002');
    console.log('  \x1b[33m⚠️  3D Secure:\x1b[0m 4000 0025 0000 3155');
    console.log('\n  CVV: любые 3 цифры');
    console.log('  Дата: любая в будущем\n');
    
    console.log('\x1b[34m═══════════════════════════════════════════════════════\x1b[0m');
    console.log('\x1b[32m🎯 Готово к приему тестовых платежей!\x1b[0m\n');
    
    console.log('Теперь можно:');
    console.log('  • Принимать тестовые платежи');
    console.log('  • Тестировать checkout процесс');
    console.log('  • Обрабатывать webhooks');
    console.log('  • Управлять подписками\n');
    
    console.log('\x1b[36mДашборд Stripe:\x1b[0m https://dashboard.stripe.com/test/dashboard');
    console.log('\x1b[36mТестовые платежи:\x1b[0m https://dashboard.stripe.com/test/payments\n');
    
  } catch (error) {
    console.error('\x1b[31m❌ Ошибка:', error.message, '\x1b[0m');
    process.exit(1);
  } finally {
    rl.close();
  }
}

// Запускаем
saveStripeKeys();