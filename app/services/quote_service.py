"""Quote service for business logic."""

import logging
from app.utils.database import get_db_connection
from app.models.quote import Quote

logger = logging.getLogger(__name__)


class QuoteService:
    
    @staticmethod
    def get_random_quote():
        """Get a random quote."""
        import os
        use_azure_sql = os.getenv('USE_AZURE_SQL', 'true').lower() == 'true'
        db_type = "Azure SQL Database" if use_azure_sql else "SQLite"
        logger.info(f"Fetching random quote from {db_type}")
        
        conn = get_db_connection()
        if not conn:
            return None
        
        try:
            cursor = conn.cursor()
            quote = Quote.get_random_quote(cursor)
            if quote:
                logger.info(f"Successfully fetched random quote from {db_type}")
            else:
                logger.warning(f"No quotes found in {db_type}")
            return quote
        except Exception as e:
            logger.error(f"Error fetching random quote from {db_type}: {str(e)}")
            return None
        finally:
            conn.close()
    
    @staticmethod
    def get_all_quotes():
        """Get all quotes."""
        import os
        use_azure_sql = os.getenv('USE_AZURE_SQL', 'true').lower() == 'true'
        db_type = "Azure SQL Database" if use_azure_sql else "SQLite"
        logger.info(f"Fetching all quotes from {db_type}")
        
        conn = get_db_connection()
        if not conn:
            return []
        
        try:
            cursor = conn.cursor()
            quotes = Quote.get_all_quotes(cursor)
            logger.info(f"Successfully fetched {len(quotes)} quotes from {db_type}")
            return quotes
        except Exception as e:
            logger.error(f"Error fetching quotes from {db_type}: {str(e)}")
            return []
        finally:
            conn.close()
    
    @staticmethod
    def add_quote(quote_text, author, category=None):
        """Add a new quote."""
        conn = get_db_connection()
        if not conn:
            return False
        
        try:
            cursor = conn.cursor()
            Quote.add_quote(cursor, quote_text, author, category)
            conn.commit()
            return True
        except Exception as e:
            logger.error(f"Error adding quote: {str(e)}")
            return False
        finally:
            conn.close()
    
    @staticmethod
    def inject_additional_quotes():
        """Inject additional quotes into the database."""
        conn = get_db_connection()
        if not conn:
            return {'success': False, 'error': 'Database connection failed'}
        
        try:
            cursor = conn.cursor()
            Quote.insert_additional_quotes(cursor)
            conn.commit()
            
            # Get total count
            stats = Quote.get_stats(cursor)
            
            return {
                'success': True,
                'quotes_added': len(Quote.ADDITIONAL_QUOTES),
                'total_quotes': stats['total_quotes']
            }
        except Exception as e:
            logger.error(f"Error injecting quotes: {str(e)}")
            return {'success': False, 'error': 'Error injecting quotes'}
        finally:
            conn.close()
    
    @staticmethod
    def get_stats():
        """Get database statistics."""
        import os
        use_azure_sql = os.getenv('USE_AZURE_SQL', 'true').lower() == 'true'
        db_type = "Azure SQL Database" if use_azure_sql else "SQLite"
        logger.info(f"Fetching statistics from {db_type}")
        
        conn = get_db_connection()
        if not conn:
            return None
        
        try:
            cursor = conn.cursor()
            stats = Quote.get_stats(cursor)
            logger.info(f"Successfully fetched stats from {db_type}: {stats}")
            return stats
        except Exception as e:
            logger.error(f"Error getting stats from {db_type}: {str(e)}")
            return None
        finally:
            conn.close()
    
    @staticmethod
    def check_database_health():
        """Check if database is accessible."""
        conn = get_db_connection()
        if conn:
            conn.close()
            return True
        return False
