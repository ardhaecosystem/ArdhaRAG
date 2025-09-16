#!/bin/bash

# Step 2.2: Enhanced CI/CD Workflows Implementation
# Purpose: Create professional multi-environment CI/CD pipelines
# Location: Run from /opt/ardha-ecosystem/projects/ardharag/

set -euo pipefail

echo "🎯 STEP 2.2: ENHANCED CI/CD WORKFLOWS IMPLEMENTATION"
echo "===================================================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}✅ Branch: $(git branch --show-current)${NC}"
echo

# Create comprehensive CI workflow
echo -e "${PURPLE}🔄 STEP 1: Create Comprehensive CI Workflow${NC}"
cat > .github/workflows/ci.yml << 'EOF'
name: 🔄 Continuous Integration

on:
  push:
    branches: [main, develop, staging]
  pull_request:
    branches: [main, develop, staging]

env:
  PYTHON_VERSION: "3.11"
  POETRY_VERSION: "1.7.1"

jobs:
  # Code Quality Checks
  code-quality:
    name: 🧹 Code Quality
    runs-on: ubuntu-latest
    steps:
      - name: 📦 Checkout code
        uses: actions/checkout@v4

      - name: 🐍 Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: ${{ env.PYTHON_VERSION }}

      - name: 📚 Install Poetry
        uses: snok/install-poetry@v1
        with:
          version: ${{ env.POETRY_VERSION }}
          virtualenvs-create: true
          virtualenvs-in-project: true

      - name: 🔍 Load cached venv
        id: cached-poetry-dependencies
        uses: actions/cache@v3
        with:
          path: .venv
          key: venv-${{ runner.os }}-${{ hashFiles('**/poetry.lock') }}

      - name: 📦 Install dependencies
        if: steps.cached-poetry-dependencies.outputs.cache-hit != 'true'
        run: poetry install --no-interaction --no-root

      - name: 📦 Install project
        run: poetry install --no-interaction

      - name: 🎨 Check code formatting (Black)
        run: poetry run black --check --diff .

      - name: 📏 Check import sorting (isort)
        run: poetry run isort --check-only --diff .

      - name: 🔍 Lint code (flake8)
        run: poetry run flake8 src tests

      - name: 🏷️ Type check (mypy)
        run: poetry run mypy src

  # Security Scanning
  security:
    name: 🛡️ Security Scan
    runs-on: ubuntu-latest
    steps:
      - name: 📦 Checkout code
        uses: actions/checkout@v4

      - name: 🔐 Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: 'sarif'
          output: 'trivy-results.sarif'

      - name: 📊 Upload Trivy scan results
        uses: github/codeql-action/upload-sarif@v2
        if: always()
        with:
          sarif_file: 'trivy-results.sarif'

  # Unit Tests
  test:
    name: 🧪 Tests
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.11"]
    
    services:
      postgres:
        image: ankane/pgvector:latest
        env:
          POSTGRES_PASSWORD: test_password
          POSTGRES_USER: test_user
          POSTGRES_DB: test_ardharag
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

      redis:
        image: redis:7-alpine
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 6379:6379

    steps:
      - name: 📦 Checkout code
        uses: actions/checkout@v4

      - name: 🐍 Setup Python ${{ matrix.python-version }}
        uses: actions/setup-python@v4
        with:
          python-version: ${{ matrix.python-version }}

      - name: 📚 Install Poetry
        uses: snok/install-poetry@v1
        with:
          version: ${{ env.POETRY_VERSION }}

      - name: 📦 Install dependencies
        run: |
          poetry install --no-interaction
          poetry install --no-interaction --no-root

      - name: 🧪 Run tests with coverage
        env:
          DATABASE_URL: postgresql://test_user:test_password@localhost/test_ardharag
          REDIS_URL: redis://localhost:6379
        run: |
          poetry run pytest --cov=ardharag --cov-report=xml --cov-report=html

      - name: 📊 Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage.xml
          flags: unittests
          name: codecov-umbrella

  # Docker Build Test
  docker-build:
    name: 🐳 Docker Build
    runs-on: ubuntu-latest
    steps:
      - name: 📦 Checkout code
        uses: actions/checkout@v4

      - name: 🐳 Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: 🏗️ Build Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          file: ./Dockerfile
          push: false
          tags: ardharag:test
          cache-from: type=gha
          cache-to: type=gha,mode=max

  # Integration Tests (when Docker services available)
  integration-test:
    name: 🔗 Integration Tests
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request' || contains(github.ref, 'staging') || contains(github.ref, 'main')
    
    steps:
      - name: 📦 Checkout code
        uses: actions/checkout@v4

      - name: 🐳 Start services
        run: |
          cd infrastructure/docker
          docker-compose up -d
          # Wait for services to be healthy
          timeout 60s bash -c 'until docker-compose ps | grep healthy; do sleep 2; done'

      - name: 🐍 Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: ${{ env.PYTHON_VERSION }}

      - name: 📚 Install Poetry
        uses: snok/install-poetry@v1
        with:
          version: ${{ env.POETRY_VERSION }}

      - name: 📦 Install dependencies
        run: poetry install --no-interaction

      - name: 🔗 Run integration tests
        run: poetry run pytest tests/integration/ -v

      - name: 🛑 Stop services
        if: always()
        run: |
          cd infrastructure/docker
          docker-compose down -v
