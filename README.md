# ⚽ Mobile Application Slavia

A full-stack mobile application for fans of **SK Slavia Praha**, providing real-time match updates, club news, videos, and a community forum — built with Flutter and a Docker-based microservice back-end.z

---

## 🏗️ Project Structure

```
Slavia-App/
├── Backend/                  # Python & Node.js (TypeScript) microservices
└── Frontend/
    └── slavia_app/           # Flutter mobile application
```

---

## 🎨 Front-End (Flutter / Dart)

The app launches with an **Introduction Screen** and then navigates to the **Home Page**, which hosts a bottom navigation bar with the following sections:

### 📰 Post Page
- Displays all club-related posts, filterable by team via a tab selector: **A-Team, B-Team, Woman, U-19, Club**
- A background script keeps posts continuously up to date
- Tapping a post opens the **Post Screen** with the full article
- Navigate back via the arrow icon or an edge swipe

### 🎬 Video Screen
- Lists all club videos with preview images and short descriptions
- Videos open in a **built-in player** (no redirect to external apps)

### 🏟️ Matches Screen *(most complex section)*
Real-time match data delivered via **Server-Sent Events (SSE)** from the back-end.

| Sub-section | Description |
|---|---|
| **Upcoming Match** | Countdown timer, league name, team logos & names. Tap for a full details dialog (date, time, venue, teams, league). |
| **Upcoming Matches** | Full list of future fixtures. Tap any match for a detailed dialog. |
| **Previous Matches** | Past results sorted newest → oldest. Tap to open the Match Screen. |
| **Match Screen** | Full match details: result, league, date/time, venue, event timeline, team lineups, and comments. |

### 💬 Forum Page
- First-time visitors choose a username
- Displays community posts with author, date, title, excerpt, tags, and comment count
- Posts can be **sorted** by creation date or most recent, and **filtered** by tags
- **Forum Screen**: full post view with hierarchical comments (users can reply to replies)
- Each comment shows how many replies it has; reply threads can be toggled open/closed

### ⚙️ Settings Screen
| Setting | Description |
|---|---|
| **Username** | View and edit your in-app username |
| **Notifications** | Toggle push notifications on/off |
| **Delete Offline Data** | Clear all cached posts, videos, matches, and other locally stored data |
| **Refresh Connection** | Manually re-sync with the server to get the latest data |

---

## 🖥️ Back-End (Python + Node.js / TypeScript)

All services communicate over an **internal Docker network**.

### 🔀 API Services *(Node.js / TypeScript)*
Central gateway between the front-end and all back-end services. Handles data distribution and client communication.

### 📰 Posts & Videos Service *(Python)*
Retrieves club posts and video content and forwards the data to the API service.

### 🏆 Slavia-A Match Service *(Python)*
The most complex back-end component:
- Fetches, stores, and filters match data for the **Slavia A-team**
- Performs a **daily check** for scheduled matches
- When a match day is detected, triggers `Live_Match`, which:
  - Continuously retrieves and evaluates live match data
  - Stores updates in real time
  - Pushes notifications to the front-end via **SSE** on any data change

### 🔁 Slavia-B / Slavia U-19 / Slavia-Woman Services *(Python)*
Each of these mirrors the Slavia-A service architecture but handles data for their respective teams — covering retrieval, storage, and filtration independently.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Mobile App | Flutter (Dart) |
| API Gateway | Node.js + TypeScript |
| Data & Match Services | Python |
| Real-time Updates | Server-Sent Events (SSE) |
| Containerization | Docker |
| Inter-service Network | Docker internal network |

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Docker](https://www.docker.com/) & Docker Compose
- Node.js & npm
- Python 3.x

### Run the Back-End

```bash
cd Backend
docker compose up --build
# For older Docker versions: docker-compose up --build
```

### Run the Front-End

```bash
cd Frontend/slavia_app
flutter pub get
flutter run
```

---

## 📸 Screenshots

*Coming soon — screenshots of the Introduction Screen, Matches Screen, and Forum Page.*

