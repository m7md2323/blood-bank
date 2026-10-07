# Progress by 7-October-2026

## Summary :
For the backend: we are now designing the Domain layer, its expected to be finished by 9-10/10/2026.
For the frontend: below are the pages so far partially implemented:

1. AdminScreen
2. BloodWalletScreen
3. HomePage
4. LoginScreen
5. MapScreen
6. SignupScreen
7. AllTransactionsScreen
8. NotificationScreen

> **Current phase:** Iteration 1 → Implementation

---

## SDLC — Iteration 1

| Phase | Status |
|---|---|
| Requirements | ✅ Done |
| Design | ✅ Done |
| Implementation | 🔄 In Progress |
| Testing | ⬜ Pending |
| Deployment | ⬜ Pending |

Iteration 2 begins after feedback and review from Iteration 1.

---

## Summary of Work Built So Far

* **Backend Architecture:** Successfully scaffolded a complete ASP.NET Core solution using **Clean Architecture** (`Domain`, `Application`, `Infrastructure`, `Web`).
* **Domain Layer (Core Logic):** Modeled all essential business entities (`User`, `BloodBank`, `Hospital`, `BloodUnit`, `Donation`, etc.) and mapped their complex relationships. Built strictly to the **Jordanian Ministry of Health rules** (handling National IDs, exact donation intervals based on component type and gender).
* **Data Access Contracts:** Engineered a repository pattern by defining generic `IRepository<T>`, specific interfaces (e.g., `IUserRepository`, `IHospitalRepository`), and an atomic `IUnitOfWork` interface to guarantee safe database transactions. 
* **Frontend (Flutter):** The mobile application layout is underway. The `Signup`, `Login`, and `Blood Wallet` screens have been built with HTTP service integrations prepared for the backend API.
* **Documentation:** Detailed API definitions, user flows, and project progress tracking have been documented centrally to sync the frontend and backend teams.

---

## Completed

- [x] Initial project idea and proposal
- [x] Tech stack selection (Flutter, ASP.NET Core, PostgreSQL)
- [x] GP1 Final Report and Presentation
- [x] Familiarization with tech stack across all team members
- [x] Setting up the centralized documentation site
- [x] Scaffold the ASP.NET Core Clean Architecture backend project
- [x] Design Domain Entities and Enums
- [x] Designed some frontend pages (First iteration).

## In Progress

- [ ] Define Repository Interfaces (Domain Layer)
- [ ] Finish the Domain layer (First iteration)
- [ ] Start Implementing the Application Layer Services and DTOs

## To Do

- [ ] Set up EF Core DbContext and Code-First Migrations (Infrastructure Layer)
- [ ] Scaffold the Flutter frontend project structure
- [ ] Implement secure authentication and login flows
- [ ] Setting up GitHub Actions CI/CD pipelines
- [ ] Host and deploy using Docker and AWS.