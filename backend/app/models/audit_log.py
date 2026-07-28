from sqlalchemy import Column, ForeignKey, Integer, String, Text
from sqlalchemy.orm import relationship

from app.db.database import Base
from app.models.base_model import TimestampMixin


class AuditLog(TimestampMixin, Base):
    """
    Stores every important action performed
    by users in the system.

    Used for security, debugging and tracking.
    """

    __tablename__ = "audit_logs"

    # -------------------------
    # Primary Key
    # -------------------------

    id = Column(
        Integer,
        primary_key=True,
        index=True,
    )

    # -------------------------
    # User Reference
    # -------------------------

    user_id = Column(
        Integer,
        ForeignKey("users.id"),
        nullable=False,
    )

    # -------------------------
    # Audit Information
    # -------------------------

    action = Column(
        String(100),
        nullable=False,
    )

    entity = Column(
        String(100),
        nullable=False,
    )

    entity_id = Column(
        Integer,
        nullable=False,
    )

    description = Column(
        Text,
        nullable=True,
    )

    # -------------------------
    # Relationships
    # -------------------------

    user = relationship(
        "User",
        back_populates="audit_logs",
    )
