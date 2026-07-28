import re
from typing import Dict, Any, List, Optional
from sqlalchemy.orm import Session
from app.models.announcement import Announcement

class AIService:
    @staticmethod
    def process_chat(
        prompt: str,
        user_role: str = "STUDENT",
        department: Optional[str] = None,
        full_name: Optional[str] = None,
        usn_or_emp_id: Optional[str] = None,
        db: Optional[Session] = None
    ) -> Dict[str, Any]:
        query = prompt.strip().lower()
        role = (user_role or "STUDENT").upper()
        dept = department or "CSE"
        name = full_name or ("Student" if role == "STUDENT" else "Faculty Member")

        matched_announcements: List[Dict[str, Any]] = []
        suggested_actions: List[str] = []
        navigation_target: Optional[str] = None
        category_badge = "EchoSphere AI"
        context_badge = f"👤 {role.capitalize()} • {dept} Department"

        # ─── Step 1: Database RAG Context Grounding ─────────────────────────
        if db:
            try:
                # Query DB for published announcements matching user department or college-wide
                announcements = db.query(Announcement).order_by(Announcement.created_at.desc()).limit(15).all()

                for ann in announcements:
                    content_text = getattr(ann, 'description', getattr(ann, 'content', ''))
                    ann_title = getattr(ann, 'title', '')
                    ann_cat = getattr(ann, 'category', 'General')
                    if hasattr(ann_cat, 'name'):
                        ann_cat = ann_cat.name
                    ann_prio = getattr(ann, 'priority', 'NORMAL')
                    if hasattr(ann_prio, 'value'):
                        ann_prio = ann_prio.value
                    
                    is_relevant = (
                        dept.lower() in str(content_text).lower() or
                        dept.lower() in str(ann_title).lower() or
                        role.lower() in str(content_text).lower() or
                        any(term in ann_title.lower() or term in str(content_text).lower() for term in query.split() if len(term) > 3)
                    )

                    if is_relevant:
                        matched_announcements.append({
                            "id": ann.id,
                            "title": ann_title,
                            "category": str(ann_cat),
                            "priority": str(ann_prio),
                            "department": dept,
                            "content": str(content_text)[:150] + ("..." if len(str(content_text)) > 150 else ""),
                            "created_at": ann.created_at.strftime("%b %d, %I:%M %p") if getattr(ann, 'created_at', None) else "Recent"
                        })
                        if len(matched_announcements) >= 4:
                            break
            except Exception as e:
                print(f"[AI Service DB Error]: {e}")

        # ─── Step 2: Intent & Navigation Routing ─────────────────────────────

        # Identity & "Who are you?"
        if any(term in query for term in ["who r u", "who are you", "what is your name", "what's your name", "who u", "identify yourself", "what are you"]):
            response = (
                f"🤖 **I am EchoSphere AI Assistant!**\n\n"
                f"I am your intelligent, context-aware college announcement & campus knowledge assistant.\n\n"
                f"I am currently tuned for **{name}** ({role} · {dept} Department).\n\n"
                f"**Here is how I can assist you:**\n"
                f"• 📝 **Exams & Timetables:** Ask about exam schedules, practical lab vivas, and hall tickets.\n"
                f"• 🚨 **Emergency Alerts:** Stay updated on weather advisories or campus closures.\n"
                f"• 💼 **Placements:** Discover active recruitment drives & eligibility criteria.\n"
                f"• 📌 **Notice Creation Assistance:** Expand short notes into formal circulars with AI.\n"
                f"• ⚙️ **App Navigation:** Find settings, change password, or navigate approval workflows."
            )
            suggested_actions = ["Show Examination Notices", "Check Weather Advisory", "Where is Settings?"]

        # Greetings
        elif any(query.startswith(w) or query == w for w in ["hi", "hello", "hey", "heyy", "good morning", "good afternoon", "good evening", "greetings", "yo", "sup"]):
            response = (
                f"👋 **Hello {name}!**\n\n"
                f"Welcome to EchoSphere! I am tuned to your context as **{role}** in **{dept} Department**.\n\n"
                f"How can I help you today? You can ask me about recent announcements, exam schedules, department updates, or app features."
            )
            suggested_actions = ["Show Examination Notices", f"Filter {dept} Notices", "Where is Settings?"]

        # Gratitude & Politeness
        elif any(w in query for w in ["thank you", "thanks", "thx", "thank u", "awesome", "great", "cool", "nice", "good job", "perfect"]):
            response = (
                f"😊 **You're very welcome, {name}!**\n\n"
                f"I'm always here to help you stay informed on campus announcements, department circulars, and application features."
            )
            suggested_actions = ["Search Notices", "Browse Categories"]

        # Small Talk & "How are you"
        elif any(w in query for w in ["how are you", "how r u", "how are you doing", "how's it going", "how is it going"]):
            response = (
                f"😊 **I'm doing great and ready to assist you!**\n\n"
                f"How can I help you today, **{name}**? You can ask me about campus notices, exam schedules, or app settings."
            )
            suggested_actions = ["Check Exam Schedule", "View Emergency Status"]

        # App Knowledge & "What is EchoSphere"
        elif any(w in query for w in ["what is echosphere", "what is this app", "about echosphere", "what can you do", "help me", "features", "what do you do"]):
            response = (
                f"💡 **About EchoSphere & AI Assistant:**\n\n"
                f"EchoSphere is a smart AI-powered college announcement management platform designed to replace traditional notice boards.\n\n"
                f"**Key Capabilities:**\n"
                f"• **Instant Department Notices:** Filtered circulars for **{dept}** & College-Wide.\n"
                f"• **Context AI Assistant:** Instant answers grounded in live campus data for **{role}s**.\n"
                f"• **Speaker Broadcast:** Automated text-to-speech public address queue.\n"
                f"• **Approval Workflow:** Secure multi-tier approval hierarchy."
            )
            suggested_actions = ["Search Announcements", "How to Post Notice", "Where is Settings?"]

        # Developer / Creator Inquiry
        elif any(w in query for w in ["who created you", "who made you", "who built you", "developer"]):
            response = (
                f"🚀 **EchoSphere AI Architecture:**\n\n"
                f"I was built as part of the EchoSphere Smart AI-Powered Announcement Management System to streamline communication across students, teachers, HoDs, and administrators."
            )
            suggested_actions = ["Search Announcements", "View Categories"]

        # Navigation & Settings Query
        elif any(w in query for w in ["setting", "theme", "dark mode", "appearance", "light mode"]):
            response = (
                f"⚙️ **EchoSphere Navigation Assistant — Settings & Appearance:**\n\n"
                f"Hello {name}! To customize your application interface:\n"
                f"1. Open the **Profile** tab on the navigation bar.\n"
                f"2. Toggle **Dark Mode Theme** to switch between glassmorphism light and dark aesthetics.\n"
                f"3. Configure your notification channels and speaker preferences."
            )
            navigation_target = "nav:profile:settings"
            suggested_actions = ["Go to Profile", "Toggle Dark Mode"]

        elif any(w in query for w in ["password", "reset password", "change password", "credential"]):
            if role == "STUDENT":
                response = (
                    f"🔐 **Password Management Assistance:**\n\n"
                    f"Hello {name}! As a **Student** ({usn_or_emp_id or 'USN Registered'}):\n"
                    f"• You can request a password reset from your Department Teacher or HoD.\n"
                    f"• On the Login screen, click **Forgot Password?** to generate a secure reset token."
                )
            else:
                response = (
                    f"🔐 **Password Management Assistance:**\n\n"
                    f"Hello {name} ({role}):\n"
                    f"1. Navigate to **Profile** → **Preferences & Security**.\n"
                    f"2. Select **Change Password**.\n"
                    f"3. Enter your current password and set a new secure password."
                )
            navigation_target = "nav:profile:security"
            suggested_actions = ["Change Password", "View Security Settings"]

        elif any(w in query for w in ["create notice", "post notice", "new notice", "submit notice", "how to post"]):
            if role == "STUDENT":
                response = (
                    f"📌 **Announcement Creation Rules (SRS Section 2.3):**\n\n"
                    f"Students are registered as **Read-Only** consumers to ensure official communication integrity.\n"
                    f"If you need an announcement published for your club or event, please contact your **Department Faculty Advisor** or **HoD**."
                )
                suggested_actions = ["Browse Announcements", "Contact Faculty"]
            else:
                response = (
                    f"📌 **How to Create & Publish Announcements:**\n\n"
                    f"1. Click the floating **+ New Notice** button on the bottom right of the Home screen.\n"
                    f"2. Enter Title, Content, Target Audience, and Delivery Channels (In-App, Push, Speaker).\n"
                    f"3. Use **AI Expand** to instantly transform short drafts into formal announcements.\n"
                    f"4. **Approval Flow:** Teacher notices require HoD approval; HoD/Admin notices publish directly."
                )
                navigation_target = "action:create_notice"
                suggested_actions = ["Create New Notice", "View My Notices"]

        # Department / My Notices Query
        elif any(w in query for w in ["my department", "dept notice", "branch", "cse", "ece", "ise", "eee", "me"]):
            response = (
                f"🏫 **{dept} Department Announcements & Activity:**\n\n"
                f"Displaying official notices and circulars broadcasted specifically for **{dept} Department** students and faculty.\n"
                f"You can filter notices by department on the main dashboard feed."
            )
            navigation_target = f"nav:notices:filter:{dept}"
            suggested_actions = [f"Filter {dept} Notices", "View All Categories"]

        # Examination Query
        elif any(w in query for w in ["exam", "timetable", "test", "practical", "hall ticket", "viva", "schedule"]):
            response = (
                f"📝 **Examinations & Timetables ({dept} Department):**\n\n"
                f"• Semester Practical Lab Exams & Theory schedules are filtered under **Examinations**.\n"
                f"• All students must carry their official College ID Card and Hall Ticket to exam centers.\n"
                f"• Check the attached live notices below for exact lab batch timings."
            )
            category_badge = "Examinations"
            navigation_target = "nav:notices:filter:Examinations"
            suggested_actions = ["Filter Examinations", "Check Lab Timetable"]

        # Emergency & Rain Alert Query
        elif any(w in query for w in ["rain", "weather", "flood", "closed", "holiday", "emergency", "urgent"]):
            response = (
                f"🚨 **Emergency & Campus Status Update:**\n\n"
                f"• **Current Status:** Weather advisory and emergency broadcast status.\n"
                f"• Emergency alerts are broadcasted college-wide with highest priority at the top of your feed and via campus speakers."
            )
            category_badge = "Emergency Alert"
            navigation_target = "nav:notices:filter:Emergency"
            suggested_actions = ["View Emergency Notices", "Check Weather Advisory"]

        # Placements Query
        elif any(w in query for w in ["placement", "drive", "job", "hiring", "tcs", "google", "microsoft"]):
            response = (
                f"💼 **Placements & Career Registration Drives:**\n\n"
                f"• Active campus recruitment drives are listed under the **Placements** category filter.\n"
                f"• Standard Eligibility: CGPA ≥ 7.0 with no active backlogs.\n"
                f"• Ensure your resume and documentation are uploaded before deadlines."
            )
            category_badge = "Placements"
            navigation_target = "nav:notices:filter:Placements"
            suggested_actions = ["View Placement Drives", "Check Guidelines"]

        # Natural Grounded Fallback Response
        else:
            notice_str = ""
            if matched_announcements:
                items = [f"• **[{m['category']}]** {m['title']} ({m['created_at']})" for m in matched_announcements[:3]]
                notice_str = "\n\n**Relevant Live Notices in System:**\n" + "\n".join(items)

            response = (
                f"🤖 **EchoSphere AI Assistant:**\n\n"
                f"I am here to assist **{name}** ({role} · {dept} Department).\n\n"
                f"I can help you search campus notices, check exam timetables, find placement drives, or navigate settings. What specific topic or announcement would you like to check?{notice_str}"
            )
            suggested_actions = ["Search Notices", "Browse Categories", "Ask About Exams"]

        return {
            "response": response,
            "category_badge": category_badge,
            "context_badge": context_badge,
            "suggested_actions": suggested_actions,
            "navigation_target": navigation_target,
            "matched_announcements": matched_announcements
        }

    @staticmethod
    def draft_announcement(topic: str, category: str = "Academics", target_role: str = "STUDENT", department: Optional[str] = None) -> Dict[str, str]:
        rec = AIService.recommend_priority(topic, topic)
        cat = category if category and category != "Academics" else rec["category"]
        dept_str = f" for {department} Department" if department else ""

        clean_topic = topic.strip().capitalize()
        title = f"Notice: {clean_topic}"

        content = (
            f"Official Announcement{dept_str}\n\n"
            f"This is to inform all concerned {target_role.lower()}s regarding {clean_topic}.\n\n"
            f"Key Instructions & Action Points:\n"
            f"1. All target individuals are requested to take note of the schedule and guidelines.\n"
            f"2. Strict compliance is expected. Detailed documentation is available on the portal.\n"
            f"3. For queries, contact the Department Head or Administrative Desk.\n\n"
            f"Issued By:\nEchoSphere Administration & {department or 'Academic'} Faculty"
        )

        return {
            "title": title,
            "content": content,
            "suggested_priority": rec["priority"],
            "suggested_category": cat
        }

    @staticmethod
    def expand_text(text: str, category: str = "Academics") -> str:
        clean = text.strip()
        if not clean:
            return ""

        rec = AIService.recommend_priority(clean, clean)
        cat = category if category else rec["category"]

        return (
            f"This is an official announcement regarding: {clean.capitalize()}.\n\n"
            f"All students, faculty, and concerned personnel are hereby notified to take immediate note of this update. "
            f"Please ensure compliance with scheduled timings, guidelines, and departmental instructions. "
            f"For further clarifications or updates, please refer to the EchoSphere Announcement Portal."
        )

    @staticmethod
    def check_grammar(text: str) -> Dict[str, Any]:
        clean = text.strip()
        if not clean:
            return {"original": text, "corrected_text": text, "improvements": []}

        # Capitalize first letter, ensure ending punctuation
        corrected = clean[0].upper() + clean[1:]
        if not corrected.endswith(('.', '!', '?')):
            corrected += '.'

        improvements = []
        if len(clean) > 0 and not clean[0].isupper():
            improvements.append("Capitalized initial letter.")
        if not clean.endswith(('.', '!', '?')):
            improvements.append("Added terminal punctuation.")

        return {
            "original": text,
            "corrected_text": corrected,
            "improvements": improvements or ["Sentence structure and formatting verified."]
        }

    @staticmethod
    def validate_content(title: str, text: str) -> Dict[str, Any]:
        combined = f"{title} {text}".lower()
        missing = []

        if len(title.strip()) < 5:
            missing.append("Descriptive Title (minimum 5 characters)")

        if len(text.strip()) < 20:
            missing.append("Detailed Description (minimum 20 characters)")

        # Specific SRS field completeness checks
        has_time = any(w in combined for w in ["am", "pm", "time", "clock", "hours", "schedule", "at "])
        has_venue = any(w in combined for w in ["room", "lab", "hall", "auditorium", "building", "campus", "online", "venue", "block"])
        has_date = any(w in combined for w in ["today", "tomorrow", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday", "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec", "2026", "2025", "date"])

        if not has_time:
            missing.append("Specific Time / Schedule")
        if not has_venue:
            missing.append("Venue / Location / Block")
        if not has_date:
            missing.append("Date / Deadline")

        is_valid = len(missing) == 0
        reason = "Announcement content is complete and ready for publishing." if is_valid else f"Missing key details: {', '.join(missing)}."
        suggestion = f"Consider adding details for: {', '.join(missing)}." if not is_valid else None

        return {
            "is_valid": is_valid,
            "missing_fields": missing,
            "reason": reason,
            "suggestion": suggestion
        }

    @staticmethod
    def check_spam(text: str) -> Dict[str, Any]:
        lower = text.lower()
        flags = []

        spam_keywords = ['win money', 'free cash', 'crypto', 'subscribe', 'buy now', 'cheap', 'click link', 'earn $$$', 'whatsapp group']
        found_keywords = [w for w in spam_keywords if w in lower]
        if found_keywords:
            flags.append(f"Contains promotional/spam terms: {', '.join(found_keywords)}")

        # Check for excessive ALL CAPS
        words = text.split()
        if len(words) >= 5:
            caps_count = sum(1 for w in words if w.isupper() and len(w) > 1)
            if caps_count / len(words) > 0.5:
                flags.append("Excessive CAPITALIZATION detected.")

        is_spam = len(flags) > 0
        reason = "; ".join(flags) if is_spam else "Official institutional content."

        return {
            "is_spam": is_spam,
            "reason": reason,
            "flags": flags
        }

    @staticmethod
    def check_duplicate(new_title: str, new_text: str, department: Optional[str] = None, db: Optional[Session] = None) -> Dict[str, Any]:
        if not db:
            return {"is_duplicate": False, "similarity_score": 0.0, "matched_title": None, "reason": "No database session available."}

        try:
            recent_notices = db.query(Announcement).order_by(Announcement.created_at.desc()).limit(20).all()

            new_combined = f"{new_title} {new_text}".lower()
            new_words = set(re.findall(r'\w+', new_combined))

            best_match_title = None
            highest_score = 0.0

            for notice in recent_notices:
                desc = getattr(notice, 'description', getattr(notice, 'content', ''))
                existing_combined = f"{getattr(notice, 'title', '')} {desc}".lower()
                existing_words = set(re.findall(r'\w+', existing_combined))

                if not existing_words or not new_words:
                    continue

                intersection = new_words.intersection(existing_words)
                union = new_words.union(existing_words)
                jaccard_score = len(intersection) / len(union)

                if jaccard_score > highest_score:
                    highest_score = jaccard_score
                    best_match_title = notice.title

            is_dup = highest_score >= 0.45
            reason = f"High similarity ({int(highest_score * 100)}%) detected with existing notice: '{best_match_title}'." if is_dup else "Notice content is unique."

            return {
                "is_duplicate": is_dup,
                "similarity_score": round(highest_score, 2),
                "matched_title": best_match_title if is_dup else None,
                "reason": reason
            }
        except Exception as e:
            return {"is_duplicate": False, "similarity_score": 0.0, "matched_title": None, "reason": f"Check failed: {e}"}

    @staticmethod
    def recommend_priority(title: str, content: str, user_role: str = "STUDENT") -> Dict[str, Any]:
        text = f"{title} {content}".lower()
        role = (user_role or "STUDENT").upper()

        if any(w in text for w in ['rain', 'flood', 'weather', 'closed', 'suspended', 'emergency', 'disaster', 'evacuation']):
            priority = "EMERGENCY"
            category = "Emergency"
            reasoning = "Critical campus-wide emergency keywords detected."
        elif any(w in text for w in ['exam', 'timetable', 'hall ticket', 'test', 'viva', 'practical', 'schedule']):
            priority = "HIGH"
            category = "Examinations"
            reasoning = "Academic examination or scheduling event detected."
        elif any(w in text for w in ['placement', 'interview', 'drive', 'hiring', 'recruitment', 'google', 'microsoft', 'amazon']):
            priority = "HIGH"
            category = "Placements"
            reasoning = "Career/placement drive activity detected with strict deadline."
        elif any(w in text for w in ['hackathon', 'fest', 'workshop', 'seminar', 'symposium', 'event', 'club']):
            priority = "NORMAL"
            category = "Events"
            reasoning = "Standard campus event or workshop notification."
        elif any(w in text for w in ['sports', 'tournament', 'match', 'cricket', 'football', 'gym']):
            priority = "NORMAL"
            category = "Sports"
            reasoning = "Sports or extra-curricular announcement."
        else:
            priority = "NORMAL"
            category = "Academics"
            reasoning = "General campus announcement."

        # Role authority check (SRS Section 2 & 5.15)
        allowed_roles = ["COLLEGE ADMIN", "HOD", "PRINCIPAL", "DEVELOPER"]
        is_allowed = True
        if priority == "EMERGENCY" and role not in allowed_roles:
            is_allowed = False
            priority = "HIGH"
            reasoning += " (Note: Only Authorized Administrators & HoDs may issue Emergency priority; priority capped at HIGH)."

        return {
            "priority": priority,
            "category": category,
            "reasoning": reasoning,
            "is_allowed": is_allowed
        }

    @staticmethod
    def summarize(content: str) -> str:
        if not content:
            return "No content provided."
        clean = content.strip()
        if len(clean) <= 90:
            return clean
        sentences = re.split(r'(?<=[.!?])\s+', clean)
        if sentences:
            return f"Summary: {sentences[0]} (Key update)."
        return f"Summary: {clean[:85]}..."
