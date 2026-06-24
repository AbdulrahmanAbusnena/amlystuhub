# amlystuhub

A centralized, performance-driven student platform designed for managing academic tasks, program tracking, and collaborative project environments. Built with Flutter Web, this application prioritizes a robust engineering architecture, platform-level services, and local persistence to ensure a reliable and secure workspace.

## Project Description

**amlystuhub** is a dedicated utility hub designed to streamline management frameworks for student-led initiatives, academic advocacy, and operational data tracking. Unlike typical web projects that prioritize rapid visual iterations over structural stability, this platform is engineered from the ground up with a strict separation of concerns.

The core infrastructure focuses heavily on a bulletproof **Platform Services layer**, local data persistence models, and foundational security protocols before introducing any user interface components. By utilizing advanced state management via Riverpod and clean architectural boundaries, the platform delivers predictable state mutations, smooth asynchronous data flows, and secure authentication bridges.

### Key Architectural Pillars
* **Platform & Core Infrastructure:** Prioritizes localized data caching and foundational security layers over aesthetic overhead.
* **State Management:** Decoupled business logic leveraging Riverpod to manage application states cleanly and asynchronously.
* **Unified Routing:** Implements standard declarative routing via GoRouter for deterministic navigation guards, auth redirects, and deep-linking setups.
* **Minimalist Design System:** Implements a strict, dark-mode technical aesthetic that adheres completely to centralized ThemeData rules, eliminating hardcoded presentation code.

---

## Prerequisites

Before deploying or running the project locally, ensure your environment meets the following baseline constraints:

* **Flutter SDK:** Stable channel (Version compatible with Dart SDK `^3.12.0`)
* **Java Development Kit:** JDK 17 (Required for internal build tools and continuous deployment integration)

---

## Local Setup Instructions

1. **Clone the repository:**
```bash
   git clone [https://github.com/your-username/amlystuhub.git](https://github.com/your-username/amlystuhub.git)
   cd amlystuhub
