from pydantic import BaseModel, Field, EmailStr

class UserRegisterSchema(BaseModel):
    username: str = Field(..., min_length=3, max_length=50)
    email: EmailStr
    password: str = Field(..., min_length=6)
    role: str = Field(..., pattern="^(healthcare_worker|patient)$")

class UserLoginSchema(BaseModel):
    email: EmailStr
    password: str
