-- Initialize Apache AGE extension
CREATE EXTENSION IF NOT EXISTS age;
LOAD 'age';

-- Set search path to include ag_catalog
ALTER DATABASE ardharag_db SET search_path = ag_catalog, "$user", public;

-- Create default graph for ArdhaRAG knowledge management
SELECT ag_catalog.create_graph('ardharag_knowledge');

-- Create basic tables for ArdhaRAG
CREATE TABLE IF NOT EXISTS documents (
    id SERIAL PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    content TEXT,
    file_type VARCHAR(50),
    file_size BIGINT,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    checksum VARCHAR(64) UNIQUE,
    metadata JSONB
);

CREATE TABLE IF NOT EXISTS document_chunks (
    id SERIAL PRIMARY KEY,
    document_id INTEGER REFERENCES documents(id) ON DELETE CASCADE,
    chunk_text TEXT NOT NULL,
    chunk_index INTEGER NOT NULL,
    token_count INTEGER,
    embedding_vector vector(1536),  -- OpenAI ada-002 dimensions
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS knowledge_entities (
    id SERIAL PRIMARY KEY,
    entity_name VARCHAR(255) NOT NULL,
    entity_type VARCHAR(100),
    description TEXT,
    confidence_score FLOAT,
    document_id INTEGER REFERENCES documents(id),
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_documents_checksum ON documents(checksum);
CREATE INDEX IF NOT EXISTS idx_documents_type ON documents(file_type);
CREATE INDEX IF NOT EXISTS idx_chunks_document ON document_chunks(document_id);
CREATE INDEX IF NOT EXISTS idx_entities_name ON knowledge_entities(entity_name);
CREATE INDEX IF NOT EXISTS idx_entities_type ON knowledge_entities(entity_type);

-- AGE-specific graph queries examples for future reference
-- SELECT * FROM ag_catalog.ag_label;
-- MATCH (n) RETURN n LIMIT 10;

-- Success message
DO $$ 
BEGIN 
    RAISE NOTICE 'Apache AGE initialized successfully for ArdhaRAG';
    RAISE NOTICE 'Graph "ardharag_knowledge" created';
    RAISE NOTICE 'Base tables created with proper indexing';
END $$;
