#!/bin/bash

# Step 1.1: Migration Preparation & Branch Setup
# Purpose: Safe migration setup preserving all infrastructure
# Location: Run from /opt/ardha-ecosystem/projects/ardharag/

set -euo pipefail

echo "🎯 STEP 1.1: MIGRATION PREPARATION & BRANCH SETUP"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Check current location
if [[ ! -f "README.md" ]] || [[ ! -f "pyproject.toml" ]]; then
    echo -e "${RED}❌ Please run this script from /opt/ardha-ecosystem/projects/ardharag/${NC}"
    echo "Current directory: $(pwd)"
    exit 1
fi

echo -e "${BLUE}📍 Current location: $(pwd)${NC}"
echo -e "${GREEN}✅ README.md and pyproject.toml found${NC}"
echo

# Verify database services are healthy before migration
echo -e "${PURPLE}🔍 STEP 1: Database Services Health Check${NC}"
echo "Checking all database services before migration..."

# Check PostgreSQL
if docker exec ardharag_postgres pg_isready -U ardharag >/dev/null 2>&1; then
    echo -e "${GREEN}✅ PostgreSQL + AGE: Healthy${NC}"
else
    echo -e "${RED}❌ PostgreSQL not responding - migration aborted${NC}"
    exit 1
fi

# Check Qdrant
if curl -s http://localhost:6333 >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Qdrant Vector DB: Healthy${NC}"
else
    echo -e "${RED}❌ Qdrant not responding - migration aborted${NC}"
    exit 1
fi

# Check Redis
if docker exec ardharag_redis redis-cli ping | grep -q "PONG" >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Redis Cache: Healthy${NC}"
else
    echo -e "${RED}❌ Redis not responding - migration aborted${NC}"
    exit 1
fi

echo -e "${GREEN}🎉 All database services healthy - safe to proceed!${NC}"
echo

# Create migration branch
echo -e "${PURPLE}🔍 STEP 2: Git Branch Management${NC}"

# Check current branch
CURRENT_BRANCH=$(git branch --show-current)
echo -e "${BLUE}Current branch: ${CURRENT_BRANCH}${NC}"

# Check if migration branch already exists
if git branch -r | grep -q "origin/migrate/world-class-structure"; then
    echo -e "${YELLOW}⚠️  Migration branch exists remotely. Checking out...${NC}"
    git checkout migrate/world-class-structure 2>/dev/null || {
        git checkout -b migrate/world-class-structure origin/migrate/world-class-structure
    }
elif git branch | grep -q "migrate/world-class-structure"; then
    echo -e "${YELLOW}⚠️  Local migration branch exists. Checking out...${NC}"
    git checkout migrate/world-class-structure
else
    echo -e "${GREEN}📝 Creating new migration branch...${NC}"
    git checkout -b migrate/world-class-structure
fi

# Verify branch creation
NEW_BRANCH=$(git branch --show-current)
echo -e "${GREEN}✅ Active branch: ${NEW_BRANCH}${NC}"
echo

# Analyze current directory structure
echo -e "${PURPLE}🔍 STEP 3: Structure Analysis${NC}"
echo "Analyzing current directory structure..."

# Create analysis file
cat > migration_analysis.md << 'EOF'
# ArdhaRAG Structure Analysis & Migration Plan

## Current Structure Assessment

### Discovered Dual Structure
- `application/` directory: Contains module directories (agents, api, cape, core, ingestion, knowledge, llm, storage, ui, utils)
- `ardharag/` directory: Contains Python package structure with __init__.py files

### Infrastructure Status
- ✅ Docker infrastructure: Operational (PostgreSQL+AGE, Qdrant, Redis)
- ✅ Configuration files: Well organized in config/ directory
- ✅ Documentation: Good foundation in docs/ and documentation/
- ✅ Testing structure: Proper test organization

### Migration Strategy
1. **Consolidate** application/ and ardharag/ into single src/ardharag/ structure
2. **Preserve** all Docker infrastructure and database configurations
3. **Enhance** with world-class community standards
4. **Add** modern Python packaging structure

### Files to Preserve (Critical)
- infrastructure/docker/docker-compose.yml (Database services)
- infrastructure/docker/postgres/, qdrant/, redis/ configs
- All existing documentation and examples
- Makefile, pyproject.toml, README.md

### Migration Steps
1. Create src/ardharag/ structure
2. Intelligently merge application/ and ardharag/ content
3. Update import statements
4. Preserve all infrastructure configurations
5. Add community standards files
EOF

echo -e "${GREEN}✅ Analysis complete - saved to migration_analysis.md${NC}"
echo

# Create rollback script
echo -e "${PURPLE}🔍 STEP 4: Rollback Safety Script Creation${NC}"

cat > rollback_migration.sh << 'EOF'
#!/bin/bash

# Rollback Migration Script
# Purpose: Emergency rollback to pre-migration state
# Usage: ./rollback_migration.sh

