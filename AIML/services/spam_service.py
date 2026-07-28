from services.gemini_service import ask_gemini

def detect_spam(text: str):

    prompt = f"""
You are an AI that detects spam in college announcements.

Analyze the following announcement.

Respond only in this format:

Spam: True or False
Reason: Short explanation

Announcement:
{text}
"""

    return ask_gemini(prompt)