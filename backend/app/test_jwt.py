from app.core.jwt_handler import (
    create_access_token,
    verify_access_token,
)

payload = {
    "sub": "teacher@college.edu",
    "role": "Teacher",
}

token = create_access_token(payload)

print("Generated JWT:\n")
print(token)

print("\nVerifying Token...\n")

decoded_payload = verify_access_token(token)

print("Decoded Payload:")
print(decoded_payload)