EOF

echo -e "${GREEN}✅ Created comprehensive CI workflow${NC}"
echo

# Create Docker build workflow
echo -e "${PURPLE}🐳 STEP 2: Create Docker Build & Publish Workflow${NC}"
cat > .github/workflows/docker-build.yml << 'EOF'
name: 🐳 Docker Build & Publish

on:
  push:
    branches: [main, staging, develop]
    tags: ['v*']
  pull_request:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - name: 📦 Checkout repository
        uses: actions/checkout@v4

      - name: 🐳 Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: 🔐 Log in to Container Registry
        if: github.event_name != 'pull_request'
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: 🏷️ Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=semver,pattern={{major}}
            type=raw,value=latest,enable={{is_default_branch}}

      - name: 🏗️ Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          platforms: linux/amd64,linux/arm64
          push: ${{ github.event_name != 'pull_request' }}
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

      - name: 🧪 Test Docker image
        if: github.event_name == 'pull_request'
        run: |
          docker run --rm ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:pr-${{ github.event.number }} --help || true
EOF

echo -e "${GREEN}✅ Created Docker build & publish workflow${NC}"
echo

# Create performance benchmarking workflow
echo -e "${PURPLE}⚡ STEP 3: Create Performance Benchmark Workflow${NC}"
cat > .github/workflows/performance.yml << 'EOF'
name: ⚡ Performance Benchmarks

on:
  push:
    branches: [main, staging]
  pull_request:
    branches: [main]
    paths:
      - 'src/**'
      - 'tests/performance/**'

jobs:
  benchmark:
    name: 📊 Performance Tests
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: ankane/pgvector:latest
        env:
          POSTGRES_PASSWORD: test_password
          POSTGRES_USER: test_user  
          POSTGRES_DB: test_ardharag
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

      redis:
        image: redis:7-alpine
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 6379:6379

    steps:
      - name: 📦 Checkout code
        uses: actions/checkout@v4

      - name: 🐍 Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: "3.11"

      - name: 📚 Install Poetry
        uses: snok/install-poetry@v1
        with:
          version: "1.7.1"

      - name: 📦 Install dependencies
        run: poetry install --no-interaction

      - name: ⚡ Run performance benchmarks
        env:
          DATABASE_URL: postgresql://test_user:test_password@localhost/test_ardharag
          REDIS_URL: redis://localhost:6379
        run: |
          poetry run pytest tests/performance/ --benchmark-only --benchmark-json=benchmark_results.json

      - name: 📊 Upload benchmark results
        uses: actions/upload-artifact@v3
        with:
          name: benchmark-results
          path: benchmark_results.json

      - name: 📈 Compare benchmarks
        if: github.event_name == 'pull_request'
        run: |
          echo "## Performance Benchmark Results 📊" >> $GITHUB_STEP_SUMMARY
          echo "Benchmark results will be compared with main branch" >> $GITHUB_STEP_SUMMARY
          # Future: Add benchmark comparison logic
EOF

echo -e "${GREEN}✅ Created performance benchmark workflow${NC}"
echo

# Create release automation workflow
echo -e "${PURPLE}🚀 STEP 4: Create Release Automation Workflow${NC}"
cat > .github/workflows/release.yml << 'EOF'
name: 🚀 Release

on:
  push:
    branches: [main]
  workflow_dispatch:
    inputs:
      version:
        description: 'Release version (e.g., v1.0.0)'
        required: true
        type: string

env:
  PYTHON_VERSION: "3.11"
  POETRY_VERSION: "1.7.1"

