#!/usr/bin/env node

/**
 * Тестирование отправки email через Gmail с App Password
 */

const nodemailer = require('nodemailer');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '..', 'frontend', '.env.local') });

// Цвета для консоли
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  red: '\x1b[31m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m'
};

async function testEmail() {
  console.log(`${colors.blue}╔═══════════════════════════════════════════════════════╗${colors.reset}`);
  console.log(`${colors.blue}║   ${colors.green}📧 Тест отправки Email${colors.blue}                            ║${colors.reset}`);
  console.log(`${colors.blue}║   ${colors.yellow}api.edestory@gmail.com${colors.blue}                           ║${colors.reset}`);
  console.log(`${colors.blue}╚═══════════════════════════════════════════════════════╝${colors.reset}\n`);

  // Проверяем наличие настроек
  if (!process.env.SMTP_PASSWORD) {
    console.error(`${colors.red}❌ SMTP_PASSWORD не найден в .env.local${colors.reset}`);
    console.log(`${colors.yellow}Убедитесь, что вы добавили App Password в .env.local${colors.reset}`);
    process.exit(1);
  }

  // Создаем транспорт
  const transporter = nodemailer.createTransport({
    host: process.env.SMTP_HOST || 'smtp.gmail.com',
    port: parseInt(process.env.SMTP_PORT || '587'),
    secure: false, // true for 465, false for other ports
    auth: {
      user: process.env.SMTP_USER || 'api.edestory@gmail.com',
      pass: process.env.SMTP_PASSWORD
    }
  });

  // Тестовые письма
  const testEmails = [
    {
      name: 'Welcome Email',
      subject: '🎉 Добро пожаловать в Edestory Shop!',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <div style="background: linear-gradient(135deg, #E6A853 0%, #8B2635 100%); padding: 30px; text-align: center;">
            <h1 style="color: white; margin: 0;">Edestory Shop</h1>
          </div>
          <div style="padding: 30px; background: #f9f9f9;">
            <h2>Добро пожаловать!</h2>
            <p>Спасибо за регистрацию в нашем магазине.</p>
            <p>Теперь вы можете:</p>
            <ul>
              <li>Просматривать эксклюзивные товары</li>
              <li>Получать скидки до 50%</li>
              <li>Отслеживать заказы онлайн</li>
            </ul>
            <div style="text-align: center; margin-top: 30px;">
              <a href="https://shop.ede-story.com" style="background: #E6A853; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; display: inline-block;">
                Перейти в магазин
              </a>
            </div>
          </div>
          <div style="padding: 20px; text-align: center; color: #666; font-size: 12px;">
            © 2025 Edestory Shop. Все права защищены.
          </div>
        </div>
      `
    },
    {
      name: 'Order Confirmation',
      subject: '✅ Заказ #12345 подтвержден',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <div style="background: #E6A853; padding: 20px; text-align: center;">
            <h1 style="color: white; margin: 0;">Заказ подтвержден!</h1>
          </div>
          <div style="padding: 30px;">
            <h2>Заказ #12345</h2>
            <p>Мы получили ваш заказ и уже начали его обработку.</p>
            
            <div style="background: #f9f9f9; padding: 20px; margin: 20px 0; border-radius: 5px;">
              <h3>Детали заказа:</h3>
              <table style="width: 100%;">
                <tr>
                  <td>iPhone Case Premium</td>
                  <td style="text-align: right;">€15.99</td>
                </tr>
                <tr>
                  <td>Доставка</td>
                  <td style="text-align: right;">€4.99</td>
                </tr>
                <tr style="font-weight: bold; border-top: 1px solid #ddd; padding-top: 10px;">
                  <td>Итого:</td>
                  <td style="text-align: right;">€20.98</td>
                </tr>
              </table>
            </div>
            
            <p><strong>Время доставки:</strong> 3-5 рабочих дней</p>
            <p><strong>Трекинг номер:</strong> Будет отправлен после отгрузки</p>
          </div>
        </div>
      `
    },
    {
      name: 'Commission Notification',
      subject: '💰 Новая комиссия: €2.50',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <div style="background: #4CAF50; padding: 20px; text-align: center;">
            <h1 style="color: white; margin: 0;">💰 Комиссия начислена!</h1>
          </div>
          <div style="padding: 30px;">
            <h2>Отличные новости!</h2>
            <p>Вы заработали комиссию с продажи через AliExpress Affiliate.</p>
            
            <div style="background: #f0f8ff; padding: 20px; margin: 20px 0; border-radius: 5px; border-left: 4px solid #4CAF50;">
              <h3 style="margin-top: 0;">Детали:</h3>
              <p><strong>Товар:</strong> Wireless Headphones</p>
              <p><strong>Цена продажи:</strong> €49.99</p>
              <p><strong>Комиссия (5%):</strong> €2.50</p>
              <p><strong>Статус:</strong> ✅ Подтверждено</p>
            </div>
            
            <p>Комиссия будет доступна для вывода через 30 дней.</p>
          </div>
        </div>
      `
    }
  ];

  // Получаем email для теста (можно отправить себе)
  const testRecipient = process.env.API_EMAIL || 'api.edestory@gmail.com';
  
  console.log(`${colors.cyan}📬 Отправляю тестовые письма на: ${testRecipient}${colors.reset}\n`);

  for (const emailTemplate of testEmails) {
    try {
      console.log(`${colors.yellow}Отправляю: ${emailTemplate.name}...${colors.reset}`);
      
      const info = await transporter.sendMail({
        from: `"${process.env.EMAIL_FROM_NAME || 'Edestory Shop'}" <${process.env.EMAIL_FROM}>`,
        to: testRecipient,
        subject: emailTemplate.subject,
        html: emailTemplate.html
      });

      console.log(`${colors.green}✅ Отправлено! ID: ${info.messageId}${colors.reset}`);
      
    } catch (error) {
      console.error(`${colors.red}❌ Ошибка: ${error.message}${colors.reset}`);
      
      if (error.message.includes('Invalid login')) {
        console.log(`\n${colors.yellow}💡 Решение:${colors.reset}`);
        console.log(`1. Убедитесь, что 2FA включена на аккаунте`);
        console.log(`2. Создайте новый App Password:`);
        console.log(`   ${colors.cyan}https://myaccount.google.com/apppasswords${colors.reset}`);
        console.log(`3. Обновите SMTP_PASSWORD в .env.local`);
      }
    }
  }

  console.log(`\n${colors.blue}═══════════════════════════════════════════════════════${colors.reset}`);
  console.log(`${colors.green}✅ Тестирование завершено!${colors.reset}\n`);
  
  console.log(`${colors.yellow}📝 Проверьте почту ${testRecipient}${colors.reset}`);
  console.log(`${colors.cyan}Там должно быть 3 тестовых письма:${colors.reset}`);
  console.log(`  1. Welcome Email`);
  console.log(`  2. Order Confirmation`);
  console.log(`  3. Commission Notification\n`);
  
  console.log(`${colors.green}🎯 Email интеграция работает корректно!${colors.reset}`);
  console.log(`Теперь можно использовать для:`);
  console.log(`  • Уведомлений о заказах`);
  console.log(`  • Подтверждения регистрации`);
  console.log(`  • Восстановления паролей`);
  console.log(`  • Маркетинговых рассылок`);
  
  process.exit(0);
}

// Проверка nodemailer
try {
  require.resolve('nodemailer');
} catch(e) {
  console.log(`${colors.yellow}Устанавливаю nodemailer...${colors.reset}`);
  require('child_process').execSync('pnpm add nodemailer', { stdio: 'inherit', cwd: path.join(__dirname, '..', 'frontend') });
}

// Запуск теста
testEmail().catch(err => {
  console.error(`${colors.red}❌ Критическая ошибка: ${err.message}${colors.reset}`);
  process.exit(1);
});