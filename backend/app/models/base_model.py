from datetime import datetime

from sqlalchemy import Column, DateTime


class TimestampMixin:
    """
    Adds created_at and updated_at fields
    to any model that inherits this mixin.
    """

    created_at = Column(
        DateTime,
        default=datetime.utcnow,
        nullable=False,
    )

    updated_at = Column(
        DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow,
        nullable=False,
    )
