from services.gemini_service import ask_gemini

if __name__ == "__main__":
    result = ask_gemini("Hello! Confirm EchoSphere AI is operational.")
    print("EchoSphere AI Result:")
    print(result)
