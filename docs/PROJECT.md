# EDESTORY PLATFORM - B2B SaaS для производителей

## ⚠️ ПЕРЕХОД НА НОВУЮ СТРАТЕГИЮ
**Дата перехода:** Декабрь 2024  
**Причина:** Pivot от Template Factory к B2B платформе

## НОВАЯ БИЗНЕС-МОДЕЛЬ
- **Целевая аудитория:** Азиатские производители и дистрибьюторы
- **Модель:** White-label магазины с profit-sharing 20/80
- **MVP:** Dropshipping магазин для демонстрации

## ЧТО СОХРАНЯЕМ ИЗ СТАРОГО
```yaml
Сохраняем:
  - Saleor как e-commerce core
  - Next.js frontend структуру
  - PostgreSQL база данных
  
Удаляем:
  - Lovable.dev компоненты
  - Template Factory логику
  - Сложные multi-tenant системы
```

## НОВАЯ АРХИТЕКТУРА
```
edestory-platform/
├── master-store/          # Основной магазин (MVP)
│   ├── backend/          # Saleor
│   ├── frontend/         # Next.js
│   └── automation/       # n8n.io workflows
├── client-stores/        # Клонированные магазины
└── scripts/             # Утилиты клонирования
```

## ROADMAP ПЕРЕХОДА

### Неделя 1: Очистка от старого кода
- Удаление Lovable компонентов
- Архивация Template Factory
- Упрощение архитектуры

### Неделя 2: Создание MVP dropshipping
- Базовый Saleor setup
- Простой Next.js frontend
- Интеграция AliExpress

### Неделя 3: n8n.io автоматизация
- Контент-завод workflows
- Social media автоматизация
- Email маркетинг

### Неделя 4: Первый B2B клиент
- Скрипт клонирования
- Profit-sharing калькулятор
- Отчетность