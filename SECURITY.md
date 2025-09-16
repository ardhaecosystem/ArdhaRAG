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
