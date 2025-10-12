# 🦊 FoxHub
**Applications Development and Emerging Technologies Project**  
*Developed by:* **Arron Kian M. Parejas (CS-304)**  
📅 **Date:** October 11, 2025

---

## 📘 Overview
FoxHub is a unified platform that bridges the gap between **education** and **career opportunities** in the IT field — designed to help **college students**, especially those in **rural or underserved regions**, build their skills, explore internships, and grow professionally.

It features a **career path builder**, **skill analyzer**, **internship/job board**, **community forums**, **organization hub**, and more — all powered by **Flutter**, **Firebase**, and **Next.js** backend integrations.

---

## 🚀 Getting Started

### 🔧 Prerequisites
Before running the project, make sure you have the following installed:
- **Flutter SDK** (latest stable version)
- **Node.js & npm** (for backend)
- **Git** (for cloning and version control)
- **Visual Studio Code / Android Studio**

---

## 📂 Project Structure
```
FoxHub/
│
├── lib/
│   ├── screens/
│   │   ├── project_screen.dart
│   │   ├── skill_analyzer.dart
│   │   └── ...
│   ├── services/
│   │   ├── adzuna_services.dart
│   │   └── future_update/
│   │       └── adzuna_services.dart
│   └── main.dart
│
├── backend/ <-- Next.js API backend
│   ├── pages/api/
│   └── ...
│
└── README.md
```

---

## 🔑 API Keys Setup

FoxHub uses two external APIs for enhanced functionality:

| API Name | Purpose | File Location | Line                                                    | Key |
|-----------|----------|---------------|---------------------------------------------------------|------|
| **Adzuna API** | Fetches IT job & internship listings | `lib/services/adzuna_services.dart` | 43                                                      | `216a175e0c703586e158f0ab7cc08bb1` |
| **Gemini API (Google)** | Provides AI-powered features like skill analysis and project idea generation | `lib/screens/project_screen.dart` (L22), `lib/screens/skill_analyzer.dart` (L72) | line 22 in project screen and line 72 in skill analyzer | `AIzaSyCpwrfw4KoMaCyuykTUT3Zcrh1KkeZ1ltg` |

> ⚠️ **Security Note:**  
> Do not expose your API keys in public repositories.  
> For production, store these keys in a `.env` file and access them securely.

---

## 🔒 Using .env for API Keys

1. Create a `.env` file in the project root directory.
2. Add your keys inside:
   ```env
   ADZUNA_API_KEY=your_adzuna_key_here
   GEMINI_API_KEY=your_gemini_key_here
   ```
3. Install a package like [`flutter_dotenv`](https://pub.dev/packages/flutter_dotenv).
4. Load your environment variables in `main.dart`:
   ```dart
   import 'package:flutter_dotenv/flutter_dotenv.dart';

   Future<void> main() async {
     await dotenv.load(fileName: ".env");
     runApp(MyApp());
   }
   ```
5. Access your keys:
   ```dart
   final adzunaKey = dotenv.env['ADZUNA_API_KEY'];
   ```

---

## 🧩 How to Run the Application (Frontend)

### Step 1 — Navigate to the project directory:
```bash
cd foxhub
```

### Step 2 — Install dependencies:
```bash
flutter pub get
```

### Step 3 — Run the application:
```bash
flutter run
```
✅ The app should now compile and run on your connected emulator or device.  
(No need to start the backend for this step — it uses mock or live APIs directly.)

---

## ⚙️ Running the Backend (Next.js API)
If you want to test the Next.js backend features:

### Step 1 — Navigate to the backend directory:
```bash
cd ../backend
```

### Step 2 — Install dependencies:
```bash
npm install
```

### Step 3 — Start the development server:
```bash
npm run dev
```
This will start the backend locally at  
👉 http://localhost:3000

---

## 🔄 Linking Backend and Frontend
1. Go to your Flutter app folder → `lib/services/future_update/adzuna_services.dart`
2. Copy the commented-out Next.js API code provided there.
3. Navigate to → `lib/services/adzuna_services.dart`
4. Paste and replace the current API call section with the copied one.

This will allow the Flutter app to use your **Next.js local backend** instead of the live Adzuna API.

---

## 🧠 Using the App Features

### 🎯 For Students
- **Career Path Builder** → Personalized IT learning roadmap
- **Skill Analyzer** → Upload a resume to analyze your skill gaps
- **Internship Board** → Find remote/hybrid job opportunities
- **Community Forum** → Connect and collaborate with others
- **Profile Section** → Showcase your skills, projects, and achievements

### 🏢 For Organizations & Companies
- **Register Organizations** → Add info, modules, and events
- **Post Internships/Jobs** → Share remote/hybrid opportunities
- **Student Filtering** → Search students by skills or interests

---

## 🧰 Technologies Used

| Category | Technologies                                |
|-----------|---------------------------------------------|
| Frontend | Flutter, Dart                               |
| Backend / API | Next.js, Supabase, Firebase                 |
| Authentication | Firebase Auth                               |
| Database | Firestore, Supabase Postgres                |
| Cloud & Hosting | Firebase Hosting, Google Cloud Run          |
| Storage | Firebase Storage                            |
| Notifications | Firebase Cloud Messaging                    |
| AI / ML | Gemini API, Firebase ML Kit                 |
| Version Control | GitHub, GitHub Actions                      |
| API Keys | Adzuna, Gemini                              |
|Deployment| Firebase Hosting, Google Cloud Run , Vercel |

---

## 🧪 Development Commands

| Action | Command |
|--------|----------|
| Run Flutter app | `flutter run` |
| Get dependencies | `flutter pub get` |
| Analyze code | `flutter analyze` |
| Format code | `flutter format .` |
| Run Next.js backend | `npm run dev` |
| Build production backend | `npm run build` |

---

## 👨‍💻 Developer

**Arron Kian M. Parejas**  
📧 parejasarronkian@gmail.com  
🧭 Sole Developer & Designer of FoxHub

- Designed and developed frontend UI using Flutter
- Integrated Firebase Authentication, Firestore, and Next.js backend
- Implemented AI-based skill analysis using Gemini API
- Conducted testing, debugging, and deployment

---

## 🗂️ Repository & Resources

🔗 **GitHub Repository:**  
[https://github.com/darknecrocities/FoxHub](https://github.com/darknecrocities/FoxHub)

🎞️ **Presentation Slides (Canva):**  
_To be provided by developer_

---

## 📈 Future Recommendations
- Integrate AI Career Coach for guided planning
- Add Certification Partnerships with Coursera/LinkedIn Learning
- Enable Offline Mode for low-bandwidth users
- Implement Gamification for progress tracking
- Develop Analytics Dashboard for user performance insights

---

## 🧩 License
This project is part of the **Applications Development and Emerging Technologies (6ADET)** course requirement.  
All rights reserved © 2025 — **Arron Kian M. Parejas**
