"""Main route handlers."""

import logging

from flask import flash, jsonify, render_template, request

from app.services.quote_service import QuoteService

logger = logging.getLogger(__name__)


def register_routes(app):

    @app.route("/")
    def index():
        quote = QuoteService.get_random_quote()
        if quote is None:
            flash("Database connection failed", "error")
        return render_template("index.html", quote=quote)

    @app.route("/quotes")
    def quotes():
        quotes = QuoteService.get_all_quotes()
        if not quotes:
            flash("Database connection failed", "error")
        return render_template("quotes.html", quotes=quotes)

    @app.route("/inject")
    def inject_quotes():
        result = QuoteService.inject_additional_quotes()

        if result["success"]:
            return jsonify(
                {
                    "message": "Quotes injected successfully!",
                    "quotes_added": result["quotes_added"],
                    "total_quotes": result["total_quotes"],
                }
            )
        else:
            return jsonify({"error": result["error"]}), 500

    @app.route("/add-quote", methods=["POST"])
    def add_quote():
        quote_text = request.form.get("quoteText", "").strip()
        author = request.form.get("author", "").strip()
        category = request.form.get("category", "").strip()

        if not quote_text or not author:
            return jsonify({"error": "Quote text and author are required"}), 400

        success = QuoteService.add_quote(quote_text, author, category if category else None)

        if success:
            return jsonify(
                {
                    "message": "Quote added successfully!",
                    "quote": {"text": quote_text, "author": author, "category": category},
                }
            )
        else:
            return jsonify({"error": "Error adding quote"}), 500

    @app.route("/stats")
    def get_stats():
        stats = QuoteService.get_stats()

        if stats:
            return jsonify(stats)
        else:
            return jsonify({"error": "Error getting stats"}), 500

    @app.route("/inject-page")
    def inject_page():
        return render_template("inject.html")

    @app.route("/health")
    def health_check():
        if QuoteService.check_database_health():
            return jsonify({"status": "healthy", "database": "connected"})
        else:
            return jsonify({"status": "unhealthy", "database": "disconnected"}), 500
