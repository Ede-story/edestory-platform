# 🚀 Активация MCP серверов в Claude Desktop

## ✅ Статус: Все MCP серверы настроены и готовы!

### 📋 Установленные MCP серверы:

1. **filesystem** - Работа с файлами проекта
2. **memory** - Долговременная память между сессиями
3. **google-cloud** - Управление Google Cloud Platform
4. **sequential-thinking** - Последовательное решение задач
5. **everything** - Комбинированный сервер со всеми возможностями

## 🎯 Как активировать в Claude Desktop:

### Шаг 1: Откройте настройки Claude
- Нажмите на меню **Claude** в верхнем левом углу
- Выберите **Settings** (или Cmd+,)

### Шаг 2: Перейдите в раздел Developer
- В левой панели найдите **Developer**
- Нажмите на него

### Шаг 3: Раздел Local MCP servers
Вы увидите текст:
> "Add and manage MCP servers that you're working on."

### Шаг 4: Проверка конфигурации
- Если серверы уже отображаются - отлично! ✅
- Если нет - нажмите **"Edit Config"** или **"Add Server"**

### Шаг 5: Перезапуск Claude (если требуется)
- Полностью закройте Claude Desktop (Cmd+Q)
- Откройте заново
- Вернитесь в Settings → Developer

## 🔍 Проверка работы:

### В разделе Developer вы должны увидеть:
```
✅ filesystem - Running
✅ memory - Running  
✅ google-cloud - Running
✅ sequential-thinking - Running
✅ everything - Running
```

### Если сервер показывает ошибку:
- Нажмите на название сервера
- Посмотрите логи ошибки
- Обычно проблема в пути к файлу или отсутствии зависимостей

## 🛠 Troubleshooting:

### Проблема: "Server not found"
```bash
# Пересоберите серверы
cd /Users/vadimarhipov/edestory-platform/mcp-official-servers
npm run build

cd /Users/vadimarhipov/edestory-platform/mcp-google-cloud  
npm run build
```

### Проблема: "Permission denied"
```bash
# Дайте права на выполнение
chmod +x /Users/vadimarhipov/edestory-platform/mcp-official-servers/src/*/dist/index.js
chmod +x /Users/vadimarhipov/edestory-platform/mcp-google-cloud/dist/index.js
```

### Проблема: "Dependencies not found"
```bash
# Установите зависимости
cd /Users/vadimarhipov/edestory-platform/mcp-official-servers
npm install

cd /Users/vadimarhipov/edestory-platform/mcp-google-cloud
npm install
```

## 📍 Расположение конфигурации:
```
~/Library/Application Support/Claude/claude_desktop_config.json
```

## 🎉 Когда всё работает:

Вы сможете использовать новые возможности Claude:
- 📁 Прямой доступ к файлам проекта через filesystem
- 🧠 Сохранение контекста между сессиями через memory
- ☁️ Управление Google Cloud ресурсами
- 🤔 Улучшенное решение сложных задач через sequential-thinking

## 💡 Полезные команды для тестирования:

После активации попробуйте эти команды в Claude:

1. **Filesystem тест:**
   "Покажи структуру проекта edestory-platform"

2. **Memory тест:**
   "Запомни, что основной провайдер проекта - Google Cloud"

3. **Google Cloud тест:**
   "Покажи информацию о проекте edestory-platform в GCP"

4. **Sequential thinking тест:**
   "Разбей задачу интеграции дизайна на шаги и выполни последовательно"

---

## 📞 Если нужна помощь:

1. Проверьте логи в Settings → Developer → MCP Logs
2. Запустите тест-скрипт: `./scripts/test-mcp-servers.sh`
3. Проверьте документацию: `docs/MCP_SERVERS_GUIDE.md`

**Статус:** Готово к использованию ✅
**Обновлено:** Январь 2025