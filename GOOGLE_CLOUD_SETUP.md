# 🔧 Настройка Google Cloud для MCP - Простая инструкция

## Шаг 1: Откройте Google Cloud Console
1. Перейдите на https://console.cloud.google.com
2. Войдите в ваш Google аккаунт
3. Выберите проект **edestory-platform** (или создайте новый)

## Шаг 2: Создайте Service Account

### Вариант А: Через веб-интерфейс (проще)
1. В меню слева найдите **IAM & Admin** → **Service Accounts**
2. Нажмите **CREATE SERVICE ACCOUNT**
3. Заполните:
   - Name: `mcp-server`
   - Description: `MCP Server for Claude`
4. Нажмите **CREATE AND CONTINUE**
5. В разделе "Grant this service account access" выберите роли:
   - **Viewer** (базовый просмотр)
   - **Storage Admin** (для работы с файлами)
   - **Cloud Run Developer** (для деплоя)
6. Нажмите **CONTINUE** → **DONE**

### Вариант Б: Через терминал
```bash
# Откройте Terminal и выполните команды:

# 1. Установите gcloud если нет
brew install --cask google-cloud-sdk

# 2. Войдите
gcloud auth login

# 3. Установите проект
gcloud config set project edestory-platform

# 4. Создайте Service Account
gcloud iam service-accounts create mcp-server \
    --display-name="MCP Server for Claude"

# 5. Дайте права
gcloud projects add-iam-policy-binding edestory-platform \
    --member="serviceAccount:mcp-server@edestory-platform.iam.gserviceaccount.com" \
    --role="roles/viewer"
```

## Шаг 3: Создайте и скачайте ключ

### Через веб-интерфейс:
1. В списке Service Accounts найдите **mcp-server@...**
2. Нажмите на три точки справа → **Manage keys**
3. Нажмите **ADD KEY** → **Create new key**
4. Выберите **JSON** → **CREATE**
5. Файл автоматически скачается (например: `edestory-platform-xxxxx.json`)

### Через терминал:
```bash
gcloud iam service-accounts keys create ~/gcp-key.json \
    --iam-account=mcp-server@edestory-platform.iam.gserviceaccount.com
```

## Шаг 4: Переместите ключ в безопасное место
```bash
# Создайте папку для ключей
mkdir -p ~/Documents/keys

# Переместите ключ
mv ~/Downloads/edestory-platform-*.json ~/Documents/keys/gcp-mcp-key.json

# Защитите файл
chmod 600 ~/Documents/keys/gcp-mcp-key.json
```

## Шаг 5: Добавьте путь к ключу в конфигурацию MCP

Откройте Terminal и выполните:
```bash
# Откройте конфигурацию
open ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

Найдите секцию `google-cloud` и добавьте путь к ключу:
```json
"google-cloud": {
  "command": "node",
  "args": [
    "/Users/vadimarhipov/edestory-platform/mcp-google-cloud/dist/index.js"
  ],
  "env": {
    "GOOGLE_CLOUD_PROJECT": "edestory-platform",
    "GOOGLE_APPLICATION_CREDENTIALS": "/Users/vadimarhipov/Documents/keys/gcp-mcp-key.json"
  }
}
```

## Шаг 6: Перезапустите Claude Desktop
1. Полностью закройте Claude (Cmd+Q)
2. Откройте заново
3. Проверьте статус google-cloud в Developer → Local MCP servers

## ✅ Готово! 

Теперь Google Cloud MCP должен показывать статус "running"

## ⚠️ Безопасность
- **НИКОГДА** не публикуйте JSON ключ в Git
- **НЕ** отправляйте ключ по email или в чатах
- Храните ключ в защищенной папке

## 🆘 Если не работает:
1. Проверьте путь к файлу ключа (должен быть полный путь)
2. Проверьте права доступа к файлу
3. Убедитесь что проект в ключе совпадает с GOOGLE_CLOUD_PROJECT
4. Посмотрите логи ошибки в Claude Desktop