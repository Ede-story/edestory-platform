#!/bin/bash

# n8n Control Script for Ede Story Platform
# Управление n8n сервером

set -e

COMPOSE_FILE="docker-compose.n8n.yml"
N8N_URL="http://localhost:5678"

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

function print_header() {
    echo -e "\n${GREEN}===========================================\${NC}"
    echo -e "${GREEN}       n8n Control Panel - Ede Story      ${NC}"
    echo -e "${GREEN}===========================================${NC}\n"
}

function status() {
    echo -e "${YELLOW}📊 Статус n8n:${NC}"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep n8n || echo "n8n не запущен"
}

function start() {
    echo -e "${GREEN}🚀 Запуск n8n...${NC}"
    docker-compose -f $COMPOSE_FILE up -d
    echo -e "${GREEN}✅ n8n запущен!${NC}"
    echo -e "${GREEN}📍 URL: ${N8N_URL}${NC}"
    echo -e "${GREEN}👤 Login: admin${NC}"
    echo -e "${GREEN}🔑 Password: edestory2025${NC}"
}

function stop() {
    echo -e "${YELLOW}⏹️  Остановка n8n...${NC}"
    docker-compose -f $COMPOSE_FILE stop
    echo -e "${GREEN}✅ n8n остановлен${NC}"
}

function restart() {
    echo -e "${YELLOW}🔄 Перезапуск n8n...${NC}"
    docker-compose -f $COMPOSE_FILE restart
    echo -e "${GREEN}✅ n8n перезапущен${NC}"
}

function logs() {
    echo -e "${YELLOW}📜 Логи n8n (Ctrl+C для выхода):${NC}"
    docker-compose -f $COMPOSE_FILE logs -f
}

function backup() {
    BACKUP_DIR="n8n-backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p $BACKUP_DIR
    
    echo -e "${YELLOW}💾 Создание бэкапа...${NC}"
    
    # Бэкап PostgreSQL
    docker exec edestory-n8n-postgres pg_dump -U n8n n8n > "$BACKUP_DIR/database.sql"
    
    # Бэкап workflows
    cp -r n8n-data "$BACKUP_DIR/n8n-data"
    cp -r n8n-workflows "$BACKUP_DIR/n8n-workflows"
    
    echo -e "${GREEN}✅ Бэкап создан в: $BACKUP_DIR${NC}"
}

function reset() {
    echo -e "${RED}⚠️  ВНИМАНИЕ: Это удалит все данные n8n!${NC}"
    read -p "Вы уверены? (yes/no): " confirm
    
    if [ "$confirm" = "yes" ]; then
        echo -e "${YELLOW}🗑️  Удаление данных...${NC}"
        docker-compose -f $COMPOSE_FILE down -v
        rm -rf n8n-data n8n-postgres-data
        mkdir -p n8n-data n8n-postgres-data
        echo -e "${GREEN}✅ Данные удалены. Запустите 'start' для чистой установки${NC}"
    else
        echo -e "${YELLOW}❌ Отменено${NC}"
    fi
}

function open_ui() {
    echo -e "${GREEN}🌐 Открытие n8n UI...${NC}"
    open $N8N_URL || xdg-open $N8N_URL || echo "Откройте в браузере: $N8N_URL"
}

function import_workflows() {
    echo -e "${YELLOW}📥 Импорт workflow шаблонов${NC}"
    echo -e "${YELLOW}1. Откройте n8n UI: ${N8N_URL}${NC}"
    echo -e "${YELLOW}2. Перейдите в Workflows → Import${NC}"
    echo -e "${YELLOW}3. Выберите файлы из n8n-workflows/templates/${NC}"
    echo ""
    echo -e "${GREEN}Доступные шаблоны:${NC}"
    ls -la n8n-workflows/templates/*.json 2>/dev/null || echo "Шаблоны не найдены"
}

function help() {
    print_header
    echo "Использование: ./n8n-control.sh [команда]"
    echo ""
    echo "Команды:"
    echo "  start    - Запустить n8n"
    echo "  stop     - Остановить n8n"
    echo "  restart  - Перезапустить n8n"
    echo "  status   - Показать статус"
    echo "  logs     - Показать логи"
    echo "  backup   - Создать бэкап"
    echo "  reset    - Сбросить все данные"
    echo "  open     - Открыть UI в браузере"
    echo "  import   - Инструкция по импорту workflow"
    echo "  help     - Показать эту справку"
    echo ""
    echo "Примеры:"
    echo "  ./n8n-control.sh start"
    echo "  ./n8n-control.sh status"
    echo "  ./n8n-control.sh logs"
}

# Главное меню
print_header

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    logs)
        logs
        ;;
    backup)
        backup
        ;;
    reset)
        reset
        ;;
    open)
        open_ui
        ;;
    import)
        import_workflows
        ;;
    help|"")
        help
        ;;
    *)
        echo -e "${RED}❌ Неизвестная команда: $1${NC}"
        help
        exit 1
        ;;
esac