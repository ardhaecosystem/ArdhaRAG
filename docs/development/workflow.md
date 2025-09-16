# ArdhaRAG Development Workflow

## Branch Strategy

### Branch Structure
```
main (production)
├── staging (pre-production testing)
├── develop (integration)
└── feature/* (individual features)
```

### Branch Purposes

#### `main` - Production Branch
- **Purpose**: Production-ready code only
- **Protection**: 2 required reviews, all status checks required
- **Deployment**: Automatic to production environment
- **Merge Source**: Only from `staging` after thorough testing

#### `staging` - Pre-Production Branch  
- **Purpose**: Final testing before production
- **Protection**: 1 required review, all status checks required
- **Deployment**: Automatic to staging environment
- **Merge Source**: From `develop` when ready for release testing

#### `develop` - Integration Branch
- **Purpose**: Integration point for all feature development
- **Protection**: 1 required review, basic status checks
- **Deployment**: Automatic to development environment
- **Merge Source**: From `feature/*` branches via pull requests

#### `feature/*` - Feature Branches
- **Purpose**: Individual feature development
- **Naming**: `feature/description` or `feature/issue-number`
- **Merge Target**: Always merge to `develop`
- **Lifetime**: Delete after merge

## Development Process

### 1. Starting New Work
```bash
# Get latest develop
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/your-feature-name

# Work on feature...
git add .
git commit -m "feat: implement your feature"

# Push and create PR
git push origin feature/your-feature-name
```

### 2. Pull Request Process
1. **Create PR** to `develop` branch
2. **Fill PR template** completely
3. **Ensure CI passes** (code quality, tests, security scan)
4. **Request review** from team members
5. **Address feedback** and update
6. **Merge after approval**

### 3. Release Process
```bash
# When develop is ready for testing
1. Create PR: develop → staging
2. Deploy to staging environment
3. Run integration tests
4. Manual testing and validation
5. After 24h+ stable: staging → main
6. Deploy to production
7. Monitor and validate
```

## Automated Deployments

### Per-Branch Deployment Triggers

#### Development Environment
- **Trigger**: Push to `develop` branch
- **URL**: http://dev.ardharag.local:8000
- **Database**: Development database
- **Logging**: Debug level

#### Staging Environment  
- **Trigger**: Push to `staging` branch
- **URL**: http://staging.ardharag.local:8080
- **Database**: Staging database (production-like)
- **Logging**: Info level

#### Production Environment
- **Trigger**: Push to `main` branch
- **URL**: https://ardharag.com (or your domain)
- **Database**: Production database
- **Logging**: Error level only

## Quality Gates

### All Branches
- ✅ Code formatting (Black, isort)
- ✅ Linting (flake8)
- ✅ Type checking (mypy)
- ✅ Unit tests passing
- ✅ Security scan passing

### Staging Branch (Additional)
- ✅ Integration tests passing
- ✅ Performance benchmarks within limits
- ✅ Docker builds successful
- ✅ Manual testing checklist completed

### Main Branch (Additional)
- ✅ 24+ hours stable on staging
- ✅ Production readiness checklist
- ✅ Backup procedures verified
- ✅ Rollback plan confirmed

## Emergency Procedures

### Hotfix Process
```bash
# For critical production fixes
git checkout main
git checkout -b hotfix/critical-issue
# Make minimal fix
git push origin hotfix/critical-issue
# Create PR directly to main (bypass develop)
# Deploy immediately after merge
# Backport to develop and staging
```

### Rollback Process
```bash
# Production rollback
./deploy.sh production rollback

# Or manual rollback
git revert <commit-hash>
git push origin main
```

## Development Environment Setup

### Prerequisites
- Docker and Docker Compose
- Python 3.11+
- Poetry 1.7+
- Git with SSH keys configured

### Quick Setup
```bash
# Clone repository
git clone git@github.com:ardhaecosystem/ArdhaRAG.git
cd ArdhaRAG

# Checkout develop branch
git checkout develop

# Install dependencies
poetry install

# Start development services
cd infrastructure/docker
docker-compose up -d

# Run tests to verify setup
cd ../..
poetry run pytest
```

## Code Standards

### Commit Message Format
```
type(scope): description

feat: add new feature
fix: fix bug
docs: update documentation
test: add tests
refactor: refactor code
style: formatting changes
chore: maintenance tasks
```

### Code Review Checklist
- [ ] Code follows PEP 8 standards
- [ ] Functions have type hints
- [ ] Tests cover new functionality
- [ ] Documentation updated
- [ ] No hardcoded secrets
- [ ] Performance impact considered
- [ ] Security implications reviewed

## Monitoring and Observability

### Development
- Logs: `docker-compose logs -f`
- Metrics: Built-in development metrics
- Health: `curl http://localhost:8000/health`

### Staging  
- Logs: Centralized logging system
- Metrics: Prometheus + Grafana
- Health: Automated health checks every 5 minutes

### Production
- Logs: Centralized with alerting
- Metrics: Full observability stack
- Health: Automated health checks every 1 minute
- Alerting: PagerDuty/Slack integration

## Best Practices

### Feature Development
1. Keep features small and focused
2. Write tests first (TDD)
3. Document complex logic
4. Consider performance impact
5. Test on different environments

### Code Quality
1. Run pre-commit hooks locally
2. Fix all linting issues before PR
3. Maintain >80% test coverage
4. Use meaningful variable names
5. Keep functions small and focused

### Collaboration
1. Communicate early and often
2. Ask for help when stuck
3. Review others' code thoughtfully
4. Keep PRs manageable size
5. Document decisions and rationale