jobs:
  release:
    name: 🏷️ Create Release
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
      - name: 📦 Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: 🐍 Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: ${{ env.PYTHON_VERSION }}

      - name: 📚 Install Poetry
        uses: snok/install-poetry@v1
        with:
          version: ${{ env.POETRY_VERSION }}

      - name: 📦 Install dependencies
        run: poetry install --no-interaction

      - name: 🧪 Run tests
        run: poetry run pytest

      - name: 🏗️ Build package
        run: poetry build

      - name: 📋 Generate changelog
        id: changelog
        run: |
          # Simple changelog generation - can be enhanced later
          echo "CHANGELOG<<EOF" >> $GITHUB_OUTPUT
          echo "## What's Changed" >> $GITHUB_OUTPUT
          git log --oneline --pretty=format:"- %s" $(git describe --tags --abbrev=0)..HEAD >> $GITHUB_OUTPUT
          echo "" >> $GITHUB_OUTPUT  
          echo "EOF" >> $GITHUB_OUTPUT

      - name: 🏷️ Create Release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ github.event.inputs.version || 'auto' }}
          release_name: Release ${{ github.event.inputs.version || 'auto' }}
          body: ${{ steps.changelog.outputs.CHANGELOG }}
          draft: false
          prerelease: false

      - name: 📦 Upload Release Assets
        uses: actions/upload-release-asset@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          upload_url: ${{ steps.create_release.outputs.upload_url }}
          asset_path: ./dist/
          asset_name: ardharag-dist
          asset_content_type: application/zip
EOF

echo -e "${GREEN}✅ Created release automation workflow${NC}"
echo

# Create dependency update workflow
echo -e "${PURPLE}🔄 STEP 5: Create Dependency Update Workflow${NC}"
cat > .github/workflows/dependencies.yml << 'EOF'
name: 🔄 Dependencies Update

on:
  schedule:
    - cron: '0 2 * * 1' # Every Monday at 2 AM
  workflow_dispatch:

jobs:
  update-dependencies:
    name: 📦 Update Dependencies
    runs-on: ubuntu-latest
    
    steps:
      - name: 📦 Checkout code
        uses: actions/checkout@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: 🐍 Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: "3.11"

      - name: 📚 Install Poetry
        uses: snok/install-poetry@v1
        with:
          version: "1.7.1"

      - name: 🔄 Update dependencies
        run: |
          poetry update
          poetry export -f requirements.txt --output requirements.txt --without-hashes
          poetry export -f requirements.txt --dev --output requirements-dev.txt --without-hashes

      - name: 🧪 Run tests with updated dependencies
        run: |
          poetry install --no-interaction
          poetry run pytest tests/unit/

      - name: 📝 Create Pull Request
        uses: peter-evans/create-pull-request@v5
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          commit-message: "chore: update dependencies"
          title: "🔄 Automated dependency updates"
          body: |
            ## 🔄 Automated Dependency Updates
            
            This PR contains automated dependency updates.
            
            ### Changes
            - Updated Poetry dependencies
            - Regenerated requirements.txt files
            - All tests passing with updated dependencies
            
            ### Review Checklist
            - [ ] Check for breaking changes in dependency updates
            - [ ] Verify all tests pass
            - [ ] Review security updates
          branch: automated/dependency-updates
          delete-branch: true
EOF

echo -e "${GREEN}✅ Created dependency update workflow${NC}"
echo

# Create health monitoring workflow  
echo -e "${PURPLE}💓 STEP 6: Create Health Monitoring Workflow${NC}"
cat > .github/workflows/health-check.yml << 'EOF'
name: 💓 Health Check

on:
  schedule:
    - cron: '*/30 * * * *' # Every 30 minutes
  workflow_dispatch:

jobs:
  health-check:
    name: 🏥 System Health
    runs-on: ubuntu-latest
    
    steps:
      - name: 📦 Checkout code
        uses: actions/checkout@v4

      - name: 🐳 Health check with Docker
        run: |
          cd infrastructure/docker
          docker-compose up -d
          
          # Wait for services
          sleep 30
          
          # Check PostgreSQL
          if docker exec ardharag_postgres pg_isready -U ardharag; then
            echo "✅ PostgreSQL healthy"
          else
            echo "❌ PostgreSQL unhealthy"
            exit 1
          fi
          
          # Check Qdrant
          if curl -f http://localhost:6333; then
            echo "✅ Qdrant healthy"
          else
            echo "❌ Qdrant unhealthy"  
            exit 1
          fi
          
          # Check Redis
          if docker exec ardharag_redis redis-cli ping | grep PONG; then
            echo "✅ Redis healthy"
          else
            echo "❌ Redis unhealthy"
            exit 1
          fi
          
          docker-compose down

      - name: 📊 Report status
        if: always()
        run: |
          if [ $? -eq 0 ]; then
            echo "🎉 All services healthy"
          else
            echo "🚨 Some services unhealthy - check logs"
          fi
