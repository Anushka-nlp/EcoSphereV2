from services.gemini_service import ask_gemini

def detect_duplicate(existing_text: str, new_text: str):

    prompt = f"""
You are an AI Duplicate Detection System for the EchoSphere Smart Campus Communication System.

Compare the following two announcements.

Determine whether they are duplicates or nearly identical.

Respond ONLY in this format:

Duplicate:
Similarity:
Reason:

Existing Announcement:
{existing_text}

New Announcement:
{new_text}
"""

    return ask_gemini(prompt)