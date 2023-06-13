import os

from dotenv import load_dotenv

load_dotenv()

DATABASE_URL: str = os.getenv("DATABASE_URL", "sqlite:///todo.db")
API_PORT: int = int(os.getenv("API_PORT", 8001))
API_URL: str = os.getenv("API_URL", f"http://localhost:{API_PORT}")
WEB_PORT: int = int(os.getenv("WEB_PORT", 6543))
