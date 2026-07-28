from services.gemini_service import ask_gemini

def classify_announcement(announcement: str):
    prompt = f"""
You are EchoSphere AI.

Classify the following college announcement.

Choose ONLY ONE category from this list:
- Exam
- Workshop
- Placement
- Event
- Holiday
- Sports
- Fee
- Emergency
- General

Also determine the priority:
- High
- Medium
- Low

Return the answer in exactly this format:
Category: <category>
Priority: <priority>

Announcement:
{announcement}
"""
    return ask_gemini(prompt)
