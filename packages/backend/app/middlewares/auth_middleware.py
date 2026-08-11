from functools import wraps
from flask import request, jsonify
from app.utils.jwt_util import decode_token
from app.models.user import User

def require_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        auth_header = request.headers.get('Authorization')
        if not auth_header or not auth_header.startswith('Bearer '):
            return jsonify({"error": "Unauthorized", "message": "Missing or invalid token"}), 401
        
        token = auth_header.split(' ')[1]
        user_id = decode_token(token)
        
        if not user_id:
            return jsonify({"error": "Unauthorized", "message": "Expired or invalid token"}), 401
            
        user = User.query.get(user_id)
        if not user:
            return jsonify({"error": "Unauthorized", "message": "User not found"}), 401
            
        request.user = user
        return f(*args, **kwargs)
    return decorated