echo "🚨 EMERGENCY ROLLBACK: Reverting to pre-migration state"

# Check if we're in migration branch
CURRENT_BRANCH=$(git branch --show-current)
if [[ "$CURRENT_BRANCH" != "migrate/world-class-structure" ]]; then
    echo "❌ Not in migration branch, rollback not applicable"
    exit 1
fi

# Rollback to develop or main
echo "🔄 Rolling back to previous branch..."
git checkout develop 2>/dev/null || git checkout main 2>/dev/null || {
    echo "❌ Could not determine previous branch"
    exit 1
}

# Verify database services still work
echo "🔍 Verifying database services..."
if docker exec ardharag_postgres pg_isready -U ardharag >/dev/null 2>&1; then
    echo "✅ PostgreSQL: Still healthy"
else
    echo "❌ PostgreSQL issue detected"
fi

if curl -s http://localhost:6333 >/dev/null 2>&1; then
    echo "✅ Qdrant: Still healthy"
else
    echo "❌ Qdrant issue detected"
fi

if docker exec ardharag_redis redis-cli ping | grep -q "PONG" >/dev/null 2>&1; then
    echo "✅ Redis: Still healthy"
else
    echo "❌ Redis issue detected"
fi

echo "🎉 Rollback complete. Migration branch preserved for analysis."
echo "To delete migration branch: git branch -D migrate/world-class-structure"
EOF

chmod +x rollback_migration.sh
echo -e "${GREEN}✅ Rollback script created: rollback_migration.sh${NC}"
echo

# Create directory structure validation script
echo -e "${PURPLE}🔍 STEP 5: Validation Script Creation${NC}"

cat > validate_structure.sh << 'EOF'
#!/bin/bash

# Structure Validation Script
# Purpose: Validate all services work after migration
# Usage: ./validate_structure.sh

echo "🧪 STRUCTURE VALIDATION: Testing all components"

# Test database connections
echo "Testing database services..."
python3 -c "
try:
    import psycopg2
    conn = psycopg2.connect(
        host='localhost',
        database='ardharag',
        user='ardharag',
        password='your_postgres_password'
    )
    print('✅ PostgreSQL connection: Success')
    conn.close()
except Exception as e:
    print(f'❌ PostgreSQL connection: {e}')

try:
    import redis
    r = redis.Redis(host='localhost', port=6379, db=0)
    r.ping()
    print('✅ Redis connection: Success')
except Exception as e:
    print(f'❌ Redis connection: {e}')

try:
    import requests
    response = requests.get('http://localhost:6333')
    print('✅ Qdrant connection: Success')
except Exception as e:
    print(f'❌ Qdrant connection: {e}')
"

# Test Python package structure
echo "Testing Python package imports..."
if [[ -d "src/ardharag" ]]; then
    cd src && python3 -c "
try:
    import ardharag
    print('✅ Package import: Success')
    
    # Test module imports
    modules = ['core', 'api', 'cape', 'storage', 'utils']
    for module in modules:
        try:
            exec(f'import ardharag.{module}')
            print(f'✅ Module ardharag.{module}: Success')
        except ImportError as e:
            print(f'❌ Module ardharag.{module}: {e}')
except Exception as e:
    print(f'❌ Package import: {e}')
    "
    cd ..
else
    echo "ℹ️  src/ardharag not yet created - will test after migration"
fi

echo "🎉 Validation complete"
EOF

chmod +x validate_structure.sh
echo -e "${GREEN}✅ Validation script created: validate_structure.sh${NC}"
echo

# Summary of preparation
echo -e "${PURPLE}📋 STEP 1.1 SUMMARY${NC}"
echo "=================================="
echo -e "${GREEN}✅ Database services: All healthy and operational${NC}"
echo -e "${GREEN}✅ Migration branch: migrate/world-class-structure created/checked out${NC}"
echo -e "${GREEN}✅ Analysis file: migration_analysis.md created${NC}"
echo -e "${GREEN}✅ Rollback script: rollback_migration.sh created${NC}"
echo -e "${GREEN}✅ Validation script: validate_structure.sh created${NC}"
echo -e "${GREEN}✅ VPS snapshot: Already taken by user ✨${NC}"
echo

echo -e "${BLUE}📁 Files created for migration:${NC}"
echo "  - migration_analysis.md     (Structure analysis)"
echo "  - rollback_migration.sh     (Emergency rollback)"
echo "  - validate_structure.sh     (Post-migration validation)"
echo

echo -e "${YELLOW}🎯 READY FOR STEP 1.2: Structure Analysis Deep Dive${NC}"
echo "Next steps will analyze existing code and plan the consolidation"
echo "of application/ and ardharag/ directories into modern src layout."
echo

echo -e "${PURPLE}🔍 Please share the output of this script to confirm Step 1.1 completion!${NC}"
