from services.speech_service import speech_to_text
from services.summarizer_service import summarize_announcement


def summarize_voice(audio_path):
    transcript = speech_to_text(audio_path)
    summary = summarize_announcement(transcript)

    return {
        "transcript": transcript,
        "summary": summary
    }