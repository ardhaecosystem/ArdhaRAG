#!/bin/bash

# Step 2.1: GitHub Community Standards Implementation
# Purpose: Add all professional community standards files
# Location: Run from /opt/ardha-ecosystem/projects/ardharag/

set -euo pipefail

echo "🎯 STEP 2.1: GITHUB COMMUNITY STANDARDS IMPLEMENTATION"
echo "====================================================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verify migration branch
CURRENT_BRANCH=$(git branch --show-current)
if [[ "$CURRENT_BRANCH" != "migrate/world-class-structure" ]]; then
    echo "❌ Must be in migrate/world-class-structure branch"
    exit 1
fi

echo -e "${GREEN}✅ Branch confirmed: $CURRENT_BRANCH${NC}"
echo

# Create GitHub directory structure
echo -e "${PURPLE}📁 STEP 1: Create .github Directory Structure${NC}"
mkdir -p .github/{ISSUE_TEMPLATE,workflows}
mkdir -p .github/DISCUSSION_TEMPLATE
echo -e "${GREEN}✅ Created .github directory structure${NC}"
echo

# Create CONTRIBUTING.md
echo -e "${PURPLE}📄 STEP 2: Create CONTRIBUTING.md${NC}"
cat > CONTRIBUTING.md << 'EOF'
# Contributing to ArdhaRAG

Thank you for your interest in contributing to ArdhaRAG - the world's first predictive RAG system! 🎯

## Quick Start for Contributors

### Prerequisites
- Python 3.11+
- Docker and Docker Compose
- Git
- 8GB+ RAM recommended

### Development Setup
```bash
# Clone and setup
git clone https://github.com/ardhaecosystem/ArdhaRAG.git
cd ArdhaRAG
git checkout develop

# Install dependencies
poetry install
poetry shell

# Start database services
cd infrastructure/docker
docker-compose up -d

# Verify setup
cd ../..
python -c "import ardharag; print('✅ Setup complete!')"
```

## How to Contribute

### 1. Types of Contributions
- 🐛 **Bug reports and fixes**
- ✨ **New features and enhancements**  
- 📚 **Documentation improvements**
- 🧪 **Tests and performance improvements**
- 🌐 **Examples and tutorials**

### 2. Development Workflow
1. **Fork** the repository
2. **Create branch** from `develop`: `git checkout -b feature/your-feature`
3. **Make changes** following our coding standards
4. **Add tests** for new functionality
5. **Update documentation** as needed
6. **Submit pull request** to `develop` branch

### 3. Coding Standards
- **Python**: Follow PEP 8, use type hints, 100-char line limit
- **Testing**: Add tests for all new features (pytest)
- **Documentation**: Update docstrings and README as needed
- **Commits**: Use conventional commits (`feat:`, `fix:`, `docs:`, etc.)

### 4. Special Areas

#### 🔮 Predictive Intelligence (Phase 6)
ArdhaRAG's unique predictive capabilities using Markov Chains:
- Temporal intelligence algorithms
- Cross-domain prediction models
- Anticipatory context assembly
- Knowledge evolution forecasting

#### 🎯 Context-Aware Prompt Engineering (CAPE)
Our 40-60% token reduction system:
- Context optimization algorithms
- Provider-specific prompt templates
- Response verification systems
- Token compression strategies

### 5. Performance Requirements
- Memory usage must stay under 8GB total system usage
- Response time <5 seconds for 90% of queries
- All database operations must use connection pooling
- Concurrent user support (5-10 users minimum)

## Getting Help

- 💬 **GitHub Discussions** - General questions and ideas
- 🐛 **GitHub Issues** - Bug reports and feature requests
- 📧 **Email** - ardhaecosystem@gmail.com for private matters

## Recognition

Contributors will be:
- Listed in our CONTRIBUTORS.md file
- Mentioned in release notes
- Given credit in academic papers (when applicable)
- Invited to join our core contributor team

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Ready to contribute to the future of AI?** 🚀 Start with a "good first issue" label!
EOF

echo -e "${GREEN}✅ Created CONTRIBUTING.md${NC}"
echo