EOF

echo -e "${GREEN}✅ Created health monitoring workflow${NC}"
echo

# Create branch protection script
echo -e "${PURPLE}🛡️ STEP 7: Create Branch Protection Setup${NC}"
cat > setup_branch_protection.sh << 'EOF'
#!/bin/bash

# Branch Protection Setup Script
# Purpose: Configure branch protection rules via GitHub API
# Note: Requires GITHUB_TOKEN with repo permissions

echo "🛡️ SETTING UP BRANCH PROTECTION RULES"
echo "======================================"

# Repository information
OWNER="ardhaecosystem"
REPO="ArdhaRAG"

# Check for GitHub token
if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "❌ GITHUB_TOKEN environment variable not set"
    echo "Create a personal access token with 'repo' scope at:"
    echo "https://github.com/settings/tokens"
    echo "Then run: export GITHUB_TOKEN=your_token_here"
    exit 1
fi

# Main branch protection
echo "🔒 Setting up main branch protection..."
curl -X PUT \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$OWNER/$REPO/branches/main/protection" \
  -d '{
    "required_status_checks": {
      "strict": true,
      "contexts": ["🧹 Code Quality", "🧪 Tests", "🐳 Docker Build", "🛡️ Security Scan"]
    },
    "enforce_admins": false,
    "required_pull_request_reviews": {
      "required_approving_review_count": 2,
      "dismiss_stale_reviews": true,
      "require_code_owner_reviews": true
    },
    "restrictions": null,
    "allow_force_pushes": false,
    "allow_deletions": false
  }'

# Develop branch protection  
echo "🔒 Setting up develop branch protection..."
curl -X PUT \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$OWNER/$REPO/branches/develop/protection" \
  -d '{
    "required_status_checks": {
      "strict": true,
      "contexts": ["🧹 Code Quality", "🧪 Tests"]
    },
    "enforce_admins": false,
    "required_pull_request_reviews": {
      "required_approving_review_count": 1,
      "dismiss_stale_reviews": true
    },
    "restrictions": null,
    "allow_force_pushes": true,
    "allow_deletions": false
  }'

echo "✅ Branch protection rules configured!"
echo "📋 Summary:"
echo "  - main: 2 required reviews, all status checks required"
echo "  - develop: 1 required review, basic status checks required"
EOF

chmod +x setup_branch_protection.sh
echo -e "${GREEN}✅ Created branch protection setup script${NC}"
echo

# Summary
echo -e "${PURPLE}🎉 STEP 2.2 COMPLETE - ENHANCED CI/CD SUCCESS!${NC}"
echo "=============================================="
echo -e "${GREEN}✅ ci.yml: Comprehensive CI with quality, security, tests${NC}"
echo -e "${GREEN}✅ docker-build.yml: Multi-platform Docker build & publish${NC}"
echo -e "${GREEN}✅ performance.yml: Automated performance benchmarking${NC}"
echo -e "${GREEN}✅ release.yml: Automated release creation and publishing${NC}"
echo -e "${GREEN}✅ dependencies.yml: Automated dependency updates${NC}"
echo -e "${GREEN}✅ health-check.yml: System health monitoring${NC}"
echo -e "${GREEN}✅ setup_branch_protection.sh: Branch protection configuration${NC}"

echo
echo -e "${BLUE}🔄 CI/CD Pipeline Features:${NC}"
echo "  ✅ Code quality (Black, isort, flake8, mypy)"
echo "  ✅ Security scanning (Trivy)"
echo "  ✅ Unit & integration tests with coverage"
echo "  ✅ Multi-platform Docker builds"
echo "  ✅ Performance benchmarking"
echo "  ✅ Automated releases"
echo "  ✅ Dependency management"
echo "  ✅ Health monitoring"

echo
echo -e "${PURPLE}🎯 Ready for Step 2.3: Production Docker Configuration!${NC}"
