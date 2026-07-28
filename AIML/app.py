from dotenv import load_dotenv 
load_dotenv()

from fastapi import FastAPI
from routes.ai_routes import router as ai_router

app = FastAPI(title="EchoSphere AI")

app.include_router(ai_router)

@app.get("/")
def home():
    return {"message": "EchoSphere AI Running"}

