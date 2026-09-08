<h1 align="center">🩸 Smart Blood Bank</h1>

<p align="center">
  A full-stack platform connecting blood donors, hospitals, and blood banks to streamline emergency blood supply in Jordan.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/backend-ASP.NET%20Core-512BD4?style=for-the-badge&logo=dotnet" />
  <img src="https://img.shields.io/badge/mobile-Flutter-02569B?style=for-the-badge&logo=flutter" />
  <img src="https://img.shields.io/badge/database-PostgreSQL-4169E1?style=for-the-badge&logo=postgresql" />
  <img src="https://img.shields.io/badge/deploy-Docker-2496ED?style=for-the-badge&logo=docker" />
</p>

---

## 📖 Table of Contents

- [About the Project](#about-the-project)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [API Documentation](#api-documentation)

---

## 📌 About the Project

> **Problem:** There is currently no electronic system managing blood banks in Jordan, causing delays and disorganization during emergency cases.

**Smart Blood Bank** is a web and mobile platform that automates the blood donation process by connecting three parties:

- 🏥 **Hospitals** — register patients and request blood units
- 🩸 **Blood Banks** — monitor stock levels and coordinate supply
- 🙋 **Donors** — register their blood type and receive donation drive notifications

When a shortage is detected, the system automatically notifies the blood bank and triggers donor outreach to cover the deficit — making the process significantly faster and more reliable.

---

## ✨ Features

- [ ] Donor registration with blood type and contact info
- [ ] Hospital patient registration and blood request portal
- [ ] Real-time blood stock monitoring dashboard
- [ ] Automated shortage alerts and donor notifications
- [ ] Donation drive scheduling and management
- [ ] Role-based access (Donor / Hospital / Blood Bank Admin)
- [ ] Mobile app (Flutter) + Web app

---

## 🛠 Tech Stack

| Layer | Technology |
|-------|------------|
| Mobile/Web Frontend | Flutter (Firebase Hosting) |
| Backend API | ASP.NET Core |
| Database | PostgreSQL |
| Deployment | Docker + Railway |
| CI/CD | GitHub Actions |

---

## 🏗 Architecture

We will be using the Clean Architecture, by jasontaylordev.
Github ref :[Link](https://github.com/jasontaylordev/CleanArchitecture)

```
src/
├── Application/       # Use cases / application logic
├── Domain/            # Core domain entities and interfaces
├── Infrastructure/    # DB, external services, repositories
└── Web/               # ASP.NET Core API controllers & middleware
flutter_app/           # Flutter mobile/web app
```

---

## 📁 Project Structure

```
blood-bank/
├── .github/            # GitHub Actions CI/CD workflows
├── database/           # DB migrations / seed scripts
├── docs/               # Project documentation
├── flutter_app/        # Flutter frontend
├── src/                # ASP.NET Core backend (Clean Architecture)
│   ├── Application/
│   ├── Domain/
│   ├── Infrastructure/
│   └── Web/
├── docker-compose.yml
└── README.md
```

---

## 📚 API Documentation

We will use the built in implementation of .NET for OpenAPI.


---
