# 🚀 TaskFlow: High-Performance Task Management

**TaskFlow** is a premium, industrial-grade task management solution built with Flutter. It demonstrates a mastery of **Clean Architecture**, **State Management**, and **Offline-First Resilience** within a high-fidelity dark-themed design system.

---

## 🏗️ Architectural Blueprint (Clean Architecture)

TaskFlow is architected with strict layer boundaries to ensure zero leakage of implementation details into the business logic.

```mermaid
graph TD
    subgraph Presentation_Layer [Presentation Layer - BLoC]
        UI[Flutter Widgets] -->|Events| BLOC[Feature BLoCs]
        BLOC -->|States| UI
    end

    subgraph Domain_Layer [Domain Layer - Pure Business Logic]
        BLOC -->|Execute| UC[Use Cases]
        UC -->|Interact| E[Entities]
        UC -->|Contract| RI[Repository Interfaces]
    end

    subgraph Data_Layer [Data Layer - Infrastructure]
        RI -->|Implement| R[Repository Implementation]
        R -->|Network| RDS[Remote Data Source - Dio]
        R -->|Persistence| LDS[Local Data Source - Sqflite]
        R -->|Secure| SS[Secure Storage]
    end

    style Domain_Layer fill:#f9f,stroke:#333,stroke-width:2px
    style Data_Layer fill:#bbf,stroke:#333,stroke-width:2px
    style Presentation_Layer fill:#bfb,stroke:#333,stroke-width:2px
```

### 🎯 Strategic Layer Abstraction
- **Manual Value Equality**: To keep the **Domain Layer** 100% pure, we manually override `operator ==` and `hashCode` for all entities, removing dependencies like `Equatable`.
- **Dependency Inversion**: Use cases depend on abstract repository contracts, allowing the infrastructure (Data Layer) to be swapped without touching business logic.

---

## 💾 The "Ironclad" Offline-First Strategy

TaskFlow ensures productivity remains uninterrupted by implementing a sophisticated synchronization and fallback mechanism.

```mermaid
sequenceDiagram
    participant UI as Presentation (BLoC)
    participant Repo as Repository Implementation
    participant Remote as Remote Source (Dio/Mock)
    participant Local as Local DB (Sqflite)

    UI->>Repo: Request Data (e.g., GetTasks)
    
    rect rgb(200, 255, 200)
    Note over Repo, Remote: Try Online Path
    Repo->>Remote: Fetch Remote Data
    Remote-->>Repo: Success (JSON)
    Repo->>Local: Persist/Sync Data
    Repo-->>UI: Return Domain Entities
    end

    rect rgb(255, 200, 200)
    Note over Repo, Local: Error/Offline Path
    Remote-->>Repo: Failure (Timeout/No Net)
    Repo->>Local: Fetch Last Known State
    Local-->>Repo: Return Cached Data
    Repo-->>UI: Return Entities (Offline Mode)
    end
```

---

## 🛠️ Advanced Tech Stack & Implementation

| Technology | Implementation Depth |
| :--- | :--- |
| **State Management** | **BLoC (flutter_bloc)**: Reactive event-driven architecture with dedicated states for Loading, Success, and failure-handling with previous state retention. |
| **Dependency Injection** | **GetIt**: Optimized wiring using `LazySingletons` for services and `Factories` for UI-bound logic. |
| **Networking** | **Dio**: High-performance HTTP client with interceptor support and custom error mapping to Domain-level Failures. |
| **Local DB** | **Sqflite**: Relational persistence with indexed columns for performant project/task filtering. |
| **Secure Storage** | **AES Encryption**: Sensitive session tokens stored via `EncryptedSharedPreferences` on Android. |
| **Navigation** | **GoRouter**: Declarative, URL-based routing with deep-link support and Auth-guarded redirects. |

---

## 🧪 Testing & Reliability

TaskFlow is verified by a comprehensive test suite that treats the Domain and Data layers as mission-critical systems.

- **40+ Automated Tests**: Covering full CRUD lifecycle and Auth edge cases.
- **Contract Verification**: Ensuring Repository implementations correctly transform Models to Entities.
- **State Transition Testing**: Using `bloc_test` to verify UI logic under extreme conditions (e.g., refreshing expired sessions).

```bash
# Run the complete test suite
flutter test
```

---

## 🎨 Design System: "Industrial Dark"

The UI is built on a custom design system characterized by:
- **Diagonal "Cut Corner" Borders**: A signature industrial aesthetic applied to cards, buttons, and sheets.
- **High-Contrast Palette**: Utilizing **Lime (#D4FF3D)** for primary actions and **Deep Carbon (#0B0C0E)** for backgrounds.
- **Dynamic Typography**: Leveraging `google_fonts` (Bebas Neue & Inter) for a professional, dashboard-centric feel.

---

## 🔐 Mock Access

| Role | Email | Password |
| :--- | :--- | :--- |
| **Org Admin** | `ava.admin@nimbusdigital.test` | `Password123!` |
| **Member** | `marcus.member@nimbusdigital.test` | `Password123!` |

---
Developed as a showcase of modern Flutter engineering.