# Create CODE_OF_CONDUCT.md
echo -e "${PURPLE}📄 STEP 3: Create CODE_OF_CONDUCT.md${NC}"
cat > CODE_OF_CONDUCT.md << 'EOF'
# Code of Conduct

## Our Pledge

We as members, contributors, and leaders pledge to make participation in ArdhaRAG a harassment-free experience for everyone, regardless of age, body size, visible or invisible disability, ethnicity, sex characteristics, gender identity and expression, level of experience, education, socio-economic status, nationality, personal appearance, race, religion, or sexual identity and orientation.

## Our Standards

### Positive Behaviors ✅
- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members
- Helping newcomers learn and contribute
- Celebrating diverse perspectives and approaches

### Unacceptable Behaviors ❌
- The use of sexualized language or imagery, and sexual attention or advances
- Trolling, insulting or derogatory comments, and personal or political attacks
- Public or private harassment
- Publishing others' private information without explicit permission
- Other conduct which could reasonably be considered inappropriate in a professional setting
- Dismissing or attacking inclusion-oriented requests

## Scope

This Code of Conduct applies within all community spaces, and also applies when an individual is officially representing the community in public spaces.

## Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be reported to the community leaders responsible for enforcement at ardhaecosystem@gmail.com.

All complaints will be reviewed and investigated promptly and fairly.

Community leaders have the right and responsibility to remove, edit, or reject comments, commits, code, wiki edits, issues, and other contributions that are not aligned to this Code of Conduct.

## Enforcement Guidelines

### 1. Correction
**Community Impact**: Use of inappropriate language or other behavior deemed unprofessional.
**Consequence**: A private, written warning with clarity around the nature of the violation.

### 2. Warning  
**Community Impact**: A violation through a single incident or series of actions.
**Consequence**: A warning with consequences for continued behavior.

### 3. Temporary Ban
**Community Impact**: A serious violation of community standards.
**Consequence**: A temporary ban from any sort of interaction or public communication with the community.

### 4. Permanent Ban
**Community Impact**: Demonstrating a pattern of violation of community standards.
**Consequence**: A permanent ban from any sort of public interaction within the community.

## Attribution

