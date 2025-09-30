import os

from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()


class Config:
    """Configuration class for the Flask application"""

    # Flask configuration
    SECRET_KEY = os.getenv("FLASK_SECRET_KEY", "dev-secret-key-change-in-production")

    # Azure SQL Database configuration
    AZURE_SQL_SERVER = os.getenv("AZURE_SQL_SERVER", "your-server.database.windows.net")
    AZURE_SQL_DATABASE = os.getenv("AZURE_SQL_DATABASE", "your-database")
    AZURE_SQL_USERNAME = os.getenv("AZURE_SQL_USERNAME", "your-username")
    AZURE_SQL_PASSWORD = os.getenv("AZURE_SQL_PASSWORD", "your-password")

    # Database connection settings
    DB_PORT = 1433
    DB_TIMEOUT = 30
    DB_LOGIN_TIMEOUT = 30
