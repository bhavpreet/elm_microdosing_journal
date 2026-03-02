# Flutter BLE & Health Ecosystem Research

> **Date:** March 2026
> **Purpose:** Supplementary research for framework comparison — detailed analysis of Flutter's BLE, health data, EEG, offline-first sync, and state management ecosystem.

---

## Table of Contents

1. [Flutter BLE Libraries](#1-flutter-ble-libraries)
2. [Flutter Health Data (HealthKit + Health Connect)](#2-flutter-health-data-healthkit--health-connect)
3. [Flutter EEG / Muse Headband](#3-flutter-eeg--muse-headband)
4. [Flutter Offline-First Sync & Local Databases](#4-flutter-offline-first-sync--local-databases)
5. [Flutter State Management: Elm Architecture Alignment](#5-flutter-state-management-elm-architecture-alignment)
6. [Summary: Flutter vs React Native for This Project](#6-summary-flutter-vs-react-native-for-this-project)

---

## 1. Flutter BLE Libraries

### flutter_blue_plus

**Current State:** Actively maintained as of late 2025 by Chip Weinberger. It has moved to a federated plugin architecture with sub-packages for Android, Darwin (iOS/macOS), Linux, Web, and a platform interface. It supports iOS, macOS, Android, Linux, and Web. Windows support is available via a separate package (`flutter_blue_plus_winrt`). The library has zero dependencies beyond Flutter and the platform SDKs themselves, which contributes to its stability.

**API Quality:** The API is mature and well-documented. Key capabilities include:
- Scanning with service UUID filters (e.g., `withServices: [Guid('180D')]` for heart rate)
- `device.connect()` / `device.disconnect()`
- `device.discoverServices()` returning full GATT service/characteristic trees
- `characteristic.setNotifyValue(true)` and stream-based listeners for notifications
- `device.mtuNow` for synchronous MTU reads
- Streams never emit errors or close (except `scanResults`), simplifying error handling

**Heart Rate Profile Parsing:** Standard BLE Heart Rate Profile is straightforward. The Heart Rate Service UUID is `0x180D`, and the Heart Rate Measurement characteristic UUID is `0x2A37`. You subscribe to notifications on that characteristic and parse the raw bytes per the Bluetooth SIG spec. The library does not do profile-level parsing for you — you receive raw bytes and must decode the flags byte + heart rate value yourself, but this is well-documented in community tutorials.

**Auto-Reconnect:** The `autoConnect: true` parameter on `device.connect()` enables automatic reconnection whenever the device is found. Recent releases greatly improved autoconnect on Android and added iOS support. On Android, autoconnect is no longer canceled when Bluetooth is turned off. However, some developers prefer manual reconnection patterns (listening to `connectionState` and re-calling `connect()` on disconnect) for more predictable behavior.

**Background BLE Support:**
- **iOS:** Requires `bluetooth-central` background mode in `Info.plist`. Setting `restoreState: true` before starting BLE work allows the app to be woken up even after being killed by the OS. The app gets approximately 10 seconds to complete tasks when woken.
- **Android:** Best handled with a foreground service using packages like `flutter_foreground_task` or `workmanager`.

**Licensing (Important):** As of 2025, flutter_blue_plus uses a custom license (not BSD/MIT). It is **free** for organizations with fewer than 50 employees, nonprofits, and educational institutions. For-profit organizations with 50+ employees must purchase a **$2,999 commercial license** (perpetual use, 1 year of updates). This is a significant consideration for commercial projects.

### flutter_reactive_ble

**Current State:** Effectively unmaintained or very low maintenance as of early 2026. The latest release is v5.4.0 (around January 2025), which added macOS support and fixed some subscription leaks. However, GitHub issues from throughout 2025 remain open and unanswered, suggesting the Philips Hue team is no longer actively maintaining the project.

**Background BLE:** Historical support exists but has been a pain point. A known issue (#446) reports that BLE state is set to "unknown" when running in background isolates on iOS, complicating background usage.

**Recommendation:** For new projects, **flutter_blue_plus is the clear winner**. flutter_reactive_ble's stalled maintenance makes it a risky choice, despite its historically clean reactive API.

### Sources
- [flutter_blue_plus on pub.dev](https://pub.dev/packages/flutter_blue_plus)
- [flutter_blue_plus GitHub](https://github.com/chipweinberger/flutter_blue_plus)
- [flutter_blue_plus changelog](https://pub.dev/packages/flutter_blue_plus/changelog)
- [flutter_blue_plus license](https://pub.dev/packages/flutter_blue_plus/license)
- [flutter_reactive_ble on pub.dev](https://pub.dev/packages/flutter_reactive_ble)
- [flutter_reactive_ble GitHub Issues](https://github.com/PhilipsHue/flutter_reactive_ble/issues)
- [Advanced BLE Development with Flutter Blue Plus (Medium)](https://medium.com/@sparkleo/advanced-ble-development-with-flutter-blue-plus-ec6dd17bf275)

---

## 2. Flutter Health Data (HealthKit + Health Connect)

### The `health` Plugin

The primary package (`health` on pub.dev) wraps Apple HealthKit on iOS and Google Health Connect on Android. Google Fit support was removed as of v11.0.0, since Google deprecated the Fit API (new signups blocked since May 2024).

**Capabilities:**
- Permission handling: `hasPermissions`, `requestAuthorization`, `revokePermissions`
- Reading: `getHealthDataFromTypes`
- Writing: `writeHealthData`, `writeMeal`
- Workout routes: `startWorkoutRoute` / `insertWorkoutRouteData` / `finishWorkoutRoute`
- Getting data by UUID, unit conversion support for weight/height/temperature/blood glucose
- iOS-specific types: `APPLE_STAND_TIME`, `APPLE_STAND_HOUR`, `APPLE_MOVE_TIME` (read-only)

**Key Limitations:**

1. **iOS read permission opacity:** HealthKit intentionally returns `unknown` for read permission status (a privacy feature, not a bug). You must infer permission by attempting a minimal read and catching `AuthorizationException`.
2. **No server-side API for HealthKit:** All Apple Health data stays on-device. Syncing to a backend is entirely your responsibility — you must build the mobile sync layer, handle background updates, manage network failures, etc.
3. **Duplicate data:** Requesting the same data multiple times can produce duplicates that you must deduplicate yourself.
4. **Platform-specific data types:** Some types are iOS-only (e.g., `APPLE_STAND_TIME`) and some are Android-only (e.g., `DISTANCE_DELTA`). Cross-platform apps need conditional logic.
5. **Health Connect Android setup:** Requires specific `AndroidManifest.xml` entries including a privacy policy activity that Health Connect can deep-link to.
6. **Multi-device aggregation is DIY:** Combining HealthKit with Garmin, Oura Ring, Fitbit, etc. requires standardized integration work.

### Alternative: `health_connector`

A newer package claiming access to 150+ health data types with compile-time type safety, incremental data sync, and privacy-first architecture. Worth evaluating if the `health` plugin's limitations are problematic.

### Sources
- [health on pub.dev](https://pub.dev/packages/health)
- [health changelog](https://pub.dev/packages/health/changelog)
- [health_connector on pub.dev](https://pub.dev/packages/health_connector)
- [Integrating Health Connect on Android with Flutter (Medium)](https://medium.com/@256divyasree/integrating-health-connect-on-android-with-flutters-health-plugin-a197ca9e0675)

---

## 3. Flutter EEG / Muse Headband

### No Ready-Made Flutter Package Exists

There is **no dedicated Flutter/Dart library** for the Muse headband or for EEG data in general as of early 2026. The official Muse SDK is native (iOS and Android only), and most community EEG projects are in Python, Java, JavaScript, or C#.

### Viable Integration Approaches

1. **Platform Channels wrapping the native Muse SDK:** The official Muse SDK is available for iOS and Android. You would write native platform channel code on each side to bridge the SDK into Dart. This is the most straightforward approach and gives you access to all official features (EEG, PPG, accelerometer, processed signals, .muse file format).

2. **Direct BLE communication via flutter_blue_plus:** The Muse BLE GATT protocol has been reverse-engineered by the community (documented by Alexandre Barachant and others). You could connect to the Muse headband directly using flutter_blue_plus and parse the raw EEG data packets yourself. This avoids native SDK dependencies but requires implementing the protocol parsing.

3. **BrainFlow via Dart FFI:** BrainFlow is a C/C++ library supporting many EEG devices including Muse. It has official bindings for Python, C++, Java, C#, Julia, Matlab, R, TypeScript, and Rust — but **not Dart**. However, since BrainFlow exposes a C API, you could use `dart:ffi` with `package:ffigen` to auto-generate Dart bindings from BrainFlow's C headers. This is a significant custom integration effort but gives you access to BrainFlow's signal processing capabilities and support for multiple EEG devices.

### BrainBit on pub.dev

There is a publisher (`brainbit.com`) on pub.dev providing Flutter packages for BrainBit-specific EEG hardware — but this is a different product from the Muse headband.

### Sources
- [Muse SDK Partners](https://choosemuse.com/pages/sdk-partners)
- [Reverse-Engineering Muse BLE Protocol](https://alexandre.barachant.org/blog/2017/01/27/reverse-engineering-muse-eeg-headband-bluetooth-protocol.html)
- [BrainFlow](https://brainflow.org/)
- [BrainFlow Supported Boards](https://brainflow.readthedocs.io/en/stable/SupportedBoards.html)
- [muse-headband GitHub topic](https://github.com/topics/muse-headband)
- [Dart FFI documentation](https://docs.flutter.dev/platform-integration/bind-native-code)

---

## 4. Flutter Offline-First Sync & Local Databases

### PowerSync Flutter SDK

**Current version:** v1.17.0 (December 2025). Actively maintained with regular releases throughout 2025.

PowerSync is a sync engine that keeps a backend database (Postgres, MongoDB, MySQL beta, SQL Server alpha) in sync with on-device SQLite databases. Key features:
- **Real-time streaming:** Changes are instantly streamed to all clients
- **Local SQLite database:** Reads and writes are instant, no network calls needed
- **Background execution:** DB operations run off the main thread
- **Live query subscriptions:** UI stays reactive and up-to-date
- **Automatic schema management:** Client-defined schema via SQLite views; no explicit client-side migrations needed
- **Attachment utilities** for file sync

The v1.17.0 release made the Rust-based sync client the default (improved performance), added `getCrudTransactions()` for batching upload operations, and introduced alpha sync streams for more dynamic sync.

PowerSync is open-source/source-available with a self-hosted Enterprise edition. It requires connecting your source database to the PowerSync Service and deploying Sync Rules.

### Drift (formerly Moor)

The **default recommended** SQLite-based local database for Flutter in 2025. Current version: ~2.26.0.

- **Type-safe** tables and queries generated at build time
- **Reactive API** via Dart Streams, integrates cleanly with Riverpod, BLoC, or Provider
- **Cross-platform** (Android, iOS, desktop, web via different backends)
- **Built-in migration support** with `schemaVersion` hooks
- **Encryption** via `sqlcipher_flutter_libs` (AES-256)
- Actively maintained by Simon Binder with excellent documentation

Drift is ideal for complex, structured, relational data where query safety and robust migrations matter.

### Isar

**Status: Effectively abandoned by its original author.** The core is written in Rust, making it difficult for the Flutter community to fork and maintain. Community forks exist but the maintenance situation is precarious. Despite being technically impressive (ACID support, full-text search, isolate support, schema changes), **Isar is not recommended for new projects** due to abandonment risk.

### Other Options

| Database | Notes |
|---|---|
| **ObjectBox** | Fast NoSQL with integrated sync. Good performance but not fully open-source. |
| **Hive CE** | Community-maintained fork of abandoned Hive. Pure Dart (all platforms including web). Best for simple key-value storage. |
| **Floor** | Lightweight SQLite ORM, lower learning curve than Drift but less actively maintained. No web support. |
| **Sembast** | NoSQL for medium-sized apps needing flexibility without SQL complexity. |
| **sqflite** | Raw SQLite access. No abstractions or code generation — you write SQL strings directly. |

### Recommended Stack for a Journal App

For a microdosing journal with offline-first sync: **Drift for local persistence + PowerSync for cloud sync** is the strongest combination. Drift gives you type-safe local queries, and PowerSync handles the sync complexity with your backend database.

### Sources
- [PowerSync Dart/Flutter SDK docs](https://docs.powersync.com/client-sdks/reference/flutter)
- [powersync on pub.dev](https://pub.dev/packages/powersync)
- [PowerSync Product Updates](https://releases.powersync.com/?date=2025-12-01)
- [PowerSync GitHub](https://github.com/powersync-ja/powersync.dart)
- [Drift guide (Apparence Kit)](https://apparencekit.dev/flutter-tips/local-database-flutter-drift-guide/)
- [Best Local Database for Flutter Apps](https://dinkomarinac.dev/best-local-database-for-flutter-apps-a-complete-guide)
- [Flutter databases overview 2025 (greenrobot)](https://greenrobot.org/database/flutter-databases-overview/)
- [Hive vs Drift vs Floor vs Isar 2025](https://quashbugs.com/blog/hive-vs-drift-vs-floor-vs-isar-2025)

---

## 5. Flutter State Management: Elm Architecture Alignment

### Dartea — The Elm Architecture (TEA) for Flutter

[Dartea](https://github.com/p69/dartea) is a direct implementation of TEA/MVU (Model-View-Update) for Flutter. It enforces:
- **Immutable app state (Model)**
- **Pure View and Update functions**
- **Side-effects isolated via Commands and Subscriptions**
- **Closed-loop unidirectional data flow** — dispatching a message is the only way to mutate state

The downside: Dartea appears to be an older, low-activity project. It demonstrates the pattern well but may not be production-ready for a modern Flutter app.

### BLoC — The Closest Production-Ready Match

BLoC is conceptually the closest mainstream pattern to TEA:

| TEA Concept | BLoC Equivalent |
|---|---|
| Message (Msg) | Event |
| Model | State |
| Update function | `mapEventToState` / `on<Event>` handler |
| View | `BlocBuilder` widget |
| Command (side-effect) | Emitting new states after async work in event handlers |
| Subscription | `BlocListener` / `BlocConsumer` |

BLoC enforces **unidirectional data flow** and **event-driven state transitions**, which maps closely to TEA's "dispatch a message → pure update function → new state → re-render" cycle. The 2025 updates reduce boilerplate and improve DevTools support. The ecosystem is mature: `hydrated_bloc` provides state persistence (useful for offline-first), and `bloc_concurrency` controls event processing order.

**Key difference from TEA:** BLoC uses Dart Streams internally (reactive/async), while TEA is conceptually synchronous with explicit side-effect separation. BLoC also does not enforce purity of the update function — side effects can happen inside event handlers.

### Riverpod — More Flexible, Less TEA-Like

Riverpod 3 (2025) is the most popular state management solution overall. It is more flexible and less opinionated than BLoC:
- `Notifier` and `AsyncNotifier` classes manage state
- `@riverpod` code generation reduces boilerplate
- Does not require `BuildContext` for state access
- Excellent for dependency injection and modular architecture

Riverpod does not enforce a strict event/message pattern like TEA. State mutations happen via method calls on notifiers rather than dispatched messages. This makes it less TEA-like but more pragmatic for many use cases.

### Signals — Lightweight, Not TEA-Like

Flutter Signals (introduced late 2024) are a reactive primitive inspired by SolidJS. They are lightweight and great for local UI state but lack the structured event/message dispatch that TEA requires. Not recommended if you want Elm-like architecture.

### Recommendation for an Elm-Inspired Architecture

**BLoC** is the best production-ready choice if you want Elm Architecture principles in Flutter. It gives you:
- Explicit events (messages) as the only way to trigger state changes
- Immutable state objects
- Testable, predictable state transitions
- A large ecosystem and active maintenance
- `hydrated_bloc` for automatic state persistence (valuable for a journal app)

If you want to go even more purely TEA, you could use BLoC as the foundation but enforce additional discipline: make all event handlers pure functions that return `(State, List<SideEffect>)` tuples, and process side effects separately.

### Sources
- [Dartea - TEA for Flutter (GitHub)](https://github.com/p69/dartea)
- [Flutter State Management 2025: Riverpod vs Bloc vs Signals (Medium)](https://nurobyte.medium.com/flutter-state-management-in-2025-riverpod-vs-bloc-vs-signals-8569cbbef26f)
- [Flutter State Management Tool 2025: Riverpod 3 vs Bloc (Creole Studios)](https://www.creolestudios.com/flutter-state-management-tool-comparison/)
- [Understanding BLoC Architectural Pattern (Stackademic)](https://blog.stackademic.com/understanding-the-bloc-architectural-pattern-in-flutter-4f278959a5d2)
- [Flutter Common Architecture Concepts (official docs)](https://docs.flutter.dev/app-architecture/concepts)
- [Flutter and Dartea (Medium)](https://medium.com/flutter-community/flutter-and-dartea-create-mobile-application-with-pleasure-c1866ff2b4d4)

---

## 6. Summary: Flutter vs React Native for This Project

### Head-to-Head Comparison (Updated)

| Concern | Flutter | React Native (Expo) | Winner |
|---|---|---|---|
| **BLE library** | flutter_blue_plus (active, custom license) | react-native-ble-plx (MIT, production-proven) | **Tie** — both strong. RN wins on licensing (MIT vs $2,999 commercial). |
| **BLE background** | iOS bg mode + foreground service | iOS bg mode + foreground service | **Tie** — same OS capabilities |
| **HealthKit** | `health` plugin (mature) | `react-native-health` (mature) | **Tie** |
| **Health Connect** | `health` plugin (mature) | `react-native-health-connect` (mature) | **Tie** |
| **EEG (Muse)** | No library — platform channels or BLE reverse-eng | muse-js (Web Bluetooth) + EEG-101 (proven) | **React Native** — proven EEG ecosystem |
| **Local DB** | Drift (type-safe, reactive, encrypted) | expo-sqlite / WatermelonDB | **Flutter** — Drift is best-in-class |
| **Offline sync** | PowerSync Flutter SDK (v1.17) | PowerSync React Native SDK | **Tie** — same service, both supported |
| **Elm Architecture** | BLoC (close match, requires discipline) | useReducer (IS the Elm Architecture) | **React Native** — closer fit by design |
| **Web deployment** | Flutter Web (large bundles, SEO concerns) | React Native Web + Expo Router | **React Native** — lighter, better SEO |
| **Desktop** | Excellent (Win/Mac/Linux stable) | Good (MS-backed Win/Mac) | **Flutter** — more mature desktop |
| **Hot reload** | Best-in-class | Excellent | **Flutter** — slight edge |
| **Community size** | Very large | Largest | **React Native** — slight edge |

### Key Findings

1. **Flutter is a viable alternative** — the BLE, health data, and offline-first ecosystem is mature and well-maintained.
2. **The EEG gap is significant** — no Flutter Muse library exists, requiring custom platform channel work or BLE reverse-engineering. React Native has proven solutions (muse-js, EEG-101).
3. **flutter_blue_plus's licensing** is a consideration — free for small teams but $2,999 for larger organizations. react-native-ble-plx is MIT-licensed.
4. **Drift is genuinely excellent** — arguably the best local database solution in either ecosystem, with superior type safety and migration support.
5. **BLoC maps well to TEA** but requires more discipline than React's `useReducer`, which is literally the Elm Architecture by design.
6. **The recommendation stands: React Native (Expo)** for this project, primarily due to the closer Elm Architecture alignment, proven EEG ecosystem, and better web deployment story. However, Flutter would be a strong second choice, especially if desktop support is prioritized.

---

*This document supplements NATIVE_APP_RECOMMENDATION.md with detailed Flutter ecosystem research.*
