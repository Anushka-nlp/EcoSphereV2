import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app.db.database import engine, Base, SessionLocal
import app.models
from app.seeders.role import seed_roles
from app.seeders.category import seed_categories
from app.seeders.delivery_type import seed_delivery_types
from app.seeders.department import seed_departments
from app.seeders.user import seed_users

def init_db():
    print("[*] Creating database tables...")
    Base.metadata.create_all(bind=engine)
    print("[+] Tables created successfully.")

    db = SessionLocal()
    try:
        print("[*] Seeding roles...")
        seed_roles(db)
        print("[*] Seeding categories...")
        seed_categories(db)
        print("[*] Seeding delivery types...")
        seed_delivery_types(db)
        print("[*] Seeding departments...")
        seed_departments(db)
        print("[*] Seeding users...")
        seed_users(db)
        print("[+] Database initialized and seeded successfully!")
    except Exception as e:
        print(f"[!] Note during seeding: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    init_db()
