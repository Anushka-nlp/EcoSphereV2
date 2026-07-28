from sqlalchemy import Boolean, Column, Integer, String
from sqlalchemy.orm import relationship

from app.db.database import Base
from app.models.base_model import TimestampMixin


class Department(TimestampMixin, Base):
    """
    Stores all departments in the college.

    Examples:
    - CSE
    - ISE
    - AIML
    - ECE
    """

    __tablename__ = "departments"

    # -------------------------
    # Primary Key
    # -------------------------

    id = Column(Integer, primary_key=True, index=True)

    # -------------------------
    # Basic Information
    # -------------------------

    name = Column(
        String(100),
        unique=True,
        nullable=False,
    )

    code = Column(
        String(20),
        unique=True,
        nullable=False,
    )

    is_active = Column(
        Boolean,
        default=False,
        nullable=False,
    )

    # -------------------------
    # Relationships
    # -------------------------

    users = relationship(
        "User",
        back_populates="department",
    )
