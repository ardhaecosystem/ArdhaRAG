# Multi-stage production Dockerfile for ArdhaRAG
# Optimized for 8GB RAM constraints with security hardening

# Stage 1: Builder
FROM python:3.11-slim as builder

# Set build arguments
ARG POETRY_VERSION=1.7.1

# Install system dependencies for building
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install poetry==$POETRY_VERSION

# Set poetry environment variables
ENV POETRY_NO_INTERACTION=1 \
    POETRY_VENV_IN_PROJECT=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

# Copy poetry files
WORKDIR /app
COPY pyproject.toml poetry.lock ./

# Install dependencies
RUN poetry install --only=main --no-root && rm -rf $POETRY_CACHE_DIR

# Stage 2: Runtime
FROM python:3.11-slim as runtime

# Create non-root user for security
RUN groupadd -r ardharag && useradd -r -g ardharag ardharag

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    curl \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Set working directory
WORKDIR /app

# Copy virtual environment from builder stage
COPY --from=builder --chown=ardharag:ardharag /app/.venv /app/.venv

# Add venv to path
ENV PATH="/app/.venv/bin:$PATH"

# Copy application code
COPY --chown=ardharag:ardharag . .

# Install the application
RUN /app/.venv/bin/pip install -e .

# Create data directories
RUN mkdir -p /app/data/{documents,models,cache,logs,backups} \
    && chown -R ardharag:ardharag /app/data

# Switch to non-root user
USER ardharag

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Expose port
EXPOSE 8000

# Default command
CMD ["uvicorn", "ardharag.api.main:app", "--host", "0.0.0.0", "--port", "8000"]
