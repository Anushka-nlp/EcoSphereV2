try:
    import speech_recognition as sr
except ImportError:
    sr = None

def speech_to_text(audio_file_path: str) -> str:
    if sr is None:
        return "Audio speech recognition package is not installed."

    recognizer = sr.Recognizer()
    try:
        with sr.AudioFile(audio_file_path) as source:
            audio = recognizer.record(source)
        text = recognizer.recognize_google(audio)
        return text
    except Exception as e:
        return f"Speech recognition unavailable: {e}"