#!/bin/bash

# Step 1.2: Deep Structure Analysis & Migration Planning
# Purpose: Analyze dual directory structure and plan consolidation
# Location: Run from /opt/ardha-ecosystem/projects/ardharag/

set -euo pipefail

echo "🎯 STEP 1.2: DEEP STRUCTURE ANALYSIS & MIGRATION PLANNING"
echo "========================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Verify we're in the migration branch
CURRENT_BRANCH=$(git branch --show-current)
if [[ "$CURRENT_BRANCH" != "migrate/world-class-structure" ]]; then
    echo -e "${RED}❌ Must be in migrate/world-class-structure branch${NC}"
    echo "Current branch: $CURRENT_BRANCH"
    exit 1
fi

echo -e "${GREEN}✅ Confirmed in migration branch: $CURRENT_BRANCH${NC}"
echo

# Deep analysis of existing structure
echo -e "${PURPLE}🔍 STEP 1: Analyzing Dual Directory Structure${NC}"
echo "=============================================="

# Function to analyze directory contents
analyze_directory() {
    local dir=$1
    local title=$2
    
    echo -e "${CYAN}📁 $title${NC}"
    echo "Path: $dir"
    
    if [[ -d "$dir" ]]; then
        echo "Contents:"
        find "$dir" -type f -name "*.py" | head -10 | while read -r file; do
            echo "  📄 $file"
            # Check if it has actual code (more than just __init__.py)
            if [[ $(wc -l < "$file") -gt 5 ]]; then
                echo "    📏 $(wc -l < "$file") lines (contains code)"
            else
                echo "    📏 $(wc -l < "$file") lines (likely __init__ only)"
            fi
        done
        
        # Count Python files
        local py_count=$(find "$dir" -name "*.py" | wc -l)
        echo "  📊 Total Python files: $py_count"
        echo
    else
        echo "  ❌ Directory does not exist"
        echo
    fi
}

# Analyze both directory structures
analyze_directory "application" "APPLICATION/ Directory Analysis"
analyze_directory "ardharag" "ARDHARAG/ Directory Analysis"

# Create detailed comparison report
echo -e "${PURPLE}🔍 STEP 2: Creating Detailed Comparison Report${NC}"
echo "=============================================="

cat > structure_comparison_report.md << 'EOF'
# ArdhaRAG Structure Comparison & Migration Plan

## Executive Summary
The current repository has a dual directory structure that needs consolidation:
- `application/` - Contains module directories
- `ardharag/` - Contains Python package structure with __init__.py files

## Detailed Analysis

### Directory Structure Comparison

#### application/ Directory
EOF

# Add application directory analysis to report
echo "```" >> structure_comparison_report.md
if [[ -d "application" ]]; then
    echo "application/" >> structure_comparison_report.md
    find application -type d | sort >> structure_comparison_report.md
    echo "" >> structure_comparison_report.md
    echo "Python files:" >> structure_comparison_report.md
    find application -name "*.py" | sort >> structure_comparison_report.md
else
    echo "application/ directory not found" >> structure_comparison_report.md
fi
echo "```" >> structure_comparison_report.md

cat >> structure_comparison_report.md << 'EOF'

#### ardharag/ Directory
```
EOF

# Add ardharag directory analysis to report
if [[ -d "ardharag" ]]; then
    echo "ardharag/" >> structure_comparison_report.md
    find ardharag -type d | sort >> structure_comparison_report.md
    echo "" >> structure_comparison_report.md
    echo "Python files:" >> structure_comparison_report.md
    find ardharag -name "*.py" | sort >> structure_comparison_report.md
else
    echo "ardharag/ directory not found" >> structure_comparison_report.md
fi

cat >> structure_comparison_report.md << 'EOF'
```

## Migration Strategy

### Target Structure (Modern src/ Layout)
```
src/
└── ardharag/
    ├── __init__.py
    ├── core/                    # RAG orchestration
    │   ├── __init__.py
    │   ├── rag.py
    │   ├── config.py
    │   └── exceptions.py
    ├── cape/                    # Context-Aware Prompt Engineering
    │   ├── __init__.py
    │   ├── context_manager.py
    │   ├── prompt_optimizer.py
    │   └── verifier.py
    ├── knowledge/               # Knowledge management
    │   ├── __init__.py
    │   ├── graph_builder.py
    │   └── entity_extractor.py
    ├── storage/                 # Storage backends
    │   ├── __init__.py
    │   ├── base.py
    │   ├── postgresql.py
    │   └── redis_cache.py
    ├── llm/                     # LLM integrations
    │   ├── __init__.py
    │   ├── base.py
    │   ├── openai_client.py
    │   └── anthropic_client.py
    ├── ingestion/              # Document processing
    │   ├── __init__.py
    │   ├── processor.py
    │   └── chunker.py
    ├── agents/                 # Agentic workflows
    │   ├── __init__.py
    │   └── base_agent.py
    ├── api/                    # FastAPI application
    │   ├── __init__.py
    │   ├── main.py
    │   └── routes/
    ├── ui/                     # Web interface
    │   ├── __init__.py
    │   └── components/
    └── utils/                  # Shared utilities
        ├── __init__.py
        ├── logging.py
        └── helpers.py
```

### Migration Steps
1. Create src/ardharag/ structure
2. Intelligently merge content from both directories
3. Preserve all functional code
4. Update import statements
5. Maintain all infrastructure configurations

