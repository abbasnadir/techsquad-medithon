import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    SECRET_KEY = os.getenv("SECRET_KEY", "default-secret-key")
    
    db_uri = os.getenv("DATABASE_URL", "sqlite:///app.db")
    if db_uri.startswith("postgres://"):
        db_uri = db_uri.replace("postgres://", "postgresql://", 1)
        
    SQLALCHEMY_DATABASE_URI = db_uri
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JWT_SECRET = os.getenv("JWT_SECRET", "default-jwt-secret")
    JWT_EXPIRATION_HOURS = int(os.getenv("JWT_EXPIRATION_HOURS", 24))
    JWKS_URL = os.getenv("JWKS_URL")
    AUTH_URL = os.getenv("AUTH_URL")
