from sqlalchemy.orm import Session

from app.models.password_reset_token import PasswordResetToken


def create_password_reset_token(
    db: Session,
    reset_token: PasswordResetToken,
):
    db.add(reset_token)
    db.commit()
    db.refresh(reset_token)
    return reset_token


def get_password_reset_token(
    db: Session,
    token: str,
):
    return (
        db.query(PasswordResetToken).filter(PasswordResetToken.token == token).first()
    )


def update_password_reset_token(
    db: Session,
    reset_token: PasswordResetToken,
):
    db.commit()
    db.refresh(reset_token)
    return reset_token


def delete_expired_tokens(
    db: Session,
    user_id: int,
):
    (
        db.query(PasswordResetToken)
        .filter(PasswordResetToken.user_id == user_id)
        .delete()
    )

    db.commit()
