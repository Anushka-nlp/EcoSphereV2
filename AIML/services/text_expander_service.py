from services.gemini_service import ask_gemini

def expand_text(text: str):
    prompt = f"Expand the following text in a professional way:\n\n{text}"
    return ask_gemini(prompt)

    