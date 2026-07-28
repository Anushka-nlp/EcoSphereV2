from sqlalchemy import Column, DateTime, ForeignKey, Integer, String
from sqlalchemy.orm import relationship

from app.db.database import Base
from app.models.base_model import TimestampMixin


class SpeakerQueue(TimestampMixin, Base):
    """
    Stores announcements waiting to be played
    through the college speaker system.
    """

    __tablename__ = "speaker_queue"

    # -------------------------
    # Primary Key
    # -------------------------

    id = Column(
        Integer,
        primary_key=True,
        index=True,
    )

    # -------------------------
    # Foreign Key
    # -------------------------

    announcement_id = Column(
        Integer,
        ForeignKey("announcements.id"),
        nullable=False,
        unique=True,
    )

    # -------------------------
    # Queue Details
    # -------------------------

    queue_position = Column(
        Integer,
        nullable=False,
    )

    status = Column(
        String(30),
        nullable=False,
    )

    scheduled_time = Column(
        DateTime,
        nullable=True,
    )

    played_at = Column(
        DateTime,
        nullable=True,
    )

    # -------------------------
    # Relationships
    # -------------------------

    announcement = relationship(
        "Announcement",
        back_populates="speaker_queue",
    )
