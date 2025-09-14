.DEFAULT_GOAL := help
.PHONY: help install dev clean test lint format docker-build docker-up docker-down

help: ## Show this help message
	@echo "🚀 ArdhaRAG Development Commands"
	@echo ""
	@echo "📦 Setup Commands:"
	@echo "  install     Install dependencies"
	@echo "  dev         Install development dependencies"
	@echo ""
	@echo "🧪 Testing Commands:"
	@echo "  test        Run all tests"
	@echo "  coverage    Generate coverage report"
	@echo ""
	@echo "🔍 Code Quality:"
	@echo "  lint        Run all linters"
	@echo "  format      Format code"
	@echo ""
	@echo "🐳 Docker Commands:"
	@echo "  docker-up   Start all services"
	@echo "  docker-down Stop all services"

install: ## Install production dependencies
	poetry install --only=main

dev: ## Install development dependencies
	poetry install
	poetry run pre-commit install

clean: ## Clean cache and temporary files
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true

test: ## Run all tests
	poetry run pytest

coverage: ## Generate test coverage report
	poetry run pytest --cov=ardharag --cov-report=html --cov-report=term

lint: ## Run all linters
	poetry run flake8 ardharag tests
	poetry run mypy ardharag

format: ## Format code with black and isort
	poetry run black ardharag tests
	poetry run isort ardharag tests

docker-build: ## Build Docker images
	docker-compose build

docker-up: ## Start all services
	docker-compose up -d
	@echo "🌐 API: http://localhost:8000"
	@echo "🎨 UI: http://localhost:8501"

docker-down: ## Stop all services
	docker-compose down
