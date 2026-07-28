from services.gemini_service import ask_gemini

def summarize_announcement(announcement: str):
    prompt = f"""
Summarize the following college announcement into exactly 3 bullet points.

Announcement:
{announcement}
"""
    return ask_gemini(prompt)
