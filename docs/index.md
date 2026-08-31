# Smart Blood Bank System

Documentation for our graduation project at JUST — Computer Engineering, 2026.

---

[![Status](https://img.shields.io/badge/Status-In%20Development-orange?style=flat-square)](https://github.com/AwsAlkhateeb/blood-bank)
[![University](https://img.shields.io/badge/JUST-Computer%20Engineering-blue?style=flat-square)](https://www.just.edu.jo)
[![Stack](https://img.shields.io/badge/Stack-Flutter%20%7C%20ASP.NET%20%7C%20PostgreSQL-red?style=flat-square)](#)

---

## What is this?

Blood donation in Jordan still runs on paper. No central system, no way to search for donors quickly, no alerts when a hospital runs out of a blood type. When someone needs blood urgently, hospitals make phone calls one by one — which wastes time nobody has.

We decided to fix that. Our project is a web and mobile app that connects donors, hospitals, and blood banks in one place.

## What it does

- **Blood Credit System** — when you donate, you get credits. You can give those credits to a family member or friend if they ever need blood.
- **Shortage alerts** — if a hospital is running low on a specific blood type, the system sends notifications to nearby donors who match.
- **Cross-region donation** — you can donate in your city and transfer the credit to someone who needs it somewhere else in Jordan.
- **Truck tracking** — real-time tracking for blood transport between banks so supply goes where it's actually needed.

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile & Web | Flutter / Dart |
| Backend API | ASP.NET Core / C# |
| Database | PostgreSQL |
| Deployment | Docker + AWS + GitHub Actions |
