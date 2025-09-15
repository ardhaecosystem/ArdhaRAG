#!/bin/bash
# ArdhaRAG Development Environment Manager

set -e

DEV_COMPOSE="docker/docker-compose.dev.yml"
MAIN_COMPOSE="infrastructure/docker/docker-compose.yml"

show_help() {
    echo "🚀 ArdhaRAG Development Environment Manager"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start     Start development environment"
    echo "  stop      Stop development environment"
    echo "  restart   Restart development environment"
    echo "  logs      Show development logs"
    echo "  shell     Open development shell"
    echo "  test      Run tests in development environment"
    echo "  status    Show development environment status"
    echo "  clean     Clean development environment"
    echo "  help      Show this help"
}

start_dev() {
    echo "🚀 Starting ArdhaRAG development environment..."
    
    # Ensure main services are running
    echo "📦 Ensuring database services are running..."
    docker compose -f $MAIN_COMPOSE up -d
    
    # Wait for services to be healthy
    echo "⏳ Waiting for services to be ready..."
    sleep 10
    
    # Start development environment
    echo "🔧 Starting development containers..."
    docker compose -f $DEV_COMPOSE up -d
    
    echo "✅ Development environment started!"
    echo ""
    echo "📊 Service status:"
    docker compose -f $DEV_COMPOSE ps
    echo ""
    echo "🔗 Available services:"
    echo "  📝 Development Shell: $0 shell"
    echo "  📋 Logs: $0 logs"
    echo "  🧪 Tests: $0 test"
}

stop_dev() {
    echo "🛑 Stopping development environment..."
    docker compose -f $DEV_COMPOSE down
    echo "✅ Development environment stopped!"
}

restart_dev() {
    echo "🔄 Restarting development environment..."
    stop_dev
    start_dev
}

show_logs() {
    echo "📋 Development environment logs:"
    docker compose -f $DEV_COMPOSE logs -f --tail=50
}

dev_shell() {
    echo "🐚 Opening development shell..."
    docker compose -f $DEV_COMPOSE exec ardharag-dev bash
}

run_tests() {
    echo "🧪 Running tests in development environment..."
    docker compose -f $DEV_COMPOSE exec ardharag-dev poetry run python -c "
import sys
print('🐍 Python version:', sys.version)
print('📦 Development environment active!')
print('✅ Tests would run here when implemented!')
"
}

show_status() {
    echo "📊 Development environment status:"
    echo ""
    echo "🗄️ Database services:"
    docker compose -f $MAIN_COMPOSE ps
    echo ""
    echo "🔧 Development services:"
    docker compose -f $DEV_COMPOSE ps
}

clean_dev() {
    echo "🧹 Cleaning development environment..."
    docker compose -f $DEV_COMPOSE down -v
    docker volume prune -f
    echo "✅ Development environment cleaned!"
}

case "${1:-help}" in
    start)     start_dev ;;
    stop)      stop_dev ;;
    restart)   restart_dev ;;
    logs)      show_logs ;;
    shell)     dev_shell ;;
    test)      run_tests ;;
    status)    show_status ;;
    clean)     clean_dev ;;
    help|*)    show_help ;;
esac
