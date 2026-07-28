from typing import List, Optional
from sqlalchemy.orm import Session
from app.models.user import User

class UserManagementService:
    @staticmethod
    def list_users(db: Session, department_id: Optional[int] = None) -> List[User]:
        query = db.query(User)
        if department_id:
            query = query.filter(User.department_id == department_id)
        return query.order_by(User.id).all()

    @staticmethod
    def get_user_by_id(db: Session, user_id: int) -> Optional[User]:
        return db.query(User).filter(User.id == user_id).first()

    @staticmethod
    def update_user(db: Session, user_id: int, role_id: Optional[int] = None, department_id: Optional[int] = None, is_active: Optional[bool] = None) -> Optional[User]:
        user = db.query(User).filter(User.id == user_id).first()
        if not user:
            return None
        if role_id is not None:
            user.role_id = role_id
        if department_id is not None:
            user.department_id = department_id
        if is_active is not None:
            user.is_active = is_active
        db.commit()
        db.refresh(user)
        return user
