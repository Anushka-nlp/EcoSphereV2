from sqlalchemy.orm import Session

from app.models.delivery_type import DeliveryType

DEFAULT_DELIVERY_TYPES = [
    "Speaker",
    "Push Notification",
    "Popup",
    "In-App Alert",
    "Announcement Feed",
]


def seed_delivery_types(db: Session) -> None:
    """
    Seed default announcement delivery types.

    Safe to run multiple times.
    """

    for delivery_name in DEFAULT_DELIVERY_TYPES:
        delivery_type = (
            db.query(DeliveryType).filter(DeliveryType.name == delivery_name).first()
        )

        if delivery_type is None:
            db.add(
                DeliveryType(
                    name=delivery_name,
                )
            )

    db.commit()
