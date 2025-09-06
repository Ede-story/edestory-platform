# 🧪 Edestory Testing Protocol

## 📋 Обязательные проверки перед каждым коммитом

### ✅ Автоматические проверки (Pre-commit)
```bash
# Эти команды запускаются автоматически перед коммитом
pnpm lint              # ESLint проверка
pnpm typecheck         # TypeScript проверка  
pnpm test:unit         # Unit тесты
pnpm build             # Проверка сборки
```

### 🔍 Ручные проверки (обязательно)
- [ ] Проверен функционал в браузере
- [ ] Нет console.log() в production коде
- [ ] Добавлены/обновлены тесты для нового кода
- [ ] Обновлена документация при изменении API
- [ ] Проверена адаптивность (mobile/tablet/desktop)

## 🎯 Уровни тестирования

### Level 1: Unit Tests (Быстрые, < 1 сек)
**Что тестируем:**
- Utility функции
- React компоненты (изолированно)
- Бизнес-логика
- Валидация данных

**Команда:** `pnpm test:unit`
**Coverage требование:** > 80%

### Level 2: Integration Tests (Средние, < 30 сек)
**Что тестируем:**
- API endpoints
- Database queries
- Service взаимодействие
- Auth flows

**Команда:** `pnpm test:integration`
**Coverage требование:** > 70%

### Level 3: E2E Tests (Медленные, < 5 мин)
**Что тестируем:**
- Critical user paths
- Checkout процесс
- Registration/Login
- Product browsing
- Cart operations

**Команда:** `pnpm test:e2e`
**Coverage требование:** 100% critical paths

### Level 4: Visual Regression (После изменений UI)
**Что тестируем:**
- Компоненты UI
- Страницы целиком
- Responsive layouts
- Dark/Light themes

**Команда:** `pnpm test:visual`
**Допустимая разница:** < 0.1%

## 🛍 E-Commerce специфичные тесты

### Критический путь покупателя (MUST PASS)
```gherkin
Feature: Purchase Flow
  Scenario: Успешная покупка товара
    Given Я на главной странице
    When Я выбираю товар
    And Добавляю в корзину
    And Перехожу к оформлению
    And Ввожу данные доставки
    And Выбираю способ оплаты
    And Подтверждаю заказ
    Then Заказ успешно создан
    And Email отправлен
    And Склад обновлен
```

### Тесты платежной системы
- [ ] Успешная оплата картой
- [ ] Отклоненная карта
- [ ] 3D Secure flow
- [ ] Refund процесс
- [ ] Subscription управление

### Тесты интеграций
- [ ] AliExpress импорт товаров
- [ ] Stripe webhooks
- [ ] Email notifications
- [ ] SMS уведомления
- [ ] Tracking updates

## 📊 Performance тестирование

### Lighthouse метрики (минимум)
```yaml
Performance: 90
Accessibility: 95
Best Practices: 95
SEO: 100
```

### Core Web Vitals
```yaml
LCP (Largest Contentful Paint): < 2.5s
FID (First Input Delay): < 100ms
CLS (Cumulative Layout Shift): < 0.1
```

### Load testing
```yaml
Concurrent users: 1000
Response time p95: < 500ms
Error rate: < 0.1%
Throughput: > 100 req/sec
```

## 🔐 Security тестирование

### OWASP Top 10 проверки
- [ ] SQL Injection
- [ ] XSS (Cross-Site Scripting)
- [ ] CSRF защита
- [ ] Authentication bypass
- [ ] Sensitive data exposure
- [ ] XML external entities (XXE)
- [ ] Broken access control
- [ ] Security misconfiguration
- [ ] Insecure deserialization
- [ ] Using components with known vulnerabilities

### PCI DSS compliance (для платежей)
- [ ] Карточные данные не хранятся
- [ ] SSL/TLS везде
- [ ] Токенизация платежей
- [ ] Audit logs
- [ ] Access control

## 🚀 CI/CD Pipeline тесты

### Pre-merge checks
```yaml
on: pull_request
jobs:
  - lint
  - typecheck
  - unit-tests
  - integration-tests
  - build
  - lighthouse
```

### Post-merge checks
```yaml
on: push to main
jobs:
  - full-test-suite
  - e2e-tests
  - visual-regression
  - security-scan
  - deploy-preview
  - smoke-tests
```

### Production deploy
```yaml
on: release
jobs:
  - all-tests
  - performance-tests
  - security-audit
  - backup-database
  - deploy-production
  - post-deploy-tests
  - rollback-on-failure
```

## 📝 Тестовые данные

### Тестовые пользователи
```javascript
const TEST_USERS = {
  admin: { email: 'admin@test.edestory.com', role: 'admin' },
  customer: { email: 'customer@test.edestory.com', role: 'customer' },
  vendor: { email: 'vendor@test.edestory.com', role: 'vendor' }
};
```

### Тестовые товары
```javascript
const TEST_PRODUCTS = {
  simple: { sku: 'TEST-001', price: 99.99 },
  variable: { sku: 'TEST-002', variants: 3 },
  digital: { sku: 'TEST-003', downloadable: true },
  subscription: { sku: 'TEST-004', recurring: 'monthly' }
};
```

### Тестовые платежные карты (Stripe)
```
Success: 4242 4242 4242 4242
Decline: 4000 0000 0000 0002
3D Secure: 4000 0025 0000 3155
```

## 🐛 Отчеты о тестировании

### Формат отчета после тестирования
```markdown
## Test Report - [DATE]

### Summary
- Total tests: X
- Passed: X (X%)
- Failed: X
- Skipped: X
- Duration: Xs

### Failed Tests
1. [Test name]
   - Error: [error message]
   - File: [file:line]
   - Fix: [proposed solution]

### Performance
- Build time: Xs
- Test execution: Xs
- Coverage: X%

### Next Steps
- [ ] Fix failing tests
- [ ] Improve slow tests
- [ ] Add missing coverage
```

## 🎯 KPI тестирования

### Ежедневные метрики
- Test pass rate > 99%
- No broken builds on main
- Coverage не снижается
- Performance не деградирует

### Еженедельные метрики
- Новые тесты добавлены
- Flaky tests исправлены
- Test execution time оптимизирован
- Security scan пройден

## 🛠 Инструменты тестирования

### Установленные
- Playwright (E2E)
- Vitest (Unit)
- MSW (API mocking)
- Testing Library (React)

### Рекомендуемые к установке
- Cypress (альтернатива E2E)
- Percy (visual regression)
- k6 (load testing)
- SonarQube (code quality)
- Snyk (security)

## 📚 Best Practices

### Написание тестов
1. **Arrange-Act-Assert** паттерн
2. **One assertion** per test
3. **Descriptive names** для тестов
4. **Test behavior**, not implementation
5. **Mock external** dependencies
6. **Use factories** для тестовых данных
7. **Parallelize** где возможно

### Отладка тестов
```bash
# Запуск конкретного теста
pnpm test:unit -- --grep "should create order"

# Debug mode
pnpm test:e2e -- --debug

# Watch mode
pnpm test:unit -- --watch

# Coverage report
pnpm test:coverage
```

## 🚨 Emergency протокол

### Если все тесты падают
1. Проверить зависимости: `pnpm install`
2. Очистить кэш: `pnpm clean`
3. Проверить env переменные
4. Откатиться на предыдущий коммит
5. Связаться с командой

### Если production сломан
1. Откатить немедленно
2. Запустить smoke tests
3. Проверить мониторинг
4. Создать hotfix
5. Post-mortem анализ

---

*Версия: 1.0*
*Обновлено: Декабрь 2025*
*Следующий review: Каждый спринт*