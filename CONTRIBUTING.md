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
