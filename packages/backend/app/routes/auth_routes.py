from flask import Blueprint, request, jsonify
from pydantic import ValidationError
import bcrypt
from app.database import db
from app.models.user import User
from app.schemas.auth_schema import UserRegisterSchema, UserLoginSchema
from app.utils.jwt_util import generate_token
from app.middlewares.auth_middleware import require_auth

auth_bp = Blueprint('auth', __name__, url_prefix='/api/auth')

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    
    # Validate with Pydantic
    schema = UserRegisterSchema(**data)
    
    if User.query.filter_by(email=schema.email).first():
        return jsonify({"error": "Conflict", "message": "Email already exists"}), 409
        
    if User.query.filter_by(username=schema.username).first():
        return jsonify({"error": "Conflict", "message": "Username already exists"}), 409

    hashed = bcrypt.hashpw(schema.password.encode('utf-8'), bcrypt.gensalt())
    
    new_user = User(
        username=schema.username,
        email=schema.email,
        password_hash=hashed.decode('utf-8')
    )
    
    db.session.add(new_user)
    db.session.commit()
    
    return jsonify({
        "message": "User registered successfully",
        "user": new_user.to_dict()
    }), 201

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    
    # Validate with Pydantic
    schema = UserLoginSchema(**data)
    
    user = User.query.filter_by(email=schema.email).first()
    
    if not user or not bcrypt.checkpw(schema.password.encode('utf-8'), user.password_hash.encode('utf-8')):
        return jsonify({"error": "Unauthorized", "message": "Invalid email or password"}), 401
        
    token = generate_token(user.id)
    
    return jsonify({
        "message": "Login successful",
        "token": token,
        "user": user.to_dict()
    }), 200

@auth_bp.route('/me', methods=['GET'])
@require_auth
def me():
    return jsonify({
        "user": request.user.to_dict()
    }), 200
