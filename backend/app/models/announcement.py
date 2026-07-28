from sqlalchemy import (
    Column,
    DateTime,
    Enum,
    ForeignKey,
    Integer,
    String,
    Text,
)
from sqlalchemy.orm import relationship

from app.core.enums.announcement import (
    AnnouncementPriority,
    AnnouncementStatus,
    EmergencyLevel,
)
from app.db.database import Base
from app.models.base_model import TimestampMixin


class Announcement(TimestampMixin, Base):
    """
    Stores announcements created by authorized users.
    """

    __tablename__ = "announcements"

    # -------------------------
    # Primary Key
    # -------------------------

    id = Column(
        Integer,
        primary_key=True,
        index=True,
    )

    # -------------------------
    # Announcement Details
    # -------------------------

    title = Column(
        String(255),
        nullable=False,
    )

    description = Column(
        Text,
        nullable=False,
    )

    status = Column(
        Enum(AnnouncementStatus),
        default=AnnouncementStatus.DRAFT,
        nullable=False,
    )

    priority = Column(
        Enum(AnnouncementPriority),
        default=AnnouncementPriority.NORMAL,
        nullable=False,
    )

    emergency_level = Column(
        Enum(EmergencyLevel),
        default=EmergencyLevel.NORMAL,
        nullable=False,
    )

    scheduled_at = Column(
        DateTime,
        nullable=True,
    )

    # -------------------------
    # Foreign Keys
    # -------------------------

    created_by = Column(
        Integer,
        ForeignKey("users.id"),
        nullable=False,
    )

    category_id = Column(
        Integer,
        ForeignKey("announcement_categories.id"),
        nullable=False,
    )

    # -------------------------
    # Relationships
    # -------------------------

    creator = relationship(
        "User",
        back_populates="announcements",
    )

    category = relationship(
        "AnnouncementCategory",
        back_populates="announcements",
    )

    approvals = relationship(
        "AnnouncementApproval",
        back_populates="announcement",
        cascade="all, delete-orphan",
    )

    deliveries = relationship(
        "AnnouncementDelivery",
        back_populates="announcement",
        cascade="all, delete-orphan",
    )

    notifications = relationship(
        "Notification",
        back_populates="announcement",
        cascade="all, delete-orphan",
    )

    speaker_queue = relationship(
        "SpeakerQueue",
        back_populates="announcement",
        uselist=False,
        cascade="all, delete-orphan",
    )
