import pytest
import os
from importlib import reload
from src import app as app_module

@pytest.fixture
def client(monkeypatch):
    # Set environment variables for testing
    monkeypatch.setenv("APP_NAME", "TestApp")
    monkeypatch.setenv("APP_VERSION", "9.9.9")

    # Reload module to pick up env vars
    reload(app_module)
    test_app = app_module.create_app()
    
    with test_app.test_client() as client:
        yield client

def test_index(client):
    response = client.get("/")
    assert response.status_code == 200
    html = response.get_data(as_text=True)
    assert "<h1>TestApp</h1>" in html
    assert "Version: 9.9.9" in html

def test_healthz(client):
    response = client.get("/healthz")
    assert response.status_code == 200
    assert response.get_json() == {"status": "ok"}

def test_missing_env_vars(monkeypatch):
    # Remove environment variables
    monkeypatch.delenv("APP_NAME", raising=False)
    monkeypatch.delenv("APP_VERSION", raising=False)

    reload(app_module)
    test_app = app_module.create_app()
    client = test_app.test_client()

    response = client.get("/")
    text = response.get_data(as_text=True)
    assert response.status_code == 200
    assert "<h1>MyFlaskApp</h1>" in text  # defaults
    assert "Version: 0.1.0" in text
