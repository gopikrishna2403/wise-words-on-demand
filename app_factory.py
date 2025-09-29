"""Flask application factory."""

from flask import Flask
import logging
from config import Config
from app.utils.database import init_database
from app.routes.main import register_routes

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def create_app():
    app = Flask(__name__)
    app.secret_key = Config.SECRET_KEY
    register_routes(app)
    return app


def initialize_app():
    if init_database():
        logger.info("Database initialized successfully")
        return create_app()
    else:
        logger.error("Failed to initialize database. Please check your connection settings.")
        return None


if __name__ == '__main__':
    app = initialize_app()
    if app:
        logger.info("Starting Flask application...")
        app.run(debug=True, host='0.0.0.0', port=5001)
    else:
        logger.error("Failed to start application due to database initialization error.")
