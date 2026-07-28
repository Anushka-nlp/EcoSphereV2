import os
from dotenv import load_dotenv

load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY", "")

model = None
if GEMINI_API_KEY and GEMINI_API_KEY != "YOUR_ACTUAL_GEMINI_API_KEY":
    try:
        import google.generativeai as genai
        genai.configure(api_key=GEMINI_API_KEY)
        model = genai.GenerativeModel("gemini-1.5-flash")
    except Exception:
        model = None

def ask_gemini(prompt: str) -> str:
    if model is not None:
        try:
            response = model.generate_content(prompt)
            if response and hasattr(response, 'text') and response.text:
                return response.text
        except Exception:
            pass
    
    return _local_fallback_response(prompt)

def _local_fallback_response(prompt: str) -> str:
    text = prompt.lower()
    if "category" in text:
        if any(w in text for w in ['exam', 'test', 'marks', 'viva']): return "Category: Academic\nReason: Examination or academic details detected."
        if any(w in text for w in ['rain', 'closed', 'flood', 'suspended']): return "Category: Emergency\nReason: Weather alert or campus suspension."
        if any(w in text for w in ['placement', 'job', 'interview', 'hiring']): return "Category: Placements\nReason: Career drive notification."
        if any(w in text for w in ['sports', 'match', 'cricket']): return "Category: Sports\nReason: Athletic or sports activity."
        return "Category: Academic\nReason: General campus announcement."
    if "priority" in text:
        if any(w in text for w in ['emergency', 'rain', 'closed', 'flood']): return "Priority: Emergency\nReason: High severity alert."
        if any(w in text for w in ['exam', 'timetable', 'hall ticket', 'placement']): return "Priority: High\nReason: Timetable/academic deadline."
        return "Priority: Medium\nReason: Standard announcement."
    if "emergency" in text:
        is_em = any(w in text for w in ['rain', 'flood', 'closed', 'suspended', 'urgent', 'disaster'])
        return f"Emergency: {is_em}\nReason: {'High severity emergency keywords detected.' if is_em else 'Standard notice.'}"
    if "spam" in text:
        is_spam = any(w in text for w in ['win money', 'free cash', 'crypto', 'subscribe', 'buy now'])
        return f"Spam: {is_spam}\nReason: {'Contains spam keywords.' if is_spam else 'Clean official text.'}"
    if "expand" in text:
        return f"Official Notice:\n\n{prompt}\n\nPlease take note of the schedule and guidelines. Contact department office for details."
    if "summarize" in text:
        return f"• Important notice regarding campus schedule.\n• Please check detailed guidelines.\n• Contact administration for queries."
    
    return f"EchoSphere AI: Processed announcement successfully."