from sqlalchemy import Column, Integer, String, Text
from sqlalchemy.orm import relationship

from app.db.database import Base
from app.models.base_model import TimestampMixin


class AnnouncementCategory(TimestampMixin, Base):
    """
    Stores announcement categories.

    Examples:
    - Academic
    - Examination
    - Placement
    - Events
    - Emergency
    """

    __tablename__ = "announcement_categories"

    # -------------------------
    # Primary Key
    # -------------------------

    id = Column(
        Integer,
        primary_key=True,
        index=True,
    )

    # -------------------------
    # Category Details
    # -------------------------

    name = Column(
        String(100),
        unique=True,
        nullable=False,
    )

    description = Column(
        Text,
        nullable=True,
    )

    # -------------------------
    # Relationships
    # -------------------------

    announcements = relationship(
        "Announcement",
        back_populates="category",
    )
