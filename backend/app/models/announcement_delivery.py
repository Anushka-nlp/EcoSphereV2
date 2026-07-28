from sqlalchemy import Column, ForeignKey, Integer
from sqlalchemy.orm import relationship

from app.db.database import Base


class AnnouncementDelivery(Base):
    """
    Junction table between announcements and delivery types.
    """

    __tablename__ = "announcement_deliveries"

    # -------------------------
    # Primary Key
    # -------------------------

    id = Column(
        Integer,
        primary_key=True,
        index=True,
    )

    # -------------------------
    # Foreign Keys
    # -------------------------

    announcement_id = Column(
        Integer,
        ForeignKey("announcements.id"),
        nullable=False,
    )

    delivery_type_id = Column(
        Integer,
        ForeignKey("delivery_types.id"),
        nullable=False,
    )

    # -------------------------
    # Relationships
    # -------------------------

    announcement = relationship(
        "Announcement",
        back_populates="deliveries",
    )

    delivery_type = relationship(
        "DeliveryType",
        back_populates="announcements",
    )
