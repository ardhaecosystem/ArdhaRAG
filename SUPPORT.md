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
