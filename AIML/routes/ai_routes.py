from fastapi import UploadFile, File
import shutil


from services.speech_service import speech_to_text
from fastapi import APIRouter
from services.text_expander_service import expand_text

router = APIRouter(prefix="/ai", tags=["AI"])

@router.post("/expand")
async def expand(text: str):

    expanded = expand_text(text)

    return {
        "original": text,
        "expanded_text": expanded
    }

#for emergency services
from services.emergency_service import detect_emergency
@router.post("/emergency")
async def emergency(text: str):
    result = detect_emergency(text)

    return {
        "result": result
    }
    
#for summarizer
from services.summarizer_service import summarize_announcement

@router.post("/summarize")
async def summarize(text: str):
    summary = summarize_announcement(text)

    return {
        "original": text,
        "summary": summary
    }

#for voice to text
@router.post("/speech-to-text")
async def speech_to_text_api(file: UploadFile = File(...)):

    file_path = f"temp_{file.filename}"

    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    text = speech_to_text(file_path)

    return {
        "filename": file.filename,
        "text": text
    }
#for voice summery
from services.voice_summary_service import summarize_voice
@router.post("/voice-summary")
async def voice_summary(file: UploadFile = File(...)):
    file_path = f"temp_{file.filename}"

    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    result = summarize_voice(file_path)

    return result

# For Spam Detection
from services.spam_service import detect_spam

@router.post("/spam")
async def spam(text: str):

    result = detect_spam(text)

    return {
        "result": result
    }

#for content validation 
from services.content_validation_service import validate_content
@router.post("/validate")
async def validate(text: str):

    result = validate_content(text)

    return {
        "result": result
    }

#for categoty recommendation 
from services.category_service import recommend_category
@router.post("/category")
async def category(text: str):

    result = recommend_category(text)

    return {
        "result": result
    }

#for priority recommendation
from services.priority_service import recommend_priority
@router.post("/priority")
async def priority(text: str):

    result = recommend_priority(text)

    return {
        "result": result
    }

#for duplicate 
from services.duplicate_service import detect_duplicate
from pydantic import BaseModel

class DuplicateRequest(BaseModel):
    existing_text: str
    new_text: str


@router.post("/duplicate")
async def duplicate(request: DuplicateRequest):

    result = detect_duplicate(
        request.existing_text,
        request.new_text
    )

    return {
        "result": result
    }