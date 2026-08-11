from flask import jsonify
from pydantic import ValidationError
from werkzeug.exceptions import HTTPException

def register_error_handlers(app):
    @app.errorhandler(ValidationError)
    def handle_pydantic_validation_error(e):
        return jsonify({
            "error": "Validation Error",
            "details": e.errors()
        }), 400

    @app.errorhandler(HTTPException)
    def handle_http_exception(e):
        return jsonify({
            "error": e.name,
            "message": e.description
        }), e.code

    @app.errorhandler(Exception)
    def handle_generic_exception(e):
        # In a real app, log the exception
        print(f"Unhandled Exception: {e}")
        return jsonify({
            "error": "Internal Server Error",
            "message": "An unexpected error occurred."
        }), 500
