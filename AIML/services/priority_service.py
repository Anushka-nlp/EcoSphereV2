from services.gemini_service import ask_gemini

def recommend_priority(text: str):

    prompt = f"""
You are an AI Priority Recommendation System for EchoSphere.

Analyze the following announcement.

Recommend ONLY ONE priority level.

Priority Levels:
1. Low
2. Medium
3. High
4. Emergency

Respond in this format:

Priority:
Reason:

Announcement:
{text}
"""

    return ask_gemini(prompt)