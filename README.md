# K2 Communications App

A cross-platform (Flutter) employee app for [K2 Communications](https://k2communications.in) PR managers — runs on **Web, Android, and iOS**.

## Features

- **Authentication** — Phone OTP + Email/Password login with Admin-controlled account activation
- **Role-based access** — ADMIN and EMPLOYEE roles with permission-gated screens
- **Employee Profiles** — Exhaustive but optional profile with personal + professional fields
- **Daily War Work Module** — Tasks, Campaign Tracker, Daily Reports, Meeting Alerts
- **News Intelligence** — Personalized news with category/company tracking (pluggable provider)
- **Community Center** — Forum with channels, threads, comments, reactions & moderation
- **Voice Operation (Phase 1)** — Mic button on key screens for voice-to-text input
- **Admin Panel** — User management, activation, client assignments, reports
- **Bilingual-ready** — 7 languages: English, Kannada, Hindi, Marathi, Tamil, Telugu, Bengali

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| Backend | Firebase (Auth, Firestore, Storage, FCM) |
| State | flutter_riverpod |
| Navigation | go_router |
| Localization | flutter_localizations + ARB files |

## Design System

- **Primary** `#1A2B4A` deep navy
- **Accent** `#F5A623` vibrant orange (CTAs)
- **Background** `#FFFFFF` white
- Typography: Inter (Google Fonts)
- Clean corporate, lots of whitespace, bold headings

## Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Firebase project (optional for demo mode)

### Run in Demo Mode (no Firebase needed)
```bash
flutter pub get
flutter run -d chrome   # Web
flutter run             # Android/iOS emulator
```

**Demo accounts:**
| Role | Email | Password |
|---|---|---|
| Admin | admin@k2.com | password |
| Employee | emp@k2.com | password |

### Connect Firebase (production)
1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable Authentication (Email/Password + Phone), Firestore, Storage, and Cloud Messaging
3. Run `flutterfire configure` to generate `lib/firebase_options.dart`
4. Uncomment the Firebase initialization block in `lib/main.dart`

## Project Structure

```
lib/
├── main.dart                # Entry point
├── app.dart                 # GoRouter + app shell
├── firebase_options.dart    # Firebase config (run flutterfire configure)
├── core/
│   ├── theme/               # AppColors, AppTheme
│   ├── constants/           # App & route constants
│   ├── utils/               # Validators, date helpers
│   └── widgets/             # Reusable widgets (AppButton, AppCard, etc.)
├── l10n/                    # ARB localization files (en, kn, hi, mr, ta, te, bn)
├── models/                  # Data models (User, Client, Task, Campaign, …)
├── services/                # Service layer (Auth, User, Task, News, Forum, …)
├── providers/               # Riverpod state notifiers
└── features/
    ├── auth/                # Login, Register, Pending Activation
    ├── dashboard/           # Today view
    ├── clients/             # Client list + detail
    ├── work/                # Tasks, Campaigns, Daily Report, Meetings
    ├── news/                # News feed + preferences
    ├── community/           # Forum channels, threads, comments
    ├── profile/             # Employee profile + edit
    └── admin/               # Admin dashboard, user mgmt, activation, reports
```

## Navigation

```
Bottom Nav: Dashboard | Clients | Work | News | Community | Profile
```

Admin users additionally see an **Admin** section accessible from the profile screen.

## License
Proprietary — K2 Communications.

