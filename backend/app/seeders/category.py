from sqlalchemy.orm import Session

from app.models.announcement_category import AnnouncementCategory

DEFAULT_CATEGORIES = [
    "Academic",
    "Examination",
    "Placement",
    "Events",
    "Workshop",
    "Seminar",
    "Holiday",
    "Sports",
    "Cultural",
    "Club Activities",
    "General",
]


def seed_categories(db: Session) -> None:
    for category_name in DEFAULT_CATEGORIES:
        category = (
            db.query(AnnouncementCategory)
            .filter(AnnouncementCategory.name == category_name)
            .first()
        )

        if category is None:
            db.add(
                AnnouncementCategory(
                    name=category_name,
                )
            )

    db.commit()
