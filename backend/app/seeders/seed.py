from app.db.database import SessionLocal

from app.seeders.role import seed_roles
from app.seeders.category import seed_categories
from app.seeders.delivery_type import seed_delivery_types
from app.seeders.department import seed_departments
from app.seeders.user import seed_users


def main() -> None:
    db = SessionLocal()

    try:
        print("Seeding roles...")
        seed_roles(db)

        print("Seeding announcement categories...")
        seed_categories(db)

        print("Seeding delivery types...")
        seed_delivery_types(db)

        print("Seeding departments...")
        seed_departments(db)

        print("Seeding users...")
        seed_users(db)

        print("✅ Database seeded successfully!")
    finally:
        db.close()


if __name__ == "__main__":
    main()
