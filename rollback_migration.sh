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