This Code of Conduct is adapted from the [Contributor Covenant](https://www.contributor-covenant.org/), version 2.1.

For answers to common questions, see the FAQ at https://www.contributor-covenant.org/faq.
EOF

echo -e "${GREEN}✅ Created CODE_OF_CONDUCT.md${NC}"
echo

# Create SECURITY.md
echo -e "${PURPLE}📄 STEP 4: Create SECURITY.md${NC}"
cat > SECURITY.md << 'EOF'
# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | ✅ Yes (Development) |

## Reporting a Vulnerability

### 🚨 For Security Issues

**DO NOT** create a public issue for security vulnerabilities.

Instead, please email us directly at: **ardhaecosystem@gmail.com**

Include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact assessment
- Suggested fix (if you have one)

### Response Timeline

- **Acknowledgment**: Within 24 hours
- **Initial Assessment**: Within 72 hours  
- **Status Updates**: Weekly until resolved
- **Resolution**: Depends on severity (1-30 days)

### Security Best Practices

#### For Users
- Always use the latest version
- Keep Docker images updated
- Use environment variables for secrets
- Enable firewall protection
- Regular backup of data

#### For Contributors
- Never commit secrets or API keys
- Use secure coding practices
- Validate all inputs
- Follow authentication best practices
- Test security-related changes thoroughly

### Vulnerability Categories

#### High Priority 🔴
- Remote code execution
- SQL injection vulnerabilities
- Authentication bypass
- Data exposure in logs
- Container escape vulnerabilities

#### Medium Priority 🟡
- Cross-site scripting (XSS)
- Information disclosure
- Denial of service vulnerabilities
- Privilege escalation

#### Low Priority 🟢
- Information leakage
- Minor configuration issues

### Security Features in ArdhaRAG

- **Input Validation**: All user inputs are validated and sanitized
- **Database Security**: Parameterized queries prevent SQL injection
- **Container Security**: Minimal Docker images with security scanning
- **Authentication**: JWT-based authentication for API endpoints
- **Network Security**: Database ports restricted to localhost
- **Secrets Management**: Environment-based configuration

### Hall of Fame 🏆

We recognize security researchers who help improve ArdhaRAG:

*Contributors will be listed here after responsible disclosure*

---

**Security is a community effort!** Help us keep ArdhaRAG safe for everyone. 🛡️
EOF

echo -e "${GREEN}✅ Created SECURITY.md${NC}"
echo

# Create SUPPORT.md
echo -e "${PURPLE}📄 STEP 5: Create SUPPORT.md${NC}"
cat > SUPPORT.md << 'EOF'
# Support

## Getting Help with ArdhaRAG

### 📚 Documentation First
Before seeking help, please check:

- **[README.md](README.md)** - Project overview and quick start
- **[Installation Guide](docs/installation/)** - Detailed setup instructions
- **[User Guide](docs/user_guide/)** - How to use ArdhaRAG
- **[API Documentation](docs/api/)** - API reference
- **[Troubleshooting](docs/troubleshooting.md)** - Common issues and solutions

### 💬 Community Support

#### GitHub Discussions (Recommended)
- **[Q&A](https://github.com/ardhaecosystem/ArdhaRAG/discussions/categories/q-a)** - Ask questions
- **[Ideas](https://github.com/ardhaecosystem/ArdhaRAG/discussions/categories/ideas)** - Share feature ideas
- **[Show and Tell](https://github.com/ardhaecosystem/ArdhaRAG/discussions/categories/show-and-tell)** - Share your projects

#### GitHub Issues
- **Bug reports** - Use issue templates
- **Feature requests** - Describe your use case
- **Documentation improvements** - Help us improve docs

### 🐛 Reporting Bugs

When reporting bugs, please include:

```
**Environment**
- OS: [e.g., Ubuntu 22.04]
- Python: [e.g., 3.11.7]  
- ArdhaRAG Version: [e.g., 0.1.0]
- Docker Version: [e.g., 24.0.7]

**Description**
Clear description of what went wrong

**Steps to Reproduce**
1. Step one
2. Step two
3. See error

**Expected Behavior**
What should have happened

**Actual Behavior**
What actually happened

**Logs**
```
[Paste relevant logs here]
```

**Additional Context**
Screenshots, configuration files, etc.
```

### ✨ Feature Requests

For new features, please describe:
- **Use case**: Why do you need this feature?
- **Proposed solution**: How should it work?
- **Alternatives**: What alternatives have you considered?
- **Additional context**: Screenshots, examples, etc.

### 🔧 Installation Issues

#### Common Issues and Solutions

**Docker services not starting:**
```bash
# Check Docker status
docker-compose ps

# Check logs
docker-compose logs [service-name]

# Restart services
docker-compose restart
```

**Python import errors:**
```bash
# Reinstall package
poetry install

# Check Python path
python -c "import sys; print(sys.path)"
```

**Memory issues:**
```bash
# Check memory usage
free -h

# Check ZRAM status
zramctl
```

### 📧 Direct Contact

For sensitive issues or private matters:
**Email**: ardhaecosystem@gmail.com

**Please use public channels when possible** - it helps others who might have the same question!

### ⏰ Response Times

- **GitHub Discussions**: Usually within 24-48 hours
- **GitHub Issues**: Usually within 2-3 days  
- **Email**: Usually within 1-2 days

### 🎯 Premium Support

Currently, all support is community-based and free. We may offer premium support options in the future.

---

**We're here to help you succeed with ArdhaRAG!** 🚀
EOF

echo -e "${GREEN}✅ Created SUPPORT.md${NC}"
echo

# Create issue templates
echo -e "${PURPLE}📄 STEP 6: Create Issue Templates${NC}"

# Bug report template
cat > .github/ISSUE_TEMPLATE/bug_report.yml << 'EOF'
name: 🐛 Bug Report
description: Report a bug or unexpected behavior
title: "[BUG]: "
labels: ["bug", "needs-triage"]
body:
  - type: markdown
    attributes:
      value: |
        Thanks for taking the time to fill out this bug report! 🐛
        
        Before submitting, please check if your issue has already been reported.

  - type: checkboxes
    id: checks
    attributes:
      label: Pre-submission checks
      options:
        - label: I searched existing issues and didn't find a duplicate
          required: true
        - label: I've read the documentation and troubleshooting guide
          required: true

  - type: dropdown
    id: component
    attributes:
      label: Component
      description: Which component is affected?
      options:
        - Core RAG Engine
        - CAPE (Context Optimization)
        - Knowledge Graphs
        - Database (PostgreSQL/Qdrant/Redis)
        - Web Interface
        - API Endpoints
        - Docker/Installation
        - Documentation
    validations:
      required: true

  - type: textarea
    id: environment
    attributes:
      label: Environment
      description: System environment details
      placeholder: |
        - OS: [e.g., Ubuntu 22.04]
        - Python: [e.g., 3.11.7]
        - ArdhaRAG Version: [e.g., 0.1.0]
        - Docker Version: [e.g., 24.0.7]
        - RAM: [e.g., 8GB]
        - Browser: [if web interface issue]
    validations:
      required: true

  - type: textarea
    id: description
    attributes:
      label: Bug Description
      description: Clear and concise description of the bug
      placeholder: What went wrong?
    validations:
      required: true

  - type: textarea
    id: reproduction
    attributes:
      label: Steps to Reproduce
      description: Detailed steps to reproduce the issue
      placeholder: |
        1. Start ArdhaRAG with command...
        2. Upload document...
        3. Query: "..."
        4. See error...
    validations:
      required: true

  - type: textarea
    id: expected
    attributes:
      label: Expected Behavior
      description: What should have happened?
    validations:
      required: true

  - type: textarea
    id: actual
    attributes:
      label: Actual Behavior  
      description: What actually happened?
    validations:
      required: true

  - type: textarea
    id: logs
    attributes:
      label: Relevant Logs
      description: Paste relevant log output
      render: shell
      placeholder: |
        # Docker logs
        docker-compose logs

        # Application logs  
        tail -f data/logs/ardharag.log

  - type: textarea
    id: context
    attributes:
      label: Additional Context
      description: Screenshots, configuration files, or anything else that might help
EOF

# Feature request template
cat > .github/ISSUE_TEMPLATE/feature_request.yml << 'EOF'
name: ✨ Feature Request
description: Suggest a new feature or enhancement
title: "[FEATURE]: "
labels: ["enhancement", "needs-review"]
body:
  - type: markdown
    attributes:
      value: |
        Thank you for suggesting a new feature! ✨
        
        Please provide as much detail as possible to help us understand your request.

  - type: dropdown
    id: category
    attributes:
      label: Feature Category
      description: What type of feature is this?
      options:
        - Core RAG Functionality
        - Predictive Intelligence
        - Context Optimization (CAPE)
        - Knowledge Graphs
        - User Interface
        - API Enhancements
        - Performance
        - Security
        - Documentation
        - Developer Experience
    validations:
      required: true

  - type: textarea
    id: problem
    attributes:
      label: Problem Statement
      description: What problem does this feature solve?
      placeholder: "I'm frustrated when..."
    validations:
      required: true

  - type: textarea
    id: solution
    attributes:
      label: Proposed Solution
      description: Describe your proposed solution
      placeholder: "I would like to see..."
    validations:
      required: true

  - type: textarea
    id: alternatives
    attributes:
      label: Alternative Solutions
      description: Describe alternatives you've considered
      placeholder: "I also considered..."

  - type: dropdown
    id: priority
    attributes:
      label: Priority
      description: How important is this feature?
      options:
        - "Critical - Blocking my work"
        - "High - Important for next release"
        - "Medium - Nice to have soon"  
        - "Low - Future consideration"
    validations:
      required: true

  - type: checkboxes
    id: contribution
    attributes:
      label: Contribution
      options:
        - label: I'm willing to contribute to implementing this feature
        - label: I can provide testing for this feature
        - label: I can provide documentation for this feature
EOF

echo -e "${GREEN}✅ Created comprehensive issue templates${NC}"
echo

# Create pull request template
echo -e "${PURPLE}📄 STEP 7: Create Pull Request Template${NC}"
cat > .github/PULL_REQUEST_TEMPLATE.md << 'EOF'
## 🎯 Pull Request Description

### Changes Made
<!-- Describe what changes you made and why -->

### Type of Change
- [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
- [ ] ✨ New feature (non-breaking change which adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📚 Documentation update
- [ ] 🧪 Test improvements
- [ ] ⚡ Performance optimization
- [ ] 🔧 Refactoring

### Component(s) Affected
- [ ] Core RAG Engine
- [ ] CAPE (Context Optimization)
- [ ] Knowledge Graphs  
- [ ] Database Layer
- [ ] API Endpoints
- [ ] Web Interface
- [ ] Documentation
- [ ] Tests

### Testing
- [ ] I have added tests that prove my changes work
- [ ] I have run the existing test suite and all tests pass
- [ ] I have tested the changes manually
- [ ] I have tested with different configurations

### Performance Impact
- [ ] No performance impact
- [ ] Performance improvement
- [ ] Minimal performance impact (< 5% degradation)
- [ ] Significant performance impact (needs discussion)

**Memory Usage**: <!-- Does this change affect memory usage? -->
**Query Performance**: <!-- Does this affect query response times? -->

### Documentation
- [ ] I have updated relevant documentation
- [ ] I have updated docstrings for new/modified functions
- [ ] I have added examples for new features
- [ ] No documentation changes needed

### Checklist
- [ ] My code follows the project's coding standards
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] My changes generate no new warnings
- [ ] I have rebased my branch on the latest develop branch

### Related Issues
<!-- Link related issues using "Closes #issue_number" or "Refs #issue_number" -->

### Screenshots/Demos
<!-- If applicable, add screenshots or demos to help explain your changes -->

---

**Ready to make ArdhaRAG better!** 🚀
EOF

echo -e "${GREEN}✅ Created pull request template${NC}"
echo

# Create FUNDING.yml
echo -e "${PURPLE}📄 STEP 8: Create Funding Configuration${NC}"
cat > .github/FUNDING.yml << 'EOF'
# GitHub Sponsors funding configuration
# These are supported funding model platforms

github: # Replace with up to 4 GitHub Sponsors-enabled usernames e.g., [user1, user2]
patreon: # Replace with a single Patreon username
open_collective: # Replace with a single Open Collective username
ko_fi: # Replace with a single Ko-fi username
tidelift: # Replace with a single Tidelift platform-name/package-name e.g., npm/babel
community_bridge: # Replace with a single Community Bridge project-name e.g., cloud-foundry
liberapay: # Replace with a single Liberapay username
issuehunt: # Replace with a single IssueHunt username
otechie: # Replace with a single Otechie username
lfx_crowdfunding: # Replace with a single LFX Crowdfunding project-name e.g., cloud-foundry
custom: ["https://github.com/ardhaecosystem/ArdhaRAG"] # Replace with up to 4 custom sponsorship URLs e.g., ['link1', 'link2']
EOF

echo -e "${GREEN}✅ Created funding configuration${NC}"
echo

# Summary
echo -e "${PURPLE}🎉 STEP 2.1 COMPLETE - COMMUNITY STANDARDS SUCCESS!${NC}"
echo "========================================================="
echo -e "${GREEN}✅ CONTRIBUTING.md: Comprehensive contribution guide${NC}"
echo -e "${GREEN}✅ CODE_OF_CONDUCT.md: Community behavior standards${NC}"
echo -e "${GREEN}✅ SECURITY.md: Security reporting policy${NC}"
echo -e "${GREEN}✅ SUPPORT.md: How to get help guide${NC}"
echo -e "${GREEN}✅ Bug report template: Professional issue form${NC}"
echo -e "${GREEN}✅ Feature request template: Enhancement proposals${NC}"
echo -e "${GREEN}✅ Pull request template: Comprehensive PR guide${NC}"
echo -e "${GREEN}✅ FUNDING.yml: Sponsorship configuration${NC}"

echo
echo -e "${BLUE}📊 GitHub Community Standards Status:${NC}"
echo "  ✅ Code of conduct"
echo "  ✅ Contributing guidelines"
echo "  ✅ Security policy"
echo "  ✅ Support resources"
echo "  ✅ Issue templates"
echo "  ✅ Pull request template"

echo
echo -e "${PURPLE}🎯 Ready for Step 2.2: Enhanced CI/CD Workflows!${NC}"
