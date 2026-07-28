from app.core.password import hash_password, verify_password

password = "Teacher@123"

hashed_password = hash_password(password)

print(f"Original Password : {password}")
print(f"Hashed Password   : {hashed_password}")

print("\nVerification Tests")

print(
    "Correct Password :",
    verify_password("Teacher@123", hashed_password),
)

print(
    "Wrong Password   :",
    verify_password("Teacher@321", hashed_password),
)
