"""
Simple test suite for Wise Words on Demand application
"""

import os
import sqlite3
import tempfile
import unittest

from app.utils.database import get_db_connection
from app_factory import create_app


class TestWiseWordsApp(unittest.TestCase):
    """Test cases for the Wise Words on Demand application"""

    def setUp(self):
        """Set up test fixtures before each test method"""
        # Create a temporary database for testing
        self.test_db = tempfile.NamedTemporaryFile(suffix=".db", delete=False)
        self.test_db.close()

        # Set environment variable for test database
        os.environ["DATABASE_PATH"] = self.test_db.name
        os.environ["USE_AZURE_SQL"] = "false"

        # Create app for testing
        self.app = create_app()
        self.app.config["TESTING"] = True
        self.client = self.app.test_client()

        # Initialize test database
        self.init_test_database()

    def tearDown(self):
        """Clean up after each test method"""
        # Remove temporary database
        if os.path.exists(self.test_db.name):
            os.unlink(self.test_db.name)

    def init_test_database(self):
        """Initialize test database with sample data"""
        conn = sqlite3.connect(self.test_db.name)
        conn.row_factory = sqlite3.Row

        # Create quotes table
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS quotes (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                quote_text TEXT NOT NULL,
                author TEXT NOT NULL,
                category TEXT,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        """
        )

        # Insert test data
        test_quotes = [
            ("Test quote 1", "Test Author 1", "Test Category"),
            ("Test quote 2", "Test Author 2", "Test Category"),
            ("Test quote 3", "Test Author 3", None),
        ]

        for quote_text, author, category in test_quotes:
            conn.execute(
                "INSERT INTO quotes (quote_text, author, category) VALUES (?, ?, ?)",
                (quote_text, author, category),
            )

        conn.commit()
        conn.close()

    def test_health_endpoint(self):
        """Test the health check endpoint"""
        response = self.client.get("/health")
        self.assertEqual(response.status_code, 200)

        data = response.get_json()
        self.assertIn("status", data)
        self.assertEqual(data["status"], "healthy")

    def test_home_endpoint(self):
        """Test the home page endpoint"""
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)
        self.assertIn(b"Wise Words on Demand", response.data)

    def test_quotes_endpoint(self):
        """Test the quotes listing endpoint"""
        response = self.client.get("/quotes")
        self.assertEqual(response.status_code, 200)
        self.assertIn(b"All Quotes", response.data)

    def test_stats_endpoint(self):
        """Test the statistics endpoint"""
        response = self.client.get("/stats")
        self.assertEqual(response.status_code, 200)

        data = response.get_json()
        self.assertIn("total_quotes", data)
        self.assertIn("total_authors", data)
        self.assertGreaterEqual(data["total_quotes"], 0)
        self.assertGreaterEqual(data["total_authors"], 0)

    def test_inject_page_endpoint(self):
        """Test the inject page endpoint"""
        response = self.client.get("/inject-page")
        self.assertEqual(response.status_code, 200)
        self.assertIn(b"Inject Quotes", response.data)

    def test_add_quote_endpoint(self):
        """Test adding a new quote via POST"""
        response = self.client.post(
            "/add-quote",
            data={
                "quoteText": "Test quote from test",
                "author": "Test Author",
                "category": "Test Category",
            },
        )
        self.assertEqual(response.status_code, 200)

        data = response.get_json()
        self.assertIn("message", data)
        self.assertIn("Quote added successfully", data["message"])

    def test_add_quote_validation(self):
        """Test quote validation"""
        # Test missing quote text
        response = self.client.post(
            "/add-quote", data={"author": "Test Author", "category": "Test Category"}
        )
        self.assertEqual(response.status_code, 400)

        # Test missing author
        response = self.client.post(
            "/add-quote", data={"quoteText": "Test quote", "category": "Test Category"}
        )
        self.assertEqual(response.status_code, 400)

    def test_database_connection(self):
        """Test database connection functionality"""
        # This test would need to be adapted based on your actual database setup
        # For now, we'll just test that the function exists and can be called
        try:
            conn = get_db_connection()
            if conn:
                conn.close()
            self.assertTrue(True)  # If we get here, the function works
        except Exception as e:
            self.fail(f"Database connection failed: {e}")


if __name__ == "__main__":
    # Run the tests
    unittest.main(verbosity=2)
