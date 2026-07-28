from sqlalchemy.orm import Session

from app.models.announcement_approval import AnnouncementApproval


def create_approval(
    db: Session,
    approval: AnnouncementApproval,
) -> AnnouncementApproval:
    db.add(approval)
    db.commit()
    db.refresh(approval)

    return approval
