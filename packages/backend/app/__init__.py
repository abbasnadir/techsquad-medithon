from flask import Flask
from app.config import Config
from app.database import db
from app.middlewares.error_handler import register_error_handlers
from app.routes import register_routes

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    # Initialize extensions
    db.init_app(app)

    # Register handlers and routes
    register_error_handlers(app)
    register_routes(app)

    # Create tables (In production, use Flask-Migrate or Alembic)
    with app.app_context():
        db.create_all()

    return app
