from sqlalchemy.orm import Session

from app.models.department import Department


def seed_departments(db: Session):
    departments = [
        {
            "name": "Computer Science & Engineering",
            "code": "CSE",
        },
        {
            "name": "Information Science & Engineering",
            "code": "ISE",
        },
        {
            "name": "Electronics & Communication Engineering",
            "code": "ECE",
        },
        {
            "name": "Electrical & Electronics Engineering",
            "code": "EEE",
        },
        {
            "name": "Artificial Intelligence & Machine Learning",
            "code": "AIML",
        },
        {
            "name": "Artificial Intelligence & Data Science",
            "code": "AIDS",
        },
        {
            "name": "Physics",
            "code": "PHY",
        },
        {
            "name": "Chemistry",
            "code": "CHE",
        },
    ]

    for department in departments:
        existing_department = (
            db.query(Department).filter(Department.code == department["code"]).first()
        )

        if not existing_department:
            db.add(
                Department(
                    name=department["name"],
                    code=department["code"],
                    is_active=True,
                )
            )

    db.commit()
