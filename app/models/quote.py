"""Quote model and data management."""

import os
import logging

logger = logging.getLogger(__name__)


class Quote:
    """Quote model for managing quote data."""
    
    SAMPLE_QUOTES = [
        ("The only way to do great work is to love what you do.", "Steve Jobs", "Motivation"),
        ("Innovation distinguishes between a leader and a follower.", "Steve Jobs", "Innovation"),
        ("Life is what happens to you while you're busy making other plans.", "John Lennon", "Life"),
        ("The future belongs to those who believe in the beauty of their dreams.", "Eleanor Roosevelt", "Dreams"),
        ("It is during our darkest moments that we must focus to see the light.", "Aristotle", "Perseverance"),
        ("The way to get started is to quit talking and begin doing.", "Walt Disney", "Action"),
        ("Don't be afraid to give up the good to go for the great.", "John D. Rockefeller", "Success"),
        ("If you really look closely, most overnight successes took a long time.", "Steve Jobs", "Success"),
        ("The only impossible journey is the one you never begin.", "Tony Robbins", "Motivation"),
        ("Success is not final, failure is not fatal: it is the courage to continue that counts.", "Winston Churchill", "Perseverance"),
        ("The way I see it, if you want the rainbow, you gotta put up with the rain.", "Dolly Parton", "Optimism"),
        ("Believe you can and you're halfway there.", "Theodore Roosevelt", "Belief"),
        ("I have not failed. I've just found 10,000 ways that won't work.", "Thomas Edison", "Persistence"),
        ("The only person you are destined to become is the person you decide to be.", "Ralph Waldo Emerson", "Self-Improvement"),
        ("Go confidently in the direction of your dreams. Live the life you have imagined.", "Henry David Thoreau", "Dreams")
    ]
    
    ADDITIONAL_QUOTES = [
        ("The greatest glory in living lies not in never falling, but in rising every time we fall.", "Nelson Mandela", "Perseverance"),
        ("Your time is limited, don't waste it living someone else's life.", "Steve Jobs", "Life"),
        ("If you want to lift yourself up, lift up someone else.", "Booker T. Washington", "Kindness"),
        ("I have learned over the years that when one's mind is made up, this diminishes fear.", "Rosa Parks", "Courage"),
        ("The way to get started is to quit talking and begin doing.", "Walt Disney", "Action"),
        ("Don't be pushed around by the fears in your mind. Be led by the dreams in your heart.", "Roy T. Bennett", "Dreams"),
        ("It is during our darkest moments that we must focus to see the light.", "Aristotle", "Hope"),
        ("Success is not how high you have climbed, but how you make a positive difference to the world.", "Roy T. Bennett", "Success"),
        ("The only impossible journey is the one you never begin.", "Tony Robbins", "Motivation"),
        ("In the middle of difficulty lies opportunity.", "Albert Einstein", "Opportunity")
    ]
    
    @classmethod
    def insert_sample_data(cls, cursor):
        """Insert sample quotes into the database."""
        for quote_text, author, category in cls.SAMPLE_QUOTES:
            cursor.execute("INSERT INTO quotes (quote_text, author, category) VALUES (?, ?, ?)", 
                         (quote_text, author, category))
    
    @classmethod
    def insert_additional_quotes(cls, cursor):
        """Insert additional quotes into the database."""
        for quote_text, author, category in cls.ADDITIONAL_QUOTES:
            cursor.execute("INSERT INTO quotes (quote_text, author, category) VALUES (?, ?, ?)", 
                         (quote_text, author, category))
    
    @classmethod
    def get_random_quote(cls, cursor):
        """Get a random quote from the database."""
        use_azure_sql = os.getenv('USE_AZURE_SQL', 'true').lower() == 'true'
        
        if use_azure_sql:
            # Azure SQL uses NEWID() for random ordering
            cursor.execute("SELECT TOP 1 id, quote_text, author, category, created_at FROM quotes ORDER BY NEWID()")
        else:
            # SQLite uses RANDOM()
            cursor.execute("SELECT id, quote_text, author, category, created_at FROM quotes ORDER BY RANDOM() LIMIT 1")
        
        quote = cursor.fetchone()
        return tuple(quote) if quote else None
    
    @classmethod
    def get_all_quotes(cls, cursor):
        """Get all quotes from the database."""
        cursor.execute("SELECT id, quote_text, author, category, created_at FROM quotes ORDER BY created_at DESC")
        quotes_raw = cursor.fetchall()
        return [tuple(quote) for quote in quotes_raw]
    
    @classmethod
    def add_quote(cls, cursor, quote_text, author, category=None):
        """Add a new quote to the database."""
        cursor.execute("INSERT INTO quotes (quote_text, author, category) VALUES (?, ?, ?)", 
                     (quote_text, author, category))
    
    @classmethod
    def get_stats(cls, cursor):
        """Get database statistics."""
        # Get total quotes count
        cursor.execute("SELECT COUNT(*) FROM quotes")
        total_quotes = cursor.fetchone()[0]
        
        # Get unique authors count
        cursor.execute("SELECT COUNT(DISTINCT author) FROM quotes")
        total_authors = cursor.fetchone()[0]
        
        return {
            'total_quotes': total_quotes,
            'total_authors': total_authors
        }
