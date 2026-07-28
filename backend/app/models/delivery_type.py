from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship

from app.db.database import Base
from app.models.base_model import TimestampMixin


class DeliveryType(TimestampMixin, Base):
    """
    Stores all announcement delivery methods.

    Examples:
    - Speaker
    - Push Notification
    - Popup
    - In-App Alert
    - Announcement Feed
    """

    __tablename__ = "delivery_types"

    # -------------------------
    # Primary Key
    # -------------------------

    id = Column(
        Integer,
        primary_key=True,
        index=True,
    )

    # -------------------------
    # Delivery Type
    # -------------------------

    name = Column(
        String(100),
        unique=True,
        nullable=False,
    )

    # -------------------------
    # Relationships
    # -------------------------

    announcements = relationship(
        "AnnouncementDelivery",
        back_populates="delivery_type",
    )
