from services.gemini_service import ask_gemini


def detect_emergency(text: str):
    prompt = f"""
You are an emergency detection AI.

Analyze the following college announcement.

Return whether it is an emergency.

Respond in this format:

Emergency: True or False
Reason: Short explanation

Announcement:
{text}
"""
    return ask_gemini(prompt)