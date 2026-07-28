from pydantic import BaseModel
from typing import Optional

class UserResponse(BaseModel):
    id: int
    full_name: str
    official_email: Optional[str] = None
    usn: Optional[str] = None
    employee_id: Optional[str] = None
    role: Optional[str] = None
    department_id: Optional[int] = None
    is_active: bool = True

    class Config:
        from_attributes = True

class UserUpdateRole(BaseModel):
    role_id: Optional[int] = None
    department_id: Optional[int] = None
    is_active: Optional[bool] = None
