# Native/Cross-Platform App Stack Recommendation

> You're right — PWA BLE limitations (click-to-pair every time, no background collection, iOS blocks everything) are UX killers. Here's the full analysis and our recommended stack.

---

## Table of Contents

1. [Why Move Beyond PWA](#1-why-move-beyond-pwa)
2. [Framework Comparison](#2-framework-comparison)
3. [Recommendation: React Native (Expo)](#3-recommendation-react-native-expo)
4. [Multi-Device Sync Architecture](#4-multi-device-sync-architecture)
5. [App Store Strategy — Positioning as a Wellness App](#5-app-store-strategy)
6. [Legal & Compliance](#6-legal--compliance)
7. [Recommended Architecture](#7-recommended-architecture)
8. [Phased Roadmap](#8-phased-roadmap)

---

## 1. Why Move Beyond PWA

| PWA Limitation | Native Solution |
|----------------|----------------|
| BLE requires user click + device picker every session | Native BLE auto-reconnects to known devices silently |
| No background sensor collection | Foreground services (Android) + background modes (iOS) |
| Safari/iOS blocks Web Bluetooth entirely | CoreBluetooth works on all iOS devices |
| No HealthKit/Health Connect access | Full native SDK access |
| Service workers killed after ~30 seconds | True background processing with native APIs |
| No push notifications on iOS (unless installed) | Full push notification support |
| Can be evicted from storage by OS | Persistent local database |

**Bottom line**: For a wellness app with BLE sensors, a native app isn't a nice-to-have — it's a requirement for the seamless UX your users expect.

---

## 2. Framework Comparison

### Head-to-Head Matrix

| Criterion | React Native (Expo) | Flutter | Kotlin Multiplatform | Capacitor |
|---|---|---|---|---|
| **BLE Quality** | Strong (`react-native-ble-plx`) | Strong (`flutter_blue_plus`) | Good (`Kable` by JUUL Labs) | Weak (community plugin, buggy auto-reconnect) |
| **BLE Background** | Yes (foreground svc + iOS bg modes) | Yes (foreground svc + iOS bg modes) | Yes (platform-specific `expect`/`actual`) | Problematic (WebView suspends) |
| **HealthKit** | Mature (`react-native-health`) | Mature (`health` plugin) | Manual (Swift interop) | Fragmented, outdated plugins |
| **Health Connect** | Mature (`react-native-health-connect`) | Mature (`health` plugin) | Manual (Jetpack library) | Fragmented |
| **Background Processing** | Good (`react-native-background-fetch`) | Moderate (needs native bridges) | Good (platform-specific) | Poor |
| **EEG/FFT Performance** | Good (native modules + JSI zero-copy) | Good (`dart:ffi` + isolates) | Good (`cinterop`/JNI) | Poor (WebView JS) |
| **App Size** | ~7-15 MB | ~10-20 MB | Native-sized (~5-10 MB) | ~5-15 MB |
| **Hot Reload** | Excellent | Best-in-class | Good | Excellent (web tooling) |
| **Community** | Largest | Very large | Growing (23% market share) | Moderate |
| **Desktop** | Yes (MS-backed Windows/macOS) | Yes (stable Win/Mac/Linux) | Yes (Compose Desktop) | Via Electron (heavy) |
| **Web** | Yes (React Native Web) | Yes (Flutter Web) | Beta (Compose/Wasm) | Native (IS a web app) |
| **Elm/TEA Patterns** | Strong (useReducer, Redux = Elm-inspired) | Good (Dartea, BLoC) | Strong (sealed classes, MVIKotlin) | Via Svelte stores |
| **Learning Curve** | Moderate (JS/TS + React) | Moderate (Dart) | Steep (Kotlin + iOS tooling) | Low (existing web skills) |

### Frameworks NOT Recommended

| Framework | Why Not |
|-----------|---------|
| **.NET MAUI** | No Health Connect support, alpha-stage BLE (Shiny), small community, no web deployment, 15-30 MB app size |
| **Tauri 2.0 Mobile** | BLE plugin is v0.8 (early), zero health plugins, mobile CI/CD not automated, mobile DX has "rough edges" per Tauri team. Excellent for desktop, too immature for mobile health apps |
| **Capacitor** | Weakest BLE (buggy auto-reconnect, no foreground service), WebView suspends in background, health plugins fragmented. Only viable if BLE/sensor requirements are minimal |

---

## 3. Recommendation: React Native (Expo)

### Why React Native over Flutter?

Both are excellent choices. Here's why React Native edges ahead for *this specific project*:

**1. Elm Architecture is native to React**
Redux was literally inspired by Elm. `useReducer` IS the Elm Architecture (Model-View-Update). If you value Elm's patterns, React is the closest mainstream framework:

```typescript
// This IS The Elm Architecture, in React
type Model = { doses: Dose[]; mood: number; hrv: number | null };

type Msg =
  | { type: 'LOG_DOSE'; payload: Dose }
  | { type: 'UPDATE_MOOD'; payload: number }
  | { type: 'HRV_READING'; payload: number };

function update(model: Model, msg: Msg): Model {
  switch (msg.type) {
    case 'LOG_DOSE': return { ...model, doses: [...model.doses, msg.payload] };
    case 'UPDATE_MOOD': return { ...model, mood: msg.payload };
    case 'HRV_READING': return { ...model, hrv: msg.payload };
  }
}

// In your component:
const [model, dispatch] = useReducer(update, initialModel);
```

**2. Proven EEG track record**
NeuroTechX's [EEG-101](https://github.com/NeuroTechX/eeg-101) is a working React Native + Muse headband app with native Java FFT. No equivalent exists in Flutter. The New Architecture's JSI enables zero-copy ArrayBuffer transfers between native signal processing code and JavaScript — critical for real-time EEG.

**3. Proven camera-based heart rate (rPPG)**
The [ReViSe/Veyetals framework](https://arxiv.org/pdf/2206.08748) demonstrates React Native rPPG from face video. Flutter has fingertip-only examples.

**4. Web deployment story**
React Native Web + Expo Router gives you iOS, Android, AND web from one codebase. Your PWA can be a first-class citizen alongside native apps. Flutter Web exists but has larger bundle sizes and SEO concerns.

**5. ReScript option for true Elm-like experience**
[ReScript](https://rescript-lang.org/) is an ML-family language (like Elm's core) that compiles to JavaScript and works with React Native. If you want Elm's strict compiler + React Native's ecosystem, this is the path.

**6. Ecosystem depth**
npm has tens of thousands of React Native packages. The BLE, health data, and background processing libraries are all production-proven at scale (Shopify, Meta, Microsoft use React Native).

### Expo: The Modern React Native

Don't use bare React Native — use **Expo** (SDK 54+):

- **EAS Build**: Cloud builds for iOS/Android without Xcode/Android Studio locally
- **Custom Dev Client**: Your own dev app that includes native modules (BLE, health)
- **Expo Router**: File-based routing that works on iOS, Android, and web
- **OTA Updates**: Push JS-only updates without app store review
- **Config Plugins**: Add native capabilities without ejecting

```
expo install react-native-ble-plx
expo install @config-plugins/react-native-ble-plx
npx expo prebuild  # Generates native projects with BLE configured
npx eas build      # Cloud build for iOS/Android
```

### Key Libraries for This Project

| Need | Library | Maturity |
|------|---------|----------|
| BLE sensors | `react-native-ble-plx` | Production (Expo config plugin available) |
| HealthKit (iOS) | `react-native-health` | Production |
| Health Connect (Android) | `react-native-health-connect` + `expo-health-connect` | Production |
| Background fetch | `react-native-background-fetch` (TransistorSoft) | Industry standard |
| Background BLE | Android foreground service + iOS `bluetooth-central` bg mode | Platform-native |
| Local DB | WatermelonDB or `expo-sqlite` | Production |
| Offline sync | PowerSync SDK for React Native | Production |
| Encryption | `react-native-keychain` + Web Crypto API | Production |
| Camera (rPPG) | `expo-camera` + custom frame processing | Proven in research |
| EEG FFT | Native module (C++/Rust via JSI) | Proven (EEG-101) |
| State management | `useReducer` + context (Elm Architecture) | Built-in |
| Navigation | Expo Router (file-based) | Production |

---

## 4. Multi-Device Sync Architecture

### The Problem

Users expect: "I log a dose on my phone, see it on my tablet, and review trends on my laptop — even if my phone was offline when I logged it."

### Recommended: PowerSync + Supabase (or self-hosted Postgres)

```
┌──────────────────────────────────────────────────────────┐
│                    User's Devices                         │
│                                                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │  Phone   │  │  Tablet  │  │  Desktop │  ← Each has  │
│  │ (RN App) │  │ (RN App) │  │ (Web App)│    local     │
│  │          │  │          │  │          │    SQLite     │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘              │
│       │              │              │                    │
│       └──────────────┼──────────────┘                    │
│                      │                                   │
│              E2E Encrypted                               │
│                      │                                   │
│           ┌──────────▼──────────┐                        │
│           │    PowerSync        │  ← Syncs SQLite        │
│           │    Service          │    across devices       │
│           └──────────┬──────────┘                        │
│                      │                                   │
│           ┌──────────▼──────────┐                        │
│           │   Supabase/Postgres │  ← Source of truth     │
│           │   (self-hostable)   │    (encrypted blobs)   │
│           └─────────────────────┘                        │
└──────────────────────────────────────────────────────────┘
```

**Why PowerSync + Supabase?**

| Criterion | PowerSync + Supabase | Firebase | Realm | CRDTs (Automerge/Yjs) |
|-----------|---------------------|----------|-------|----------------------|
| Offline-first | Yes (local SQLite) | Partial (Firestore cache) | **Deprecated Sept 2025** | Yes |
| React Native SDK | Yes | Yes | Dead | Experimental |
| Self-hostable | Yes (both) | No | N/A | Yes |
| Pricing (5k DAU) | ~$76/mo ($51 PS + $25 Supa) | ~$10/mo | N/A | Free (self-host) |
| Pricing (100k DAU) | ~$475/mo | ~$300/mo | N/A | Free (self-host) |
| E2EE compatible | Yes (encrypt before write) | Yes (encrypt before write) | N/A | Yes (natural fit) |
| Conflict resolution | LWW default, customizable | LWW | N/A | Automatic (CRDT) |
| Query language | SQL (familiar) | Firestore queries | N/A | Custom |
| Health data fit | Excellent (relational) | Good | N/A | Overhead for time-series |

**Why not CRDTs alone?** CRDTs (Automerge, Yjs) are elegant but add per-record metadata overhead that becomes expensive for high-frequency sensor data. A developer building a [CRDT-based React Native app reported increasing lag](https://pd-dev.xyz/blog/my-automerge-crdt-learnings) as history accumulated. CRDTs shine for collaborative text — not for time-series health data.

**Why not Firebase?** Google can read your data (encrypted at rest by Google, not E2E). For health/biometric data, this is a privacy concern. Also, vendor lock-in — no self-hosting.

**Why not MongoDB Realm?** Dead. Atlas Device Sync EOL'd September 30, 2025.

### E2E Encryption Strategy

```
User creates account
  → Generate master key from password (Argon2id)
  → Derive per-device encryption keys (HKDF)
  → Share device keys via QR code scan or encrypted key exchange

All health data:
  → Encrypted client-side (AES-256-GCM) before leaving device
  → PowerSync/Supabase stores encrypted blobs only
  → Receiving devices decrypt and merge locally
  → Server NEVER sees plaintext health data
```

Libraries: `react-native-keychain` for secure key storage, Web Crypto API (via `expo-crypto`) for encryption operations.

### Conflict Resolution Strategy

| Data Type | Strategy | Why |
|-----------|----------|-----|
| Sensor readings (HR, HRV, EEG) | Append-only, no conflicts | Immutable facts — deduplicate by timestamp |
| Journal entries (text) | Last-Write-Wins with timestamp | Simplest; show "edited on [device]" indicator |
| Mood/energy ratings | LWW per field | Last edit wins; user expects this |
| Dose logs | Append-only with dedup | Each log is an event; deduplicate by timestamp + substance |
| Settings/preferences | LWW per field | Simple; last change sticks |

### Alternative: Evolu (Maximum Privacy)

If privacy is the absolute top priority and you're willing to trade ecosystem maturity:

- [Evolu](https://www.evolu.dev/) = React Hooks + SQLite + CRDT + E2EE built-in
- Self-hostable relay server (or use their hosted service)
- Truly local-first — no server required for basic operation
- MIT licensed, open source
- Trade-off: newer project, smaller community, less battle-tested

---

## 5. App Store Strategy

### The Core Principle

**You are building a "wellness protocol tracker" — not a "microdosing app."**

The word "microdosing" is not inherently banned, but it triggers scrutiny. Successful apps in this space lead with legal supplements and frame psychedelics as a secondary, geography-dependent feature.

### What Existing Apps Do (and How They Got Approved)

| App | Store Positioning | Actual In-App Experience |
|-----|-------------------|--------------------------|
| **Houston: For Inner Space** | "Wellness companion to supplements like functional mushrooms, cannabis, and B vitamins" | Full microdosing protocols, psychedelic-specific tracking |
| **Dose: Protocol Tracker** | "TRT, GLP-1, peptides, meds, or stacks" — zero mention of microdosing | Supports any substance protocol |
| **MicroTracker** | "Microdosing tracker for microdoses of any kind" | Straightforward microdosing tracker |
| **Quantified Citizen** | "Mobile health research platform" — citizen science | Hosts Microdose.me study alongside other studies |

**The lesson**: Your App Store listing is your regulatory surface. Your in-app experience can be more explicit.

### App Store Listing Strategy

**Name options** (ranked by safety):
1. "Protocol Tracker" or "[BrandName]: Protocol Tracker" — Safest, trending in biohacker space
2. "[BrandName]: Supplement Journal" — Safe, established category
3. "[BrandName]: Wellness Companion" — Safe, broad
4. "[BrandName]: Microdosing Journal" — Risky, may trigger review

**Description template** (modeled after Houston):

```
A wellness companion for tracking your supplement protocols and daily well-being.

Log functional mushrooms, adaptogens, nootropics, vitamins, and other
supplements. Track your mood, energy, focus, and sleep. Discover patterns
in how your protocols affect your wellness.

Features:
• Protocol scheduling — set reminders for any supplement routine
• Mood & energy journaling — track how you feel throughout the day
• Biometric integration — connect heart rate monitors and wearables
• Sleep insights — sync data from Oura, Fitbit, or Apple Health
• Trend visualization — see correlations between protocols and well-being
• Privacy-first — all data encrypted and stored on your device

Where allowed and available, [AppName] also supports microdosing protocols.

Your data is yours. We never sell, share, or access your health information.
```

**Front-and-center** (screenshots, feature list):
- Mood/energy/focus tracking
- Protocol scheduling and reminders
- Wellness insights and trends
- Sleep and biometric data
- Privacy messaging

**Behind menus** (available in-app but not in store listing):
- Microdosing-specific protocol templates (Fadiman, Stamets, etc.)
- Substance-specific logging fields
- Microdosing community/educational content

### Apple-Specific Guidelines to Navigate

| Guideline | Risk | Mitigation |
|-----------|------|------------|
| **1.4.3** — "Apps that encourage consumption of illegal drugs are not permitted" | HIGH — broad interpretation of "encourage" | Position as neutral tracking tool (like a notebook). Don't recommend substances. Include "consult your physician" disclaimers |
| **1.4.2** — Drug dosage calculators need institutional backing | MEDIUM — if any feature looks like dosage calculation | Avoid auto-calculating doses. Let users manually log amounts. No "recommended dose" features |
| **1.4.1** — Medical apps face scrutiny | LOW — if you don't make health claims | Don't claim the app treats, diagnoses, or prevents conditions |
| **5.1.3** — Health data rules | LOW — if you follow HealthKit rules | Don't use health data for ads. Don't write false data. Include privacy policy |

### Google Play-Specific Requirements (2026)

- **Organization Account required** (not individual developer) for health apps as of January 2026
- **Health Apps Declaration form** must be completed
- **Mandatory disclaimer** in first paragraph: "This app is not a medical device and does not diagnose, treat, or prevent any condition"
- **Health Connect data justification**: Must explain why each data type you request is essential

### Words to AVOID in Store Listing

- Psilocybin, LSD, DMT, MDMA (specific controlled substance names)
- "Treats depression" / "cures anxiety" (therapeutic claims)
- "Recommended dose" / "optimal dosage" (dosage calculation)
- "Get" / "obtain" / "source" (substance acquisition)

### Words That ARE Safe

- Protocol, supplement, stack, nootropic, adaptogen
- Functional mushrooms, lion's mane, cordyceps
- Track, log, journal, record
- Mood, energy, focus, well-being, wellness
- Mindfulness, intention, self-improvement

### Fallback Distribution (If Rejected)

| Channel | Platform | Effort | Reach |
|---------|----------|--------|-------|
| PWA (web app) | All | Already built | High — no approval needed |
| TestFlight | iOS | Low | 10,000 users, must re-upload every 90 days |
| Direct APK | Android | Low | Requires "unknown sources" toggle |
| F-Droid | Android | Medium | Open-source app store, niche audience |
| Trusted Web Activity (TWA) | Google Play | Low | PWA wrapped for Play Store |

---

## 6. Legal & Compliance

### FDA Classification: You're a Wellness App, Not a Medical Device

Per the **January 2026 FDA revised guidance**, your app is NOT a medical device if it:
- Tracks general wellness data (mood, energy, sleep) without diagnosing
- Logs supplements without recommending doses
- Displays values, ranges, trends, and baselines for wellness domains
- Doesn't claim to diagnose, treat, cure, or prevent any disease

**The key principle**: Whether a product is regulated depends on **how the manufacturer promotes it**, not the product's functionality. Your marketing language matters as much as your code.

### Required Disclaimers

Include ALL of these:

```
1. FDA Disclaimer:
"These statements have not been evaluated by the Food and Drug
Administration. This app is not intended to diagnose, treat, cure,
or prevent any disease."

2. Medical Advice Disclaimer:
"The information provided by [AppName] is for general informational
purposes only. Always seek the advice of your physician or other
qualified health provider."

3. Google Play Mandatory (first paragraph of description):
"This app is not a medical device and does not diagnose, treat,
or prevent any condition."

4. Substance Disclaimer:
"This app does not provide, sell, or recommend any controlled
substances. Users are solely responsible for compliance with all
applicable laws in their jurisdiction."

5. Not-a-Substitute Disclaimer:
"Never disregard professional medical advice or delay in seeking
it because of something you have read or accessed through this app."
```

### The Legal Line: Tracking vs. Recommending

| LEGAL (tracking) | LEGALLY RISKY (recommending) |
|---|---|
| User logs what they took, when, and how they feel | App suggests specific dosages of controlled substances |
| App shows mood/energy trends correlated with protocols | App recommends psilocybin for depression |
| Generic protocol schedules ("4 days on, 3 days off") | "You should take X mg based on your weight" |
| Links to published research articles | Substance sourcing information |
| User enters their own substance and amount | App pre-populates controlled substance names and doses |

**You are a journal — a neutral notebook. Not a prescriber.**

### Data Privacy Requirements

| Regulation | Requirement | How to Comply |
|------------|-------------|---------------|
| **HIPAA** (US) | Encryption at rest + in transit, access controls, audit logs | E2EE by default; local-first storage; no server-side plaintext |
| **GDPR** (EU) | Right to portability, right to deletion, data minimization | Export-all and delete-all features; collect only what's needed |
| **Illinois BIPA** | Informed consent for biometric data | Explicit consent screen before collecting HR/HRV/EEG |
| **Washington MHMD Act** | Consumer health data protections | Privacy policy covering health data specifically |

---

## 7. Recommended Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    React Native (Expo)                       │
│                    TypeScript + Elm Architecture             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Presentation Layer                      │   │
│  │  Expo Router (file-based navigation)                 │   │
│  │  React components with useReducer (TEA pattern)      │   │
│  │  Platform: iOS / Android / Web                       │   │
│  └──────────────────────┬──────────────────────────────┘   │
│                         │                                   │
│  ┌──────────────────────▼──────────────────────────────┐   │
│  │              Business Logic Layer                    │   │
│  │  Pure functions: update(model, msg) → model          │   │
│  │  Protocol scheduling, trend analysis, correlations   │   │
│  │  HRV computation (RMSSD, SDNN from RR intervals)    │   │
│  └──────────────────────┬──────────────────────────────┘   │
│                         │                                   │
│  ┌──────────────────────▼──────────────────────────────┐   │
│  │              Data Access Layer                       │   │
│  │                                                      │   │
│  │  ┌────────────┐ ┌────────────┐ ┌─────────────────┐  │   │
│  │  │ Sensor     │ │ Health     │ │ Cloud API       │  │   │
│  │  │ Provider   │ │ Provider   │ │ Provider        │  │   │
│  │  │            │ │            │ │                 │  │   │
│  │  │ BLE HR/HRV │ │ HealthKit  │ │ Oura REST API  │  │   │
│  │  │ BLE EEG    │ │ Health     │ │ Fitbit REST    │  │   │
│  │  │ Camera PPG │ │ Connect    │ │ Whoop REST     │  │   │
│  │  └────────────┘ └────────────┘ └─────────────────┘  │   │
│  │                                                      │   │
│  └──────────────────────┬──────────────────────────────┘   │
│                         │                                   │
│  ┌──────────────────────▼──────────────────────────────┐   │
│  │              Storage & Sync Layer                    │   │
│  │                                                      │   │
│  │  SQLite (local, encrypted with AES-256-GCM)         │   │
│  │  PowerSync (offline-first sync across devices)       │   │
│  │  react-native-keychain (encryption key storage)      │   │
│  │                                                      │   │
│  │  Sync: Local SQLite ←→ PowerSync ←→ Postgres         │   │
│  │  All data encrypted before leaving device            │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Native Module Layer                     │   │
│  │                                                      │   │
│  │  iOS: CoreBluetooth, HealthKit, BackgroundTasks      │   │
│  │  Android: Android BLE, Health Connect, WorkManager   │   │
│  │  Shared: C++/Rust FFT via JSI (EEG signal processing)│   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### State Management: Elm Architecture in React Native

```typescript
// types.ts — The Model
type Model = {
  // Journal
  entries: JournalEntry[];
  currentEntry: JournalEntry | null;

  // Protocols
  activeProtocol: Protocol | null;
  doseLog: DoseLog[];

  // Biometrics
  heartRate: number | null;
  hrvScore: number | null;
  eegBands: EEGBands | null;
  sleepData: SleepSummary | null;

  // Sensors
  bleConnectionStatus: 'disconnected' | 'connecting' | 'connected';
  connectedDevices: BLEDevice[];

  // Sync
  syncStatus: 'synced' | 'syncing' | 'offline' | 'error';
  lastSyncTime: Date | null;

  // UI
  currentScreen: Screen;
  isLoading: boolean;
};

// messages.ts — The Msg type (union of all possible events)
type Msg =
  // Journal
  | { type: 'CREATE_ENTRY' }
  | { type: 'UPDATE_ENTRY'; payload: Partial<JournalEntry> }
  | { type: 'SAVE_ENTRY' }
  // Dosing
  | { type: 'LOG_DOSE'; payload: { substance: string; amount: number; unit: string } }
  | { type: 'START_PROTOCOL'; payload: Protocol }
  // Sensors
  | { type: 'BLE_DEVICE_FOUND'; payload: BLEDevice }
  | { type: 'BLE_CONNECTED'; payload: BLEDevice }
  | { type: 'BLE_DISCONNECTED' }
  | { type: 'HR_READING'; payload: number }
  | { type: 'HRV_READING'; payload: { hr: number; rrIntervals: number[] } }
  | { type: 'EEG_READING'; payload: EEGBands }
  // Cloud data
  | { type: 'OURA_SLEEP_RECEIVED'; payload: SleepSummary }
  | { type: 'SYNC_COMPLETED'; payload: Date }
  | { type: 'SYNC_FAILED'; payload: string };

// update.ts — Pure function, no side effects
function update(model: Model, msg: Msg): Model {
  switch (msg.type) {
    case 'HR_READING':
      return { ...model, heartRate: msg.payload };
    case 'LOG_DOSE':
      return {
        ...model,
        doseLog: [...model.doseLog, {
          ...msg.payload,
          timestamp: new Date(),
          id: generateId()
        }]
      };
    case 'BLE_CONNECTED':
      return {
        ...model,
        bleConnectionStatus: 'connected',
        connectedDevices: [...model.connectedDevices, msg.payload]
      };
    // ... etc
  }
}
```

---

## 8. Phased Roadmap

### Phase 1: Core App (Months 1-3)

**Goal**: Replace and surpass the PWA with a native app.

- React Native (Expo) project setup with Elm Architecture
- Journal entries: mood, energy, focus, creativity ratings
- Dose logging: substance, amount, timestamp, notes
- Protocol scheduling: Fadiman, Stamets, custom
- Local SQLite storage with encryption
- Basic UI: home dashboard, log entry, history, settings
- **Deploy to**: TestFlight (iOS) + Internal Testing (Android)

### Phase 2: Biometric Integration (Months 3-5)

**Goal**: Seamless sensor data collection.

- BLE heart rate monitor integration (Polar H10, etc.)
  - Auto-reconnect to known devices
  - Background HR collection during sessions
  - HRV computation from RR intervals
- HealthKit (iOS) + Health Connect (Android) integration
  - Pull sleep, steps, heart rate history
  - Pull Oura/Fitbit/Whoop data via health stores
- Cloud API integration (Oura REST API as first target)
- Correlation engine: "How does your HRV compare on dose vs. off days?"
- **Deploy to**: App stores (wellness positioning)

### Phase 3: Multi-Device Sync (Months 5-7)

**Goal**: Seamless experience across phone, tablet, desktop.

- PowerSync + Supabase integration
- E2E encryption for all synced data
- Web app deployment (React Native Web via Expo Router)
- Conflict resolution for offline edits
- Device management UI (see connected devices, revoke access)

### Phase 4: Advanced Biometrics (Months 7-10)

**Goal**: EEG and advanced sensor integration.

- Muse headband EEG integration via BLE
  - Real-time alpha/beta/theta/gamma visualization
  - Meditation quality scoring
  - Pre/post dose EEG comparison
- Camera-based rPPG (zero-hardware heart rate check)
- Advanced trend analysis and insights
- Export data (CSV, JSON, FHIR-compatible)

### Phase 5: Community & Growth (Months 10+)

**Goal**: Network effects and retention.

- Anonymous community insights ("85% of users report improved focus on Fadiman protocol")
- Protocol sharing (share custom protocols, anonymized)
- Reminders and notification system
- Widgets (iOS/Android home screen)
- Apple Watch / Wear OS companion (optional, native)

---

## Summary: The Recommended Stack

| Layer | Technology | Why |
|-------|-----------|-----|
| **Framework** | React Native (Expo SDK 54+) | Best Elm-pattern fit, proven EEG/BLE, web support |
| **Language** | TypeScript (or ReScript for Elm purists) | Type safety, ecosystem depth |
| **State** | useReducer + Context (Elm Architecture) | Pure functions, predictable state |
| **Navigation** | Expo Router | File-based, works on iOS/Android/web |
| **Local DB** | expo-sqlite or WatermelonDB | Fast, reactive, encrypted |
| **Sync** | PowerSync + Supabase (self-hostable) | Offline-first, E2EE compatible, SQL |
| **BLE** | react-native-ble-plx | Production-proven, auto-reconnect |
| **Health Data** | react-native-health + react-native-health-connect | Full HealthKit + Health Connect |
| **Background** | react-native-background-fetch | Industry standard |
| **Encryption** | AES-256-GCM via expo-crypto + react-native-keychain | E2EE for health data |
| **Signal Processing** | C++/Rust via JSI native modules | FFT for EEG, zero-copy data |
| **Builds** | Expo EAS | Cloud builds, OTA updates |
| **Distribution** | App Store + Google Play + Web (PWA fallback) | Maximum reach |
| **Positioning** | "Wellness Protocol Tracker" | App store safe, honest framing |

---

## Sources

### Cross-Platform Frameworks
- [React Native Expo Complete Guide 2026](https://reactnativeexpert.com/blog/react-native-expo-complete-guide/)
- [React Native BLE Integration](https://reactnativeexpert.com/blog/mastering-bluetooth-low-energy-integration-with-react-native/)
- [NeuroTechX EEG-101 (React Native + Muse)](https://github.com/NeuroTechX/eeg-101)
- [Real-Time Audio Pipelines via JSI (Callstack)](https://www.callstack.com/blog/from-files-to-buffers-building-real-time-audio-pipelines-in-react-native)
- [ReViSe rPPG Framework](https://arxiv.org/pdf/2206.08748)
- [Flutter vs React Native Benchmark 2025](https://www.synergyboat.com/blog/flutter-vs-react-native-vs-native-performance-benchmark-2025)
- [Flutter Blue Plus](https://pub.dev/packages/flutter_blue_plus)
- [Flutter Health Plugin](https://pub.dev/packages/health)
- [KMP Production Readiness](https://volpis.com/blog/is-kotlin-multiplatform-production-ready/)
- [Kable BLE Library](https://github.com/JuulLabs/kable)
- [Elm Architecture with React](https://dev.to/atmorojo/the-elm-architecture-with-react-2p1m)
- [Tauri 2.0 Release](https://v2.tauri.app/blog/tauri-20/)

### Multi-Device Sync
- [PowerSync](https://www.powersync.com)
- [PowerSync + Supabase](https://www.powersync.com/blog/offline-first-apps-made-simple-supabase-powersync)
- [Automerge 3.0](https://automerge.org/blog/automerge-3/)
- [Evolu — Local-First E2EE](https://www.evolu.dev/docs/how-evolu-works)
- [Ink & Switch — Local-First Software](https://www.inkandswitch.com/essay/local-first/)
- [WatermelonDB](https://github.com/Nozbe/WatermelonDB)
- [MongoDB Realm Deprecated](https://objectbox.io/alternative-to-mongodb-sync/)
- [Cinapse Moved Away from CRDTs](https://www.powersync.com/blog/why-cinapse-moved-away-from-crdts-for-sync)
- [iCloud Encryption — Apple](https://support.apple.com/guide/security/icloud-encryption-sec3cac31735/web)

### App Store Strategy
- [Apple App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Google Play Health Content Policies](https://support.google.com/googleplay/android-developer/answer/16679511)
- [Google Play Health Apps Update Jan 2026](https://myappmonitor.com/blog/google-play-health-apps-update-2026-requirements)
- [Houston: For Inner Space](https://apps.apple.com/us/app/houston-for-inner-space/id1582469884)
- [Dose: Protocol Tracker](https://apps.apple.com/us/app/dose-protocol-tracker/id6753960534)
- [FDA Wellness Products Guidance (Jan 2026)](https://www.aha.org/news/headline/2026-01-06-fda-issues-guidance-wellness-products-clinical-decision-support-software)
- [Microdosing Apps — HealingMaps](https://healingmaps.com/microdosing-apps-to-help-you-track/)
