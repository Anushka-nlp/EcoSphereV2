from fastapi import APIRouter, Depends
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session

from app.core.dependencies import (
    get_current_user,
    require_roles,
)
from app.db.database import get_db
from app.models.user import User
from app.schemas.auth import LoginRequest, TokenResponse
from app.schemas.password_reset import (
    VerifyResetTokenRequest,
    VerifyResetTokenResponse,
)
from app.services.auth_service import authenticate_user
from app.services.password_reset_service import (
    verify_reset_token_service,
)

router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.post(
    "/login",
    response_model=TokenResponse,
)
def login(
    request: LoginRequest,
    db: Session = Depends(get_db),
):
    try:
        access_token, user = authenticate_user(
            db=db,
            identifier=request.identifier,
            password=request.password,
            employee_id=request.employee_id,
        )

        return TokenResponse(
            access_token=access_token,
            token_type="bearer",
            role=user.role.name if user.role else "Student",
            user_id=user.id,
            full_name=user.full_name,
            official_email=user.official_email,
            usn=user.usn,
            employee_id=user.employee_id,
            department_id=user.department_id,
        )
    except ValueError as e:
        from fastapi import HTTPException
        raise HTTPException(status_code=400, detail=str(e))


@router.post(
    "/token",
    response_model=TokenResponse,
)
def login_for_swagger(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db),
):
    access_token = authenticate_user(
        db=db,
        official_email=form_data.username,
        password=form_data.password,
    )

    return TokenResponse(
        access_token=access_token,
        token_type="bearer",
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


@router.get("/me")
def get_me(
    current_user: User = Depends(get_current_user),
):
    return {
        "id": current_user.id,
        "full_name": current_user.full_name,
        "official_email": current_user.official_email,
        "usn": current_user.usn,
        "employee_id": current_user.employee_id,
        "role_id": current_user.role_id,
        "role": current_user.role.name if current_user.role else "Student",
        "department_id": current_user.department_id,
        "department": current_user.department.name if current_user.department else None,
    }


@router.get("/admin-only")
def admin_only(
    current_user: User = Depends(
        require_roles("Developer"),
    ),
):
    return {
        "message": "Welcome Developer!",
        "user": current_user.official_email,
    }
