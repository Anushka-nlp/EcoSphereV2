from datetime import datetime
from typing import Optional

from pydantic import BaseModel, ConfigDict

from app.core.enums.announcement import (
    AnnouncementPriority,
    AnnouncementStatus,
    EmergencyLevel,
)


class AnnouncementCreate(BaseModel):
    title: str
    description: str
    category_id: int

    priority: AnnouncementPriority = AnnouncementPriority.NORMAL
    emergency_level: EmergencyLevel = EmergencyLevel.NORMAL
    scheduled_at: Optional[datetime] = None


class AnnouncementUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    category_id: Optional[int] = None

    priority: Optional[AnnouncementPriority] = None
    emergency_level: Optional[EmergencyLevel] = None
    status: Optional[AnnouncementStatus] = None
    scheduled_at: Optional[datetime] = None


class AnnouncementResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    title: str
    description: str

    status: AnnouncementStatus
    priority: AnnouncementPriority
    emergency_level: EmergencyLevel

    scheduled_at: Optional[datetime]

    created_by: int
    category_id: int


class AnnouncementApprovalRequest(BaseModel):
    remarks: Optional[str] = None
