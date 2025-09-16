#!/bin/bash

# ArdhaRAG Deployment Script
# Purpose: Deploy to different environments with proper validation

set -euo pipefail

ENVIRONMENT=${1:-production}

echo "🚀 ARDHARAG DEPLOYMENT SCRIPT"
echo "============================="
echo "Environment: $ENVIRONMENT"

# Validate environment
case $ENVIRONMENT in
    production|staging|development)
        echo "✅ Valid environment: $ENVIRONMENT"
        ;;
    *)
        echo "❌ Invalid environment. Use: production, staging, or development"
        exit 1
        ;;
esac

# Check prerequisites
echo "🔍 Checking prerequisites..."

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not installed"
    exit 1
fi

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose not installed"
    exit 1
fi

# Check environment file
ENV_FILE=".env.${ENVIRONMENT}"
if [[ ! -f "$ENV_FILE" ]]; then
    echo "❌ Environment file $ENV_FILE not found"
    echo "📋 Create it from .env.${ENVIRONMENT}.example"
    exit 1
fi

echo "✅ Prerequisites check passed"

# Load environment
set -a
source "$ENV_FILE"
set +a

# Deployment based on environment
case $ENVIRONMENT in
    production)
        echo "🎯 Production deployment..."
        
        # SSL check
        if [[ ! -f "nginx/ssl/cert.pem" ]]; then
            echo "❌ SSL certificate not found"
            echo "📋 Run ./setup_ssl.sh first"
            exit 1
        fi
        
        # Backup existing data
        echo "💾 Creating backup..."
        if docker-compose -f docker-compose.prod.yml ps postgres | grep -q "Up"; then
            docker-compose -f docker-compose.prod.yml exec postgres pg_dump -U ardharag ardharag > "backup_$(date +%Y%m%d_%H%M%S).sql"
        fi
        
        # Deploy
        docker-compose -f docker-compose.prod.yml down
        docker-compose -f docker-compose.prod.yml pull
        docker-compose -f docker-compose.prod.yml up -d
        ;;
        
    staging)
        echo "🧪 Staging deployment..."
        docker-compose -f docker-compose.staging.yml down
        docker-compose -f docker-compose.staging.yml up -d --build
        ;;
        
    development)
        echo "🔧 Development deployment..."
        cd infrastructure/docker
        docker-compose down
        docker-compose up -d
        cd ../..
        ;;
esac

# Health check
echo "💓 Performing health check..."
sleep 30

case $ENVIRONMENT in
    production)
        if curl -f https://localhost/health; then
            echo "✅ Production deployment healthy"
        else
            echo "❌ Production deployment failed health check"
            exit 1
        fi
        ;;
    staging)
        if curl -f http://localhost:8080/health; then
            echo "✅ Staging deployment healthy"
        else
            echo "❌ Staging deployment failed health check"
            exit 1
        fi
        ;;
    development)
        if curl -f http://localhost:8000/health; then
            echo "✅ Development deployment healthy"
        else
            echo "❌ Development deployment failed health check"
        fi
        ;;
esac

echo "🎉 Deployment complete!"
echo "📊 Container status:"
docker-compose -f "docker-compose.${ENVIRONMENT}.yml" ps
