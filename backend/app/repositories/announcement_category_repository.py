from sqlalchemy.orm import Session

from app.models.announcement_category import AnnouncementCategory


def get_category_by_id(
    db: Session,
    category_id: int,
) -> AnnouncementCategory | None:
    return (
        db.query(AnnouncementCategory)
        .filter(AnnouncementCategory.id == category_id)
        .first()
    )


def get_all_categories(
    db: Session,
):
    return db.query(AnnouncementCategory).all()
