# 🪟 Glaze - Professional Window Measurement & Enquiry System

[![Flutter](https://img.shields.io/badge/Flutter-v3.10+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Realtime-FFCA28?logo=firebase&logoColor=white)](https://firebase.google.com)
[![SQLite](https://img.shields.io/badge/SQLite-Offline--First-003B57?logo=sqlite&logoColor=white)](https://sqlite.org)
[![License: Proprietary](https://img.shields.io/badge/License-Proprietary-red)](LICENSE)

**Glaze** is a high-performance, professional-grade Flutter application designed for precision window measurement, customer enquiry tracking, and automated work agreement generation. Built with a robust **offline-first** architecture, it ensures seamless operation in the field with secure background cloud synchronization.

---

## 🚀 Key Features

### 📐 Precision Measurement Engine
- **Dynamic Calculation**: Automated SqFt calculations based on configurable divisors.
- **L-Corner Support**: Advanced formulas (A & B) for complex corner window geometry.
- **Multi-Unit Management**: Handle quantities, on-hold status, and detailed window-specific notes.

### 📝 Smart Enquiry Tracking
- Full lifecycle management of customer leads and enquiries.
- Reminder dates and status tracking (Pending, Completed, etc.).
- Location-based customer profiling.

### 📄 Document Automation
- **Work Agreements**: Instant generation of professional PDF agreements.
- **Digital Sharing**: Export and share measurements or agreements via WhatsApp, Email, or internal system sharing.

### 🛡️ Enterprise-Grade Reliability
- **Offline-First**: Full functionality without internet; data resides in a local SQLite vault.
- **Cloud Sync**: 5-minute background sync cycles pushing data to Firebase Firestore.
- **System Guard**: Integrated licensing system with a 7-day grace period for offline use.

---

## 🏗️ Technical Architecture

### Tech Stack
- **Framework**: Flutter (Dart)
- **Local Database**: SQLite (`sqflite`)
- **Cloud Backend**: Firebase (Firestore, Core)
- **State Management**: Provider (Architected for scalability)
- **Theming**: Premium Design System with dynamic HSL-based palettes & Glassmorphism.

### Data Flow Logic
Glaze employs a **Local-First / Cloud-Pushed** strategy:
1. **Local Write**: Every action (Create/Update/Delete) is first committed to the local SQLite database with a `sync_status` flag.
2. **Background Sync**: The `SyncService` monitors connectivity and periodically batches "dirty" records to Firebase Firestore.
3. **Optimistic UI**: The `AppProvider` uses a local cache for windows and customers to ensure zero-latency UI updates while waiting for DB/Cloud confirmation.

### Core Calculation Logic
The `WindowCalculator` uses a modular approach:
- **Standard**: `(Width * Height * Quantity) / Divisor`
- **L-Corner Formula A**: `((Width + Width2) * Height * Quantity) / Divisor`
- **L-Corner Formula B**: `((Width * Height) + (Width2 * Height)) * Quantity / Divisor`

---

## 📂 Project Structure

```text
lib/
├── config/         # App constants and static configurations
├── core/           # Core platform-level utilities
├── data/           # Hardcoded data sets and templates
├── db/             # SQLite Helper and migrations (v7 current)
├── models/         # PODOs (Plain Old Dart Objects) for Data Models
├── providers/      # State Management (App & Settings)
├── screens/        # Feature-based UI Modules
├── services/       # External services (Firebase, Sync, License, Logger)
├── ui/             # Global Theme Data & Design System
├── utils/          # Calculation, Permssions, and Helper utilities
└── widgets/        # Reusable Atomic UI Components
```

---

## 🔒 Security & Licensing

The app includes a sophisticated `LicenseService` that determines access based on:
- **Server-Side Status**: Remote lock/unlock capability via Firebase.
- **Grace Period**: Users can remain offline for up to 7 days before the `SystemGuard` enforces a mandatory cloud check.
- **Device ID Binding**: Licenses are bound to unique hardware identifiers to prevent unauthorized distribution.

---

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK `^3.10.4`
- Firebase Project setup with `google-services.json` (Android) or `GoogleService-Info.plist` (iOS).

### Installation
1. Clone the repository.
2. Run `flutter pub get`.
3. Configure your Firebase project using the FlutterFire CLI.
4. Run `flutter run`.

---

© 2026 Glaze. All rights reserved.
