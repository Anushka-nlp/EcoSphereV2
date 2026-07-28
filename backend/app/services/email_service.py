import os
import smtplib
from email.message import EmailMessage

from dotenv import load_dotenv

load_dotenv()

SMTP_SERVER = os.getenv("SMTP_SERVER")
SMTP_PORT = int(os.getenv("SMTP_PORT", "587"))
SMTP_USERNAME = os.getenv("SMTP_USERNAME")
SMTP_PASSWORD = os.getenv("SMTP_PASSWORD")
SMTP_FROM_EMAIL = os.getenv("SMTP_FROM_EMAIL")


def send_password_reset_email(
    recipient_email: str,
    reset_link: str,
):
    """
    Sends a password reset email.
    """

    if not all(
        [
            SMTP_SERVER,
            SMTP_USERNAME,
            SMTP_PASSWORD,
            SMTP_FROM_EMAIL,
        ]
    ):
        raise RuntimeError(
            "SMTP configuration is incomplete. "
            "Please verify the SMTP settings in the .env file."
        )

    message = EmailMessage()

    message["Subject"] = "EchoSphere Password Reset"
    message["From"] = SMTP_FROM_EMAIL
    message["To"] = recipient_email

    message.set_content(
        f"""
Hello,

A request was received to reset your EchoSphere password.

Click the link below to reset your password:

{reset_link}

If you did not request this, you can safely ignore this email.

Regards,
EchoSphere Team
"""
    )

    assert SMTP_SERVER is not None
    assert SMTP_USERNAME is not None
    assert SMTP_PASSWORD is not None
    assert SMTP_FROM_EMAIL is not None

    smtp_server = SMTP_SERVER
    smtp_username = SMTP_USERNAME
    smtp_password = SMTP_PASSWORD

    with smtplib.SMTP(
        host=smtp_server,
        port=SMTP_PORT,
    ) as smtp:
        smtp.starttls()

        smtp.login(
            user=smtp_username,
            password=smtp_password,
        )

        smtp.send_message(message)
