# ArdhaRAG Structure Comparison & Migration Plan

## Executive Summary
The current repository has a dual directory structure that needs consolidation:
- `application/` - Contains module directories
- `ardharag/` - Contains Python package structure with __init__.py files

## Detailed Analysis

### Directory Structure Comparison

#### application/ Directory


#### ardharag/ Directory
```
ardharag/
ardharag
ardharag/agents
ardharag/api
ardharag/cape
ardharag/core
ardharag/ingestion
ardharag/knowledge
ardharag/llm
ardharag/storage
ardharag/ui
ardharag/utils

Python files:
ardharag/api/__init__.py
ardharag/core/__init__.py
ardharag/__init__.py
ardharag/ui/__init__.py
ardharag/utils/__init__.py
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
