# Branch Protection Configuration

## Overview
This document describes the branch protection rules configured for ArdhaRAG repository.

## Branch Protection Rules

### Main Branch (`main`)
**Purpose**: Production-ready code only

**Protection Rules**:
- ✅ Require pull request reviews (2 reviewers)
- ✅ Dismiss stale PR reviews when new commits are pushed
- ✅ Require review from code owners
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging
- ✅ Required status checks:
  - 🧹 Code Quality
  - 🧪 Tests  
  - 🐳 Docker Build
  - 🛡️ Security Scan
  - ⚡ Performance Benchmarks
- ❌ Allow force pushes: **Disabled**
- ❌ Allow deletions: **Disabled**
- 🔒 Restrict pushes to specific people/teams

### Staging Branch (`staging`)
**Purpose**: Pre-production testing environment

**Protection Rules**:
- ✅ Require pull request reviews (1 reviewer)
- ✅ Dismiss stale PR reviews when new commits are pushed
- ✅ Require status checks to pass before merging
- ✅ Required status checks:
  - 🧹 Code Quality
  - 🧪 Tests
  - 🐳 Docker Build
  - 🔗 Integration Tests
- ❌ Allow force pushes: **Disabled**
- ❌ Allow deletions: **Disabled**

### Develop Branch (`develop`)
**Purpose**: Integration branch for feature development

**Protection Rules**:
- ✅ Require pull request reviews (1 reviewer)
- ✅ Require status checks to pass before merging
- ✅ Required status checks:
  - 🧹 Code Quality
  - 🧪 Tests
- ✅ Allow force pushes: **Enabled** (for development flexibility)
- ❌ Allow deletions: **Disabled**

## Setup Instructions

### Automatic Setup (Recommended)
```bash
# Set your GitHub token
export GITHUB_TOKEN=your_github_token_here

# Run the setup script
./setup_branch_protection.sh
```

### Manual Setup
1. Go to repository settings on GitHub
2. Click "Branches" in the left sidebar
3. Add rules for each branch following the specifications above

## Status Check Requirements

### Code Quality Checks
- **Black**: Code formatting
- **isort**: Import sorting  
- **flake8**: Code linting
- **mypy**: Type checking

### Testing Requirements
- **Unit Tests**: All unit tests must pass
- **Coverage**: Minimum 80% code coverage
- **Integration Tests**: Required for staging/main

### Security Requirements
- **Trivy Scan**: Vulnerability scanning
- **Dependency Check**: Known vulnerability scanning
- **Secret Scanning**: No hardcoded secrets

### Performance Requirements
- **Benchmark Tests**: Performance regression detection
- **Resource Limits**: Memory usage within 8GB constraints
- **Response Time**: API endpoints <5s response time

## Override Procedures

### Emergency Hotfixes
In case of critical production issues, repository admins can:
1. Temporarily disable branch protection
2. Push direct fixes to main
3. Re-enable protection immediately
4. Create post-incident review

### Scheduled Maintenance
For planned maintenance windows:
1. Create maintenance branch from main
2. Apply protection rules to maintenance branch
3. Perform updates on maintenance branch
4. Merge back to main with standard process

## Monitoring and Compliance

### Branch Protection Monitoring
- Weekly audit of protection rules
- Automated alerts for rule changes
- Compliance reporting for security team

### Violation Handling
1. Automatic rejection of non-compliant PRs
2. Notification to PR author with remediation steps
3. Escalation to team leads for repeated violations
4. Documentation of all violations for team review
