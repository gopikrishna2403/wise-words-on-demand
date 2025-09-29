"""Database utilities and connection management."""

import sqlite3
import os
import logging
from config import Config

logger = logging.getLogger(__name__)


def get_db_connection():
    """Create and return a database connection"""
    try:
        use_azure_sql = os.getenv('USE_AZURE_SQL', 'true').lower() == 'true'
        
        if use_azure_sql:
            logger.info("Connecting to Azure SQL Database")
            import pyodbc
            connection_string = (
                f"DRIVER={{ODBC Driver 18 for SQL Server}};"
                f"SERVER={Config.AZURE_SQL_SERVER};"
                f"DATABASE={Config.AZURE_SQL_DATABASE};"
                f"UID={Config.AZURE_SQL_USERNAME};"
                f"PWD={Config.AZURE_SQL_PASSWORD};"
                f"Encrypt=yes;"
                f"TrustServerCertificate=no;"
                f"Connection Timeout={Config.DB_TIMEOUT};"
            )
            conn = pyodbc.connect(connection_string)
            logger.info("Successfully connected to Azure SQL Database")
            return conn
        else:
            db_path = os.getenv('DATABASE_PATH', 'quotes.db')
            logger.info(f"Connecting to SQLite database: {db_path}")
            
            db_dir = os.path.dirname(db_path)
            if db_dir and not os.path.exists(db_dir):
                os.makedirs(db_dir, exist_ok=True)
            
            conn = sqlite3.connect(db_path)
            conn.row_factory = sqlite3.Row
            logger.info("Successfully connected to SQLite database")
            return conn
            
    except Exception as e:
        logger.error(f"Database connection error: {str(e)}")
        return None


def init_database():
    """Initialize the database with quotes table and sample data"""
    conn = get_db_connection()
    if not conn:
        return False
    
    try:
        cursor = conn.cursor()
        use_azure_sql = os.getenv('USE_AZURE_SQL', 'true').lower() == 'true'
        db_type = "Azure SQL Database" if use_azure_sql else "SQLite"
        logger.info(f"Initializing {db_type} with quotes table and sample data")
        
        if use_azure_sql:
            logger.info("Creating quotes table in Azure SQL Database")
            cursor.execute("""
                IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='quotes' AND xtype='U')
                CREATE TABLE quotes (
                    id INT IDENTITY(1,1) PRIMARY KEY,
                    quote_text NVARCHAR(MAX) NOT NULL,
                    author NVARCHAR(255) NOT NULL,
                    category NVARCHAR(100),
                    created_at DATETIME2 DEFAULT GETDATE()
                )
            """)
            
            cursor.execute("SELECT COUNT(*) FROM quotes")
            count = cursor.fetchone()[0]
            
            if count == 0:
                logger.info("Inserting sample quotes into Azure SQL Database")
                from app.models.quote import Quote
                Quote.insert_sample_data(cursor)
            else:
                logger.info(f"Azure SQL Database already contains {count} quotes")
        else:
            logger.info("Creating quotes table in SQLite database")
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS quotes (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    quote_text TEXT NOT NULL,
                    author TEXT NOT NULL,
                    category TEXT,
                    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
                )
            """)
            
            cursor.execute("SELECT COUNT(*) FROM quotes")
            count = cursor.fetchone()[0]
            
            if count == 0:
                logger.info("Inserting sample quotes into SQLite database")
                from app.models.quote import Quote
                Quote.insert_sample_data(cursor)
            else:
                logger.info(f"SQLite database already contains {count} quotes")
        
        conn.commit()
        logger.info(f"Database initialization completed successfully for {db_type}")
        return True
    except Exception as e:
        logger.error(f"Database initialization error: {str(e)}")
        return False
    finally:
        conn.close()
