#!/usr/bin/env node

/**
 * Автоматическая настройка API Email
 * Запускать после создания api.edestory@gmail.com
 */

const fs = require('fs');
const path = require('path');
const readline = require('readline');
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

// Интерфейс для ввода
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const question = (query) => new Promise(resolve => rl.question(query, resolve));

class EmailSetup {
  constructor() {
    this.email = 'api.edestory@gmail.com';
    this.configPath = path.join(__dirname, '..', 'config', 'api-credentials.json');
    this.envPath = path.join(__dirname, '..', 'frontend', '.env.local');
  }

  // Генерация безопасных паролей
  generateSecurePassword(length = 16) {
    const charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*';
    let password = '';
    const randomBytes = crypto.randomBytes(length);
    
    for (let i = 0; i < length; i++) {
      password += charset[randomBytes[i] % charset.length];
    }
    
    return password;
  }

  // Сохранение credentials
  async saveCredentials(credentials) {
    const configDir = path.dirname(this.configPath);
    if (!fs.existsSync(configDir)) {
      fs.mkdirSync(configDir, { recursive: true });
    }

    const config = {
      email: this.email,
      created: new Date().toISOString(),
      credentials: credentials,
      services: {
        aliexpress: { status: 'pending', registered: false },
        stripe: { status: 'pending', registered: false },
        sendgrid: { status: 'pending', registered: false },
        gcp: { status: 'pending', registered: false },
        n8n: { status: 'pending', registered: false }
      }
    };

    fs.writeFileSync(this.configPath, JSON.stringify(config, null, 2));
    console.log(`${colors.green}✅ Credentials сохранены в config/api-credentials.json${colors.reset}`);
  }

  // Обновление .env.local
  async updateEnvFile(appPasswords) {
    if (!fs.existsSync(this.envPath)) {
      console.log(`${colors.yellow}⚠️  .env.local не найден, создаю новый...${colors.reset}`);
      fs.writeFileSync(this.envPath, '');
    }

    let envContent = fs.readFileSync(this.envPath, 'utf8');
    
    // Добавляем или обновляем переменные
    const updates = {
      'API_EMAIL': this.email,
      'SMTP_HOST': 'smtp.gmail.com',
      'SMTP_PORT': '587',
      'SMTP_USER': this.email,
      'SMTP_PASSWORD': appPasswords.smtp || '',
      'SENDGRID_FROM_EMAIL': this.email,
      'NOTIFICATION_EMAIL': this.email
    };

    for (const [key, value] of Object.entries(updates)) {
      const regex = new RegExp(`^${key}=.*$`, 'gm');
      if (envContent.match(regex)) {
        envContent = envContent.replace(regex, `${key}=${value}`);
      } else {
        envContent += `\n${key}=${value}`;
      }
    }

    fs.writeFileSync(this.envPath, envContent.trim() + '\n');
    console.log(`${colors.green}✅ .env.local обновлен${colors.reset}`);
  }

  // Создание инструкций для сервисов
  generateServiceInstructions() {
    const instructions = {
      'AliExpress': {
        url: 'https://portals.aliexpress.com',
        steps: [
          `Email: ${this.email}`,
          'Account Type: Individual',
          'Website: shop.ede-story.com',
          'Categories: Fashion, Electronics, Home'
        ]
      },
      'Stripe': {
        url: 'https://dashboard.stripe.com/register',
        steps: [
          `Email: ${this.email}`,
          'Country: Spain',
          'Business Type: Individual',
          'Test Mode: Enable first'
        ]
      },
      'SendGrid': {
        url: 'https://signup.sendgrid.com',
        steps: [
          `Email: ${this.email}`,
          'Free Plan: 100 emails/day',
          'Use Case: Transactional Email',
          'Get API Key after verification'
        ]
      },
      'Google Cloud': {
        url: 'https://console.cloud.google.com',
        steps: [
          `Email: ${this.email}`,
          'Project: edestory-platform',
          'Enable billing (set $50 budget)',
          'Get $300 free credits'
        ]
      },
      'Payoneer': {
        url: 'https://www.payoneer.com/accounts',
        steps: [
          `Email: ${this.email}`,
          'For receiving AliExpress commissions',
          'Individual Account',
          'Link to AliExpress after approval'
        ]
      }
    };

    return instructions;
  }