### Files to Preserve (Critical Infrastructure)
- infrastructure/docker/ (ALL database configurations)
- config/ (All service configurations)
- docs/ and documentation/ (All documentation)
- tests/ (All test structures)
- Makefile, pyproject.toml, README.md, LICENSE

## Implementation Plan
- Phase A: Create target structure
- Phase B: Content migration and consolidation  
- Phase C: Import statement updates
- Phase D: Testing and validation
EOF

echo -e "${GREEN}✅ Detailed comparison report created: structure_comparison_report.md${NC}"
echo

# Analyze specific files for migration planning
echo -e "${PURPLE}🔍 STEP 3: File Content Analysis${NC}"
echo "================================="

# Check for existing Python files with actual content
echo "Scanning for Python files with substantial content..."

find_substantial_files() {
    local dir=$1
    echo -e "${CYAN}📂 Substantial files in $dir:${NC}"
    
    if [[ -d "$dir" ]]; then
        find "$dir" -name "*.py" -exec sh -c 'lines=$(wc -l < "$1"); if [ $lines -gt 10 ]; then echo "  📄 $1 ($lines lines)"; fi' _ {} \;
    else
        echo "  ❌ Directory not found"
    fi
    echo
}

find_substantial_files "application"
find_substantial_files "ardharag"

# Create migration checklist
echo -e "${PURPLE}🔍 STEP 4: Migration Execution Checklist${NC}"
echo "========================================"

cat > migration_checklist.md << 'EOF'
# Migration Execution Checklist

## Pre-Migration Validation
- [ ] Database services healthy (PostgreSQL+AGE, Qdrant, Redis)
- [ ] Git branch: migrate/world-class-structure
- [ ] Backup scripts created and tested
- [ ] Structure analysis completed

## Migration Phase A: Target Structure Creation
- [ ] Create src/ directory
- [ ] Create src/ardharag/ package structure
- [ ] Create all module directories (core, cape, knowledge, etc.)
- [ ] Add appropriate __init__.py files

## Migration Phase B: Content Consolidation
- [ ] Merge application/ content into src/ardharag/
- [ ] Merge ardharag/ content into src/ardharag/
- [ ] Preserve all functional code
- [ ] Handle duplicate files intelligently
- [ ] Maintain code organization and structure

## Migration Phase C: Configuration Updates
- [ ] Update pyproject.toml for src layout
- [ ] Update import statements throughout codebase
- [ ] Update Docker configurations if needed
- [ ] Update test configurations
- [ ] Update documentation references

## Migration Phase D: Testing & Validation
- [ ] Run validation script (validate_structure.sh)
- [ ] Test database connectivity
- [ ] Test Python package imports
- [ ] Verify Docker services still work
- [ ] Run existing tests
- [ ] Update CI/CD configurations

## Post-Migration Tasks
- [ ] Clean up old directories (application/, old ardharag/)
- [ ] Update documentation
- [ ] Commit migration changes
- [ ] Test complete workflow
EOF

echo -e "${GREEN}✅ Migration checklist created: migration_checklist.md${NC}"
echo

# Create the migration execution script
echo -e "${PURPLE}🔍 STEP 5: Migration Execution Script Preparation${NC}"
echo "==============================================="

cat > execute_migration.sh << 'EOF'
#!/bin/bash

# Migration Execution Script
# Purpose: Execute the actual migration from dual structure to src layout
# Usage: ./execute_migration.sh

echo "🚀 EXECUTING MIGRATION: Dual Structure → Modern src/ Layout"
echo "==========================================================="

# Safety check
read -p "⚠️  This will modify your directory structure. Continue? (yes/no): " confirm
if [[ $confirm != "yes" ]]; then
    echo "❌ Migration aborted by user"
    exit 1
fi

echo "🎯 Migration will be executed in the next step..."
echo "📋 Current analysis complete - ready for execution phase"
EOF

chmod +x execute_migration.sh
echo -e "${GREEN}✅ Migration execution script prepared: execute_migration.sh${NC}"
echo

# Summary of analysis
echo -e "${PURPLE}📋 STEP 1.2 SUMMARY${NC}"
echo "===================="
echo -e "${GREEN}✅ Dual structure analyzed: application/ + ardharag/ directories${NC}"
echo -e "${GREEN}✅ Comparison report: structure_comparison_report.md created${NC}"
echo -e "${GREEN}✅ Substantial files identified and catalogued${NC}"
echo -e "${GREEN}✅ Migration checklist: migration_checklist.md created${NC}"
echo -e "${GREEN}✅ Execution script prepared: execute_migration.sh ready${NC}"
echo

echo -e "${BLUE}📁 Analysis files created:${NC}"
echo "  - structure_comparison_report.md  (Detailed analysis)"
echo "  - migration_checklist.md          (Step-by-step checklist)"
echo "  - execute_migration.sh             (Migration execution script)"
echo

echo -e "${YELLOW}🎯 READY FOR STEP 1.3: Migration Execution${NC}"
echo "The analysis phase is complete. Next step will execute the actual"
echo "consolidation of your dual directory structure into modern src/ layout"
echo "while preserving all your excellent infrastructure and configurations."
echo

echo -e "${PURPLE}🔍 Please share this output to confirm Step 1.2 completion!${NC}"
echo -e "${CYAN}💡 Want to review the analysis files? Check:${NC}"
echo "  - cat structure_comparison_report.md"
echo "  - cat migration_checklist.md"
