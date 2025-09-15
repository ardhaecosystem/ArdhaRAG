#!/bin/bash
# Step 3.3A: Development Workflow Integration v1
# Purpose: Hot-reload development environment with volume mounts
# Location: /opt/ardha-ecosystem/projects/ardharag

set -e
echo "🚀 Setting up development workflow integration..."

# Create Docker configurations for development
mkdir -p docker
mkdir -p ardharag

echo "📦 Creating development Dockerfile..."
cat > docker/Dockerfile.dev << 'EOF'
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install poetry==2.1.4

# Configure Poetry
ENV POETRY_NO_INTERACTION=1 \
    POETRY_VENV_IN_PROJECT=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

# Copy dependency files
COPY pyproject.toml poetry.lock* ./

# Install dependencies
RUN poetry install --no-root && rm -rf $POETRY_CACHE_DIR

# Create app user for security
RUN useradd --create-home --shell /bin/bash app
USER app

# Development command (overridden by docker-compose)
CMD ["poetry", "run", "python", "-c", "print('Development environment ready!')"]
EOF

echo "🔧 Creating development docker-compose configuration..."
cat > docker/docker-compose.dev.yml << 'EOF'
version: '3.8'

services:
  ardharag-dev:
    build:
      context: ..
      dockerfile: docker/Dockerfile.dev
    ports:
      - "8000:8000"
      - "8501:8501"
    environment:
      - ENVIRONMENT=development
      - DEBUG=true
      - LOG_LEVEL=DEBUG
      - PYTHONPATH=/app
    volumes:
      # Live code reloading
      - ../ardharag:/app/ardharag:cached
      - ../tests:/app/tests:cached
      - ../scripts:/app/scripts:cached
      - ../docs:/app/docs:cached
      - ../examples:/app/examples:cached
      # Preserve virtual environment
      - dev_venv:/app/.venv
      # Development cache
      - dev_cache:/app/.cache
    working_dir: /app
    networks:
      - ardharag_network
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    command: |
      bash -c "
        echo '🚀 ArdhaRAG Development Environment Starting...'
        echo '📦 Installing development dependencies...'
        poetry install --no-interaction
        echo '✅ Development environment ready!'
        echo '🔄 Watching for code changes...'
        tail -f /dev/null
      "

  # Use existing database services
  postgres:
    extends:
      file: ../docker-compose.yml
      service: postgres

  redis:
    extends:
      file: ../docker-compose.yml
      service: redis

  qdrant:
    extends:
      file: ../docker-compose.yml
      service: qdrant

volumes:
  dev_venv:
    driver: local
  dev_cache:
    driver: local

networks:
  ardharag_network:
    external: true
EOF

echo "🎯 Creating development management script..."
cat > scripts/dev-environment.sh << 'EOF'
#!/bin/bash
# ArdhaRAG Development Environment Manager

set -e

DEV_COMPOSE="docker/docker-compose.dev.yml"
MAIN_COMPOSE="docker-compose.yml"

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
    docker-compose -f $MAIN_COMPOSE up -d
    
    # Wait for services to be healthy
    echo "⏳ Waiting for services to be ready..."
    sleep 10
    
    # Start development environment
    echo "🔧 Starting development containers..."
    docker-compose -f $DEV_COMPOSE up -d
    
    echo "✅ Development environment started!"
    echo ""
    echo "📊 Service status:"
    docker-compose -f $DEV_COMPOSE ps
    echo ""
    echo "🔗 Available services:"
    echo "  📝 Development Shell: $0 shell"
    echo "  📋 Logs: $0 logs"
    echo "  🧪 Tests: $0 test"
}

stop_dev() {
    echo "🛑 Stopping development environment..."
    docker-compose -f $DEV_COMPOSE down
    echo "✅ Development environment stopped!"
}

restart_dev() {
    echo "🔄 Restarting development environment..."
    stop_dev
    start_dev
}

show_logs() {
    echo "📋 Development environment logs:"
    docker-compose -f $DEV_COMPOSE logs -f --tail=50
}

dev_shell() {
    echo "🐚 Opening development shell..."
    docker-compose -f $DEV_COMPOSE exec ardharag-dev bash
}

run_tests() {
    echo "🧪 Running tests in development environment..."
    docker-compose -f $DEV_COMPOSE exec ardharag-dev poetry run python -c "
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
    docker-compose -f $MAIN_COMPOSE ps
    echo ""
    echo "🔧 Development services:"
    docker-compose -f $DEV_COMPOSE ps
}

clean_dev() {
    echo "🧹 Cleaning development environment..."
    docker-compose -f $DEV_COMPOSE down -v
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
EOF

chmod +x scripts/dev-environment.sh

echo "📁 Creating basic ArdhaRAG package structure..."
mkdir -p ardharag/{core,api,ui,utils}

# Create basic __init__.py files
cat > ardharag/__init__.py << 'EOF'
"""
ArdhaRAG: World's First Predictive RAG System

Context-Aware Retrieval-Augmented Generation with Hallucination Prevention
and 40-60% token optimization through intelligent prompt engineering.
"""

__version__ = "0.1.0"
__author__ = "Ardha Ecosystem"
__description__ = "Revolutionary Context-Aware RAG with Predictive Intelligence"
EOF

cat > ardharag/core/__init__.py << 'EOF'
"""ArdhaRAG Core - Main RAG orchestrator and configuration management"""
EOF

cat > ardharag/api/__init__.py << 'EOF'
"""ArdhaRAG API - FastAPI application and endpoints"""
EOF

cat > ardharag/ui/__init__.py << 'EOF'
"""ArdhaRAG UI - Web interface components"""
EOF

cat > ardharag/utils/__init__.py << 'EOF'
"""ArdhaRAG Utils - Shared utilities and helper functions"""
EOF

echo "🔧 Creating VSCode development configuration..."
mkdir -p .vscode

cat > .vscode/settings.json << 'EOF'
{
    "python.defaultInterpreterPath": "./ardharag-dev:/app/.venv/bin/python",
    "python.terminal.activateEnvironment": true,
    "python.linting.enabled": true,
    "python.linting.flake8Enabled": true,
    "python.formatting.provider": "black",
    "python.formatting.blackArgs": ["--line-length=88"],
    "editor.formatOnSave": true,
    "editor.rulers": [88],
    "files.exclude": {
        "**/__pycache__": true,
        "**/*.pyc": true,
        ".pytest_cache": true,
        ".coverage": true
    }
}
EOF

cat > .vscode/launch.json << 'EOF'
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "ArdhaRAG API Debug",
            "type": "python",
            "request": "launch",
            "program": "${workspaceFolder}/ardharag/api/main.py",
            "console": "integratedTerminal",
            "env": {
                "ENVIRONMENT": "development",
                "DEBUG": "true"
            },
            "cwd": "${workspaceFolder}"
        }
    ]
}
EOF

echo "✅ Development workflow integration v1 completed!"
echo ""
echo "📋 Created:"
echo "├── docker/Dockerfile.dev           # Development container"
echo "├── docker/docker-compose.dev.yml   # Development orchestration"
echo "├── scripts/dev-environment.sh      # Development management"
echo "├── ardharag/ package structure     # Basic Python package"
echo "└── .vscode/ configuration          # VSCode development settings"
echo ""
echo "🎯 Next: Test development environment with './scripts/dev-environment.sh start'"
