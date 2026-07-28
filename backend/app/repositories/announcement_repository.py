from sqlalchemy.orm import Session

from app.models.announcement import Announcement
from app.schemas.announcement import AnnouncementUpdate
from app.core.enums.announcement import AnnouncementStatus


def create_announcement(
    db: Session,
    announcement: Announcement,
) -> Announcement:
    db.add(announcement)
    db.commit()
    db.refresh(announcement)
    return announcement


def get_announcement_by_id(
    db: Session,
    announcement_id: int,
) -> Announcement | None:
    return db.query(Announcement).filter(Announcement.id == announcement_id).first()


def get_all_announcements(
    db: Session,
    status: str | None = None,
    category_id: int | None = None,
):
    query = db.query(Announcement)

    if status:
        try:
            status_enum = AnnouncementStatus(status.title())
        except ValueError:
            return []
        query = query.filter(Announcement.status == AnnouncementStatus(status_enum))

    if category_id:
        query = query.filter(Announcement.category_id == category_id)

    return query.all()


def update_announcement(
    db: Session,
    announcement: Announcement,
    update_data: AnnouncementUpdate,
) -> Announcement:
    data = update_data.model_dump(exclude_unset=True)

    for key, value in data.items():
        setattr(announcement, key, value)

    db.commit()
    db.refresh(announcement)

    return announcement


def delete_announcement(
    db: Session,
    announcement: Announcement,
):
    db.delete(announcement)
    db.commit()
