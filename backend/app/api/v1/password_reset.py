from fastapi import APIRouter, Depends, Request
from sqlalchemy.orm import Session

from app.core.rate_limiter import limiter
from app.db.database import get_db
from app.schemas.password_reset import (
    ForgotPasswordRequest,
    ForgotPasswordResponse,
    VerifyResetTokenRequest,
    VerifyResetTokenResponse,
    ResetPasswordRequest,
    ResetPasswordResponse,
)
from app.services.password_reset_service import (
    forgot_password_service,
    verify_reset_token_service,
    reset_password_service,
)

router = APIRouter(
    prefix="/auth",
    tags=["Password Recovery"],
)


@router.post(
    "/forgot-password",
    response_model=ForgotPasswordResponse,
)
@limiter.limit("5/15minutes")
def forgot_password(
    request: Request,
    body: ForgotPasswordRequest,
    db: Session = Depends(get_db),
):
    return forgot_password_service(
        db=db,
        identifier=body.identifier,
    )


@router.post(
    "/verify-reset-token",
    response_model=VerifyResetTokenResponse,
)
def verify_reset_token(
    request: VerifyResetTokenRequest,
    db: Session = Depends(get_db),
):
    result = verify_reset_token_service(
        db=db,
        token=request.token,
    )

    return VerifyResetTokenResponse(**result)


@router.post(
    "/reset-password",
    response_model=ResetPasswordResponse,
)
def reset_password(
    request: ResetPasswordRequest,
    db: Session = Depends(get_db),
):
    result = reset_password_service(
        db=db,
        token=request.token,
        new_password=request.new_password,
    )

    return ResetPasswordResponse(**result)
