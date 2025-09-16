"""
Pytest configuration for ArdhaRAG tests
"""

import pytest
import asyncio
from pathlib import Path

# Test fixtures will be added during development
@pytest.fixture(scope="session")
def event_loop():
    """Create an instance of the default event loop for the test session."""
    loop = asyncio.get_event_loop_policy().new_event_loop()
    yield loop
    loop.close()

@pytest.fixture
def test_data_dir():
    """Path to test data directory."""
    return Path(__file__).parent / "fixtures"
