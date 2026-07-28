from typing import Optional
from pydantic import BaseModel


class LoginRequest(BaseModel):
    identifier: str
    password: str
    employee_id: Optional[str] = None
    role: Optional[str] = None


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    role: str
    user_id: int
    full_name: str
    official_email: Optional[str] = None
    usn: Optional[str] = None
    employee_id: Optional[str] = None
    department_id: Optional[int] = None
