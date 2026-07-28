from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship

from app.db.database import Base
from app.models.base_model import TimestampMixin


class Role(TimestampMixin, Base):
    """
    Stores all user roles.

    Examples:
    - Developer
    - College Admin
    - Principal
    - HoD
    - Teacher
    - Student
    """

    __tablename__ = "roles"

    # -------------------------
    # Primary Key
    # -------------------------

    id = Column(Integer, primary_key=True, index=True)

    # -------------------------
    # Basic Information
    # -------------------------

    name = Column(
        String(50),
        unique=True,
        nullable=False,
    )

    # -------------------------
    # Relationships
    # -------------------------

    users = relationship(
        "User",
        back_populates="role",
    )