  // Создание Gmail фильтров (инструкция)
  generateGmailFilters() {
    const filters = [
      {
        name: 'API Notifications',
        from: 'noreply@aliexpress.com OR noreply@stripe.com OR noreply@sendgrid.com',
        label: 'API',
        action: 'Skip Inbox, Apply Label'
      },
      {
        name: 'Payment Notifications', 
        subject: 'payment OR commission OR payout OR earning',
        label: 'Payments',
        action: 'Star, Apply Label'
      },
      {
        name: 'Security Alerts',
        subject: 'security OR verification OR confirm OR authenticate',
        label: 'Security',
        action: 'Important, Never Spam'
      },
      {
        name: 'Error Notifications',
        subject: 'error OR failed OR failure OR rejected',
        label: 'Errors',
        action: 'Important, Apply Label'
      }
    ];

    return filters;
  }

  // Главный процесс настройки
  async setup() {
    console.clear();
    console.log(`${colors.blue}╔═══════════════════════════════════════════════════════╗${colors.reset}`);
    console.log(`${colors.blue}║   ${colors.green}📧 Настройка API Email${colors.blue}                            ║${colors.reset}`);
    console.log(`${colors.blue}║   ${colors.yellow}api.edestory@gmail.com${colors.blue}                           ║${colors.reset}`);
    console.log(`${colors.blue}╚═══════════════════════════════════════════════════════╝${colors.reset}\n`);

    // Проверка создания аккаунта
    const created = await question(`${colors.yellow}Вы уже создали аккаунт ${this.email}? (yes/no): ${colors.reset}`);
    
    if (created.toLowerCase() !== 'yes') {
      console.log(`\n${colors.cyan}📝 Инструкция для создания:${colors.reset}`);
      console.log(`1. Откройте: ${colors.blue}https://accounts.google.com/signup${colors.reset}`);
      console.log(`2. Используйте имя пользователя: ${colors.green}api.edestory${colors.reset}`);
      console.log(`3. Пароль: ${colors.yellow}${this.generateSecurePassword()}${colors.reset}`);
      console.log(`\n${colors.red}После создания запустите скрипт снова!${colors.reset}`);
      rl.close();
      return;
    }

    // Проверка 2FA
    const twoFA = await question(`${colors.yellow}Включена ли двухфакторная аутентификация (2FA)? (yes/no): ${colors.reset}`);
    
    if (twoFA.toLowerCase() !== 'yes') {
      console.log(`\n${colors.red}⚠️  ВАЖНО: Включите 2FA для безопасности!${colors.reset}`);
      console.log(`Откройте: ${colors.blue}https://myaccount.google.com/signinoptions/two-step-verification${colors.reset}`);
      console.log(`После включения запустите скрипт снова.`);
      rl.close();
      return;
    }

    // Сбор App Passwords
    console.log(`\n${colors.cyan}📝 Создайте App Passwords:${colors.reset}`);
    console.log(`Откройте: ${colors.blue}https://myaccount.google.com/apppasswords${colors.reset}\n`);

    const appPasswords = {};
    
    console.log(`Создайте пароли для следующих сервисов и введите их:`);
    console.log(`(формат: xxxx-xxxx-xxxx-xxxx без пробелов)\n`);

    appPasswords.smtp = await question(`SMTP/Email (для отправки писем): `) || '';
    appPasswords.aliexpress = await question(`AliExpress Integration: `) || '';
    appPasswords.stripe = await question(`Stripe Webhooks: `) || '';
    appPasswords.n8n = await question(`n8n Automation: `) || '';

    // Сохранение credentials
    await this.saveCredentials({
      mainPassword: '[SECURED]',
      appPasswords: appPasswords,
      twoFA: true,
      backupCodes: []
    });

    // Обновление .env
    await this.updateEnvFile(appPasswords);

    // Генерация инструкций
    console.log(`\n${colors.blue}═══════════════════════════════════════════════════════${colors.reset}`);
    console.log(`${colors.green}📋 ИНСТРУКЦИИ ДЛЯ РЕГИСТРАЦИИ В СЕРВИСАХ:${colors.reset}\n`);

    const instructions = this.generateServiceInstructions();
    for (const [service, info] of Object.entries(instructions)) {
      console.log(`${colors.cyan}${service}:${colors.reset}`);
      console.log(`  URL: ${colors.blue}${info.url}${colors.reset}`);
      info.steps.forEach(step => console.log(`  • ${step}`));
      console.log('');
    }

    // Gmail фильтры
    console.log(`${colors.blue}═══════════════════════════════════════════════════════${colors.reset}`);
    console.log(`${colors.green}📬 НАСТРОЙКА GMAIL ФИЛЬТРОВ:${colors.reset}\n`);
    
    console.log(`Откройте: ${colors.blue}https://mail.google.com/mail/u/0/#settings/filters${colors.reset}\n`);
    
    const filters = this.generateGmailFilters();
    filters.forEach(filter => {
      console.log(`${colors.yellow}${filter.name}:${colors.reset}`);
      console.log(`  From: ${filter.from || 'any'}`);
      console.log(`  Subject: ${filter.subject || 'any'}`);
      console.log(`  Action: ${filter.action}`);
      console.log('');
    });

    // Следующие шаги
    console.log(`${colors.blue}═══════════════════════════════════════════════════════${colors.reset}`);
    console.log(`${colors.green}✅ НАСТРОЙКА ЗАВЕРШЕНА!${colors.reset}\n`);

    console.log(`${colors.yellow}📝 Следующие шаги:${colors.reset}`);
    console.log(`1. Зарегистрируйтесь в AliExpress Affiliate`);
    console.log(`2. Создайте тестовый аккаунт Stripe`);
    console.log(`3. Получите SendGrid API key (бесплатно 100 писем/день)`);
    console.log(`4. При необходимости создайте GCP проект`);
    
    console.log(`\n${colors.cyan}💡 Совет:${colors.reset} Используйте этот email ТОЛЬКО для API!`);
    console.log(`Личную переписку ведите в другом аккаунте.\n`);

    // Создание файла с быстрыми ссылками
    const quickLinks = `# 🔗 Быстрые ссылки для api.edestory@gmail.com

## Регистрация в сервисах
- [AliExpress Affiliate](https://portals.aliexpress.com)
- [Stripe Dashboard](https://dashboard.stripe.com/register)
- [SendGrid](https://signup.sendgrid.com)
- [Google Cloud Console](https://console.cloud.google.com)
- [Payoneer](https://www.payoneer.com/accounts)

## Управление Gmail
- [Gmail Inbox](https://mail.google.com/mail/u/?authuser=api.edestory@gmail.com)
- [Security Settings](https://myaccount.google.com/security)
- [App Passwords](https://myaccount.google.com/apppasswords)
- [Filters](https://mail.google.com/mail/u/0/#settings/filters)
- [2FA Settings](https://myaccount.google.com/signinoptions/two-step-verification)

## API Документация
- [AliExpress API](https://developers.aliexpress.com/en/doc.htm)
- [Stripe API](https://stripe.com/docs/api)
- [SendGrid API](https://docs.sendgrid.com/api-reference/how-to-use-the-sendgrid-v3-api)

## Мониторинг
- [Gmail Activity](https://myaccount.google.com/device-activity)
- [Security Checkup](https://myaccount.google.com/security-checkup)
`;

    const quickLinksPath = path.join(__dirname, '..', 'API_QUICK_LINKS.md');
    fs.writeFileSync(quickLinksPath, quickLinks);
    console.log(`${colors.green}✅ Быстрые ссылки сохранены в API_QUICK_LINKS.md${colors.reset}`);

    rl.close();
  }
}

// Запуск
const setup = new EmailSetup();
setup.setup().catch(err => {
  console.error(`${colors.red}❌ Ошибка: ${err.message}${colors.reset}`);
  process.exit(1);
});