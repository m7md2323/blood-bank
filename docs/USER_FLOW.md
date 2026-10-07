# User Flows

This document outlines the standard user flows for different types of users within the Blood Bank Management System.

## 1. Donor User Flow

This diagram illustrates the journey of a blood donor from entering the system to logging out.

```mermaid
graph TD
    A([Enter System]) --> B{Already Registered?}
    
    B -- No --> C[Register Account]
    C --> D[Verify Email/Phone]
    D --> E[Login]
    
    B -- Yes --> E
    
    E --> F([Donor Dashboard])
    
    F --> G{Choose Action}
    
    G -- View Profile --> H[View/Edit Profile Details]
    G -- Donate Blood --> I[Fill Eligibility Questionnaire]
    I --> J{Eligible?}
    J -- Yes --> K[Book Appointment]
    J -- No --> L[View Ineligibility Reason/Cooldown]
    
    G -- View History --> M[View Past Donations & Test Results]
    G -- Request Blood --> N[Submit Blood Request for Self/Family]
    
    H --> F
    K --> F
    L --> F
    M --> F
    N --> F
    
    F --> O([Logout])
    
    style A fill:#4CAF50,stroke:#388E3C,stroke-width:2px,color:white
    style O fill:#F44336,stroke:#D32F2F,stroke-width:2px,color:white
    style F fill:#2196F3,stroke:#1976D2,stroke-width:2px,color:white
```

---

## 2. Staff User Flow

This diagram illustrates the journey of a hospital or blood bank staff member (e.g., Receptionist, Lab Tech).

```mermaid
graph TD
    A([Enter System]) --> B[Login with Staff Credentials]
    B --> C([Staff Dashboard])
    
    C --> D{Choose Module}
    
    D -- Donors --> E[Search / Register / Verify Donors]
    D -- Donations --> F[Record New Physical Donation & Print Labels]
    D -- Lab & Testing --> G[Enter Test Results for Quarantined Units]
    D -- Inventory --> H[View Stock / Update Unit Statuses]
    D -- Hospital Requests --> I[Review & Fulfill Pending Blood Requests]
    
    E --> C
    F --> C
    G --> C
    H --> C
    I --> C
    
    C --> J([Logout])
    
    style A fill:#4CAF50,stroke:#388E3C,stroke-width:2px,color:white
    style J fill:#F44336,stroke:#D32F2F,stroke-width:2px,color:white
    style C fill:#9C27B0,stroke:#7B1FA2,stroke-width:2px,color:white
```
