from datetime import datetime

from pydantic import BaseModel, ConfigDict


class AuditLogResponse(BaseModel):
    """
    Response schema for an audit log.
    """

    id: int
    user_id: int
    action: str
    entity: str
    entity_id: int
    description: str
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
