from services.gemini_service import ask_gemini

def validate_content(text: str):

    prompt = f"""
You are an AI content validator for a Smart Campus Communication System.

Analyze the following announcement.

Check whether it contains enough meaningful information.

If information is missing, suggest what should be added.

Respond in this format:

Valid: True or False
Reason:
Suggestion:

Announcement:
{text}
"""

    return ask_gemini(prompt)