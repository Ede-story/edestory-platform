# Orchestrator

FastAPI‑приложение, предоставляющее API для оркестрации ИИ‑моделей и хранилище
регистра дизайна.  Сервис разворачивается в Cloud Run и общается со storefront
и другими сервисами через HTTP.

## Запуск локально

```bash
python -m pip install -r requirements.txt
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

API будет доступен на `http://localhost:8000`.  Корневой эндпоинт `/` возвращает
"Edestory orchestrator is up and running".

## Эндпоинты (пока)

- `/` – health‑check.
- `/design-registry/{component}` – заглушка для выдачи JSON‑описания компонента.  Нужно заменить на настоящую реализацию.

## TODO

- Реализовать Design Registry API: эндпоинты для получения списка презентеров, версии дизайн‑пакета и т.п.
- Добавить эндпоинты для мульти‑модельной оркестрации GPT‑5, Claude, Gemini и DeepSeek.
- Настроить авторизацию и логирование.
