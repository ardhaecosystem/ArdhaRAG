#!/bin/bash
# Development Environment Complete Fix v7
# Fix: Add missing env_file, volumes, and network to development compose

set -e
echo "🔧 Applying complete development environment fix..."

# Add env_file reference to development compose file
# This will make the environment variables available to docker-compose
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

  # Use existing database services with explicit env_file reference
  postgres:
    extends:
      file: ../infrastructure/docker/docker-compose.yml
      service: postgres
    env_file:
      - ../infrastructure/docker/.env

  redis:
    extends:
      file: ../infrastructure/docker/docker-compose.yml
      service: redis
    env_file:
      - ../infrastructure/docker/.env

  qdrant:
    extends:
      file: ../infrastructure/docker/docker-compose.yml
      service: qdrant
    env_file:
      - ../infrastructure/docker/.env

volumes:
  # Development-specific volumes
  dev_venv:
    driver: local
  dev_cache:
    driver: local
  # Extended service volumes (must be declared here too)
  postgres_data:
    external: true
  qdrant_data:
    external: true
  redis_data:
    external: true

networks:
  ardharag_network:
    external: true
EOF

echo "✅ Fixed development compose file with proper env_file and volume references!"

# Also update the development environment script to pass the env-file flag
echo "🔧 Updating development script to use environment file..."

# Create a simple symlink for easier access to env file
ln -sf ../infrastructure/docker/.env docker/.env

echo "✅ Created symlink for easier environment file access!"
echo ""
echo "📋 Fixes applied:"
echo "├── Added env_file references to all extended services"
echo "├── Added external volume declarations for postgres_data, qdrant_data, redis_data"
echo "├── Confirmed external network reference"
echo "└── Created .env symlink in docker/ directory"
echo ""
echo "🎯 Ready to test: ./scripts/dev-environment.sh start"
