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
