def detect_intent(question: str) -> str:
    question = question.lower()

    if any(word in question for word in ["announcement", "notice", "circular", "news"]):
        return "announcements"

    elif any(
        word in question
        for word in ["event", "fest", "workshop", "seminar", "competition"]
    ):
        return "events"

    elif any(
        word in question
        for word in ["department", "library", "canteen", "office", "campus"]
    ):
        return "campus_info"

    else:
        return "general_chat"
