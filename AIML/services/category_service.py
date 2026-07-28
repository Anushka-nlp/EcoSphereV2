from services.gemini_service import ask_gemini

def recommend_category(text: str):

    prompt = f"""
You are an AI Category Recommendation System for EchoSphere.

Analyze the announcement and recommend ONLY ONE category.

Available Categories:
1. Academic
2. Events
3. Placements
4. Sports
5. Circulars
6. Emergency

Respond in this format:

Category:
Reason:

Announcement:
{text}
"""

    return ask_gemini(prompt)