# PWA Biometric Sensor Data Collection: Technical Research

> Can a Progressive Web App collect heart rate, HRV, brainwaves, sleep data, and other physiological signals?
> **Short answer: Yes, more than you'd think — but with important caveats.**

---

## Table of Contents

1. [Web APIs for Sensor Access (2025–2026)](#1-web-apis-for-sensor-access)
2. [Heart Rate & HRV](#2-heart-rate--hrv)
3. [Brainwaves / EEG](#3-brainwaves--eeg)
4. [Sleep Data](#4-sleep-data)
5. [Activity & Movement](#5-activity--movement)
6. [Cloud Wearable APIs](#6-cloud-wearable-apis)
7. [Unified Aggregation Services](#7-unified-aggregation-services)
8. [Architecture Patterns](#8-architecture-patterns)
9. [Privacy & Security](#9-privacy--security)
10. [What Works Today vs. What Doesn't](#10-what-works-today-vs-what-doesnt)
11. [Recommended Phased Approach](#11-recommended-phased-approach)

---

## 1. Web APIs for Sensor Access

### Web Bluetooth API

**Status**: Shipped in Chrome 56+ (2017), Edge 79+, Opera 43+. **NOT supported in Firefox or Safari (iOS/macOS).**

| Browser | Support | Notes |
|---------|---------|-------|
| Chrome (Android) | ✅ Full | Best platform for Web Bluetooth |
| Chrome (Desktop) | ✅ Full | Windows, macOS, Linux, ChromeOS |
| Edge | ✅ Full | Chromium-based |
| Samsung Internet | ✅ Full | Important for Galaxy users |
| Safari (iOS) | ❌ None | Apple blocks Web Bluetooth entirely |
| Safari (macOS) | ❌ None | Behind experimental flag, non-functional |
| Firefox | ❌ None | Philosophical objection to fingerprinting risk |

**Key capabilities**:
- Discovers and connects to BLE (Bluetooth Low Energy) devices
- Reads/writes GATT characteristics (the standard protocol for BLE data)
- Supports standard BLE profiles: Heart Rate (0x180D), Battery, Device Info
- Requires HTTPS and user gesture (click) to initiate pairing
- Can maintain persistent connections for real-time streaming
- Supports notifications (device pushes data to browser)

**Limitation**: Requires user to click a button and select a device from a browser dialog every time. Cannot auto-reconnect silently in background.

**Code pattern**:
```javascript
// Request a heart rate monitor
const device = await navigator.bluetooth.requestDevice({
  filters: [{ services: ['heart_rate'] }]
});
const server = await device.gatt.connect();
const service = await server.getPrimaryService('heart_rate');
const char = await service.getCharacteristic('heart_rate_measurement');

// Subscribe to heart rate notifications
await char.startNotifications();
char.addEventListener('characteristicvaluechanged', (event) => {
  const value = event.target.value;
  const flags = value.getUint8(0);
  const hr = (flags & 0x01) ? value.getUint16(1, true) : value.getUint8(1);
  console.log(`Heart rate: ${hr} bpm`);
});
```

**Sources**: [MDN Web Bluetooth](https://developer.mozilla.org/en-US/docs/Web/API/Web_Bluetooth_API), [Chrome Status](https://chromestatus.com/feature/5264933985976320)

### Web Serial API

**Status**: Chrome 89+, Edge 89+. Not in Firefox or Safari.

- Connects to serial devices (USB-to-serial adapters, Arduino, some EEG boards)
- OpenBCI Cyton board uses serial — Web Serial can connect to it
- Requires user gesture and device selection dialog
- Good for desktop/laptop scenarios, less relevant for mobile

### Web USB API

**Status**: Chrome 61+, Edge 79+. Not in Firefox or Safari.

- Direct USB device access from browser
- Relevant for some EEG devices that use USB (Emotiv EPOC USB dongle)
- Mobile relevance limited (USB OTG scenarios only)

### Generic Sensor API

**Status**: Chrome 67+ (Android & Desktop), Edge 79+. Not in Firefox or Safari.

Available sensors:
- **Accelerometer** ✅ — Motion/activity detection
- **Gyroscope** ✅ — Orientation/rotation
- **LinearAccelerationSensor** ✅ — Motion without gravity
- **AbsoluteOrientationSensor** ✅
- **AmbientLightSensor** ✅ — Could detect sleep environment
- **Magnetometer** ✅

**Useful for**: Inferring activity levels, detecting sedentary periods, rough sleep/wake detection. Not a replacement for dedicated wearables, but adds context.

```javascript
const accelerometer = new Accelerometer({ frequency: 10 });
accelerometer.addEventListener('reading', () => {
  const magnitude = Math.sqrt(
    accelerometer.x ** 2 + accelerometer.y ** 2 + accelerometer.z ** 2
  );
  // magnitude ~9.8 = still, higher = moving
});
accelerometer.start();
```

### Web NFC API

**Status**: Chrome 89+ Android only. Not in any other browser.

- Read/write NFC tags
- Could be used for tapping an NFC tag to log a dose (creative UX idea)
- Not relevant for biometric data collection

### Summary: Browser API Support Matrix

| API | Chrome Android | Chrome Desktop | Safari iOS | Firefox | Samsung Internet |
|-----|---------------|----------------|------------|---------|-----------------|
| Web Bluetooth | ✅ | ✅ | ❌ | ❌ | ✅ |
| Web Serial | ❌ | ✅ | ❌ | ❌ | ❌ |
| Web USB | ❌ | ✅ | ❌ | ❌ | ❌ |
| Generic Sensor | ✅ | ✅ | ❌ | ❌ | ✅ |
| Web NFC | ✅ | ❌ | ❌ | ❌ | ✅ |
| getUserMedia (camera) | ✅ | ✅ | ✅ | ✅ | ✅ |

**The elephant in the room: Safari/iOS blocks nearly all hardware APIs.** This means ~50% of mobile users cannot use direct sensor connections from a pure PWA. This is the single biggest limitation and drives the architecture discussion in Section 8.

---

## 2. Heart Rate & HRV

### Option A: BLE Heart Rate Monitors via Web Bluetooth

**Works today on Chrome/Android.** The BLE Heart Rate Profile (0x180D) is a standardized GATT service. Any compliant monitor works:

| Device | BLE HR Profile | Web Bluetooth Tested | Notes |
|--------|---------------|---------------------|-------|
| Polar H10 | ✅ Standard | ✅ Confirmed working | Also exposes RR-intervals for HRV |
| Polar Verity Sense | ✅ Standard | ✅ Works | Optical, armband |
| Garmin HRM-Pro Plus | ✅ Standard | ✅ Works | Also ANT+, but BLE works |
| Wahoo TICKR | ✅ Standard | ✅ Works | |
| Wahoo TICKR FIT | ✅ Standard | ✅ Works | Armband |
| CooSpo H808S | ✅ Standard | ✅ Works | Budget option (~$30) |
| Movesense Medical Sensor | ✅ Standard | ✅ Works | Medical-grade ECG sensor |

**HRV from BLE**: The Heart Rate Measurement characteristic (0x2A37) includes an optional RR-interval field (time between heartbeats in ms). This is the raw data needed to compute HRV metrics:
- **RMSSD** (root mean square of successive differences) — parasympathetic activity
- **SDNN** (standard deviation of NN intervals) — overall autonomic function
- **pNN50** — percentage of intervals differing by >50ms

```javascript
char.addEventListener('characteristicvaluechanged', (event) => {
  const value = event.target.value;
  const flags = value.getUint8(0);
  const hrFormat = flags & 0x01; // 0 = uint8, 1 = uint16
  const rrPresent = flags & 0x10; // RR-interval data present?

  let offset = 1;
  const hr = hrFormat ? value.getUint16(offset, true) : value.getUint8(offset);
  offset += hrFormat ? 2 : 1;

  // Skip energy expended if present
  if (flags & 0x08) offset += 2;

  // Extract RR intervals
  const rrIntervals = [];
  if (rrPresent) {
    while (offset < value.byteLength) {
      rrIntervals.push(value.getUint16(offset, true) / 1024 * 1000); // Convert to ms
      offset += 2;
    }
  }

  console.log(`HR: ${hr}, RR intervals: ${rrIntervals}`);
});
```

**Limitation**: Only works while the browser tab is active and in foreground. Cannot collect overnight HR data.

### Option B: Camera-Based Photoplethysmography (rPPG)

**Works on ALL browsers** (uses getUserMedia, which is universally supported).

The principle: blood flow causes subtle color changes in skin visible to a camera. By analyzing the green channel of video frames, you can extract pulse rate.

**JavaScript libraries**:

| Library | Status | Notes |
|---------|--------|-------|
| **pulsejs** / heartbeat.js | Proof of concept | Fingertip on camera, basic BPM |
| **rPPG.js** (research) | Academic | Face-based, requires good lighting |
| **Custom canvas analysis** | DIY | Read pixels from video, FFT on green channel |

**Approach**: User places fingertip over phone camera → LED flash illuminates → camera captures video → JS extracts green channel intensity per frame → FFT to find dominant frequency → convert to BPM.

```javascript
// Simplified rPPG from camera
const stream = await navigator.mediaDevices.getUserMedia({
  video: { facingMode: 'environment', width: 320, height: 240 }
});
const video = document.createElement('video');
video.srcObject = stream;
await video.play();

// Enable flashlight for better signal
const track = stream.getVideoTracks()[0];
await track.applyConstraints({ advanced: [{ torch: true }] });

const canvas = document.createElement('canvas');
const ctx = canvas.getContext('2d');
const greenValues = [];

function sample() {
  ctx.drawImage(video, 0, 0, 320, 240);
  const frame = ctx.getImageData(0, 0, 320, 240);
  let greenSum = 0;
  for (let i = 1; i < frame.data.length; i += 4) {
    greenSum += frame.data[i]; // Green channel
  }
  greenValues.push(greenSum / (320 * 240));
  // After ~10 seconds of data, run FFT to find heart rate
  requestAnimationFrame(sample);
}
sample();
```

**Accuracy**: ±3-5 BPM vs clinical monitors in controlled conditions. Degrades significantly with movement, poor lighting, or dark skin tones. **Not suitable for HRV** (insufficient temporal resolution).

**Verdict**: Good for occasional spot-checks. Not reliable enough for clinical tracking. But it's a zero-hardware option that works on every phone.

### Option C: Apple Watch / Galaxy Watch Direct Access

**NOT possible from a PWA.** Period.

- Apple Watch: Data locked in HealthKit. No web API exists. watchOS apps communicate with paired iPhone via WatchConnectivity framework, which requires a native iOS app.
- Galaxy Watch (Wear OS): Samsung Health SDK is native-only. Google Health Connect on the watch has no web API.

**Workarounds**:
1. **Apple Shortcuts automation**: Create a Shortcut that reads HealthKit data and sends it to your PWA's API endpoint or saves to iCloud where PWA can read it
2. **Health Connect REST API (Android)**: Google is working on cloud sync for Health Connect but no public web API yet
3. **Export/import**: HealthKit can export XML; Health Connect can export via third-party apps
4. **Capacitor plugin**: If you wrap the PWA in Capacitor, you can use `@nicepkg/capacitor-healthkit` to read Apple Health data natively

### Option D: Wearable Cloud APIs (see Section 6)

OAuth-based REST APIs that work from any web app. This is the most practical path for most wearables.

---

## 3. Brainwaves / EEG

### Muse Headband (Muse 2, Muse S)

**BLE GATT**: Muse does expose BLE GATT services, but uses a **proprietary protocol** on top of standard BLE. The raw data stream is not a standard GATT profile.

**Web Bluetooth connection**: Technically possible to connect and discover services, but parsing the proprietary data stream requires reverse-engineering.

**Community work**:
- **muse-js** (GitHub: urish/muse-js): JavaScript library that connects to Muse headband via Web Bluetooth. **This works!** It can stream raw EEG data (TP9, AF7, AF8, TP10 channels), accelerometer, gyroscope, and PPG (Muse 2+) directly in the browser.
- Actively maintained, used in several web-based neurofeedback projects
- 5-channel EEG at 256 Hz sample rate

```javascript
import { MuseClient } from 'muse-js';

const client = new MuseClient();
await client.connect(); // Triggers Bluetooth pairing dialog
await client.start();

client.eegReadings.subscribe(reading => {
  console.log(`Channel: ${reading.electrode}, Samples: ${reading.samples}`);
  // reading.samples is Float64Array of 12 samples at 256 Hz
});

client.telemetryData.subscribe(telemetry => {
  console.log(`Battery: ${telemetry.batteryLevel}%`);
});

// PPG (heart rate) from Muse 2
client.ppgReadings.subscribe(ppg => {
  console.log(`PPG channel ${ppg.ppgChannel}: ${ppg.samples}`);
});
```

**Verdict**: **Muse + Web Bluetooth is the most viable EEG-in-a-PWA option.** Works today on Chrome Android/Desktop. The muse-js library is proven.

### OpenBCI

- **Cyton Board**: Uses serial (USB dongle or Bluetooth serial). Web Serial API can connect on desktop Chrome. Not practical on mobile.
- **Ganglion Board**: Uses BLE. Community has achieved Web Bluetooth connections, but it requires custom GATT parsing. Less mature than muse-js.
- **OpenBCI GUI**: Desktop app only. Can export CSV for offline analysis.

**Verdict**: Desktop-only via Web Serial. Not practical for a mobile-first PWA.

### NeuroSky MindWave

- Uses Bluetooth Classic (not BLE) with a USB RF dongle
- **Web Bluetooth cannot connect** (BLE only, not Bluetooth Classic)
- Would need Web Serial via the USB dongle on desktop
- Provides: raw EEG, attention/meditation metrics, blink detection

**Verdict**: Desktop-only workaround via Web Serial. Not recommended for PWA.

### Emotiv (EPOC X, Insight, MN8)

- **Proprietary encrypted protocol**
- Requires Emotiv Launcher (native app) running as middleware
- Cortex API: WebSocket-based API that connects to Emotiv Launcher on localhost
- The browser app communicates via WebSocket to `wss://localhost:6868`

```javascript
// Connect to Emotiv Cortex API (requires Emotiv Launcher running)
const ws = new WebSocket('wss://localhost:6868');
ws.onopen = () => {
  ws.send(JSON.stringify({
    "id": 1,
    "jsonrpc": "2.0",
    "method": "queryHeadsets"
  }));
};
```

**Verdict**: Works in browser but requires native companion app. Good for desktop research use cases.

### Neurosity Crown

- **Neurosity SDK** is JavaScript-first and designed for web
- Uses WiFi (not Bluetooth), connects to Neurosity cloud
- `@neurosity/sdk` npm package works directly in browser
- Streams: raw EEG, focus scores, calm scores, kinesis (imagined motion)
- Device costs ~$999

```javascript
import { Neurosity } from '@neurosity/sdk';
const neurosity = new Neurosity({ deviceId: 'your-device-id' });
await neurosity.login({ email, password });

neurosity.focus().subscribe(focus => {
  console.log(`Focus score: ${focus.probability}`); // 0-1
});

neurosity.calm().subscribe(calm => {
  console.log(`Calm score: ${calm.probability}`); // 0-1
});
```

**Verdict**: Best developer experience for web EEG, but expensive device and requires cloud account (privacy concern).

### EEG Data Processing in JS

- **muse-lsl** / **eeg-pipes**: RxJS-based EEG processing pipelines
- **FFT.js**: Fast Fourier Transform for frequency band extraction (alpha, beta, theta, delta, gamma)
- **brain.js**: Neural network library, could classify EEG patterns
- Standard approach: raw EEG → bandpass filter → FFT → extract power in frequency bands → compute ratios (e.g., alpha/beta for relaxation)

### EEG Summary Table

| Device | Price | Web Connection | Library | Mobile PWA? |
|--------|-------|---------------|---------|-------------|
| Muse 2/S | $250-350 | Web Bluetooth | muse-js ✅ | Chrome Android ✅, iOS ❌ |
| OpenBCI Cyton | $500+ | Web Serial | Community | Desktop only |
| NeuroSky MindWave | $100 | None (BT Classic) | N/A | ❌ |
| Emotiv EPOC X | $849 | WebSocket via Launcher | Cortex API | Desktop only |
| Neurosity Crown | $999 | WiFi/Cloud SDK | @neurosity/sdk ✅ | ✅ All browsers |

---

## 4. Sleep Data

### Direct PWA Sleep Detection

A PWA **cannot reliably detect sleep on its own** because:
- Browser tabs are suspended when the phone screen is off
- Service workers have limited execution time (max ~30 seconds)
- No access to always-on sensors in background

**Partial workaround**: If the user keeps the PWA open with screen on (using Wake Lock API), accelerometer data could be analyzed for sleep/wake cycles. But this drains battery and is impractical.

### Cloud API Approach (Recommended)

Pull sleep data from devices that actually track sleep:

| Service | API | Auth | Sleep Data | Free Tier |
|---------|-----|------|-----------|-----------|
| **Oura Ring** | REST API v2 | OAuth 2.0 | Sleep stages, HRV, SpO2, temp | ✅ Free for personal |
| **Fitbit** | Web API | OAuth 2.0 | Sleep stages, duration, efficiency | ✅ Free |
| **Withings** | Health API | OAuth 2.0 | Sleep stages (with Sleep Analyzer mat) | ✅ Free |
| **Whoop** | Developer API | OAuth 2.0 | Sleep performance, strain, recovery | ✅ Free |
| **Garmin** | Health API | OAuth 1.0a | Sleep stages, Pulse Ox, Body Battery | Requires partnership |
| **Google Fit** | REST API | OAuth 2.0 | Sleep segments (from connected devices) | ✅ Free |
| **Apple Health** | ❌ No web API | N/A | N/A | N/A |

**Oura API example** (most relevant for microdosing users — Oura is popular in the biohacking community):

```javascript
// After OAuth flow, fetch sleep data
const response = await fetch(
  'https://api.ouraring.com/v2/usercollection/sleep?' +
  `start_date=2026-02-28&end_date=2026-03-01`,
  { headers: { 'Authorization': `Bearer ${accessToken}` } }
);
const data = await response.json();
// Returns: bedtime, wake time, total sleep, REM, deep, light,
// sleep efficiency, HRV average, respiratory rate, temperature deviation
```

### Apple Health Workarounds

Since Apple Health has no web API:
1. **Apple Shortcuts**: User creates a Shortcut that exports sleep data → uploads to a webhook
2. **Capacitor HealthKit plugin**: Wrap PWA in Capacitor for iOS
3. **Manual export**: HealthKit XML export → parse in PWA
4. **Third-party bridges**: Apps like Health Auto Export can push HealthKit data to REST endpoints

---

## 5. Activity & Movement

### Generic Sensor API (Chrome Android)

```javascript
// Step detection via accelerometer analysis
const accelerometer = new Accelerometer({ frequency: 50 });
let stepCount = 0;
let lastMagnitude = 9.8;
const THRESHOLD = 1.2;

accelerometer.addEventListener('reading', () => {
  const magnitude = Math.sqrt(
    accelerometer.x ** 2 +
    accelerometer.y ** 2 +
    accelerometer.z ** 2
  );
  // Simple peak detection for steps
  if (magnitude > lastMagnitude + THRESHOLD && lastMagnitude <= 9.8 + THRESHOLD) {
    stepCount++;
  }
  lastMagnitude = magnitude;
});
accelerometer.start();
```

**Accuracy**: Rough. Not comparable to dedicated pedometers. Useful for activity/sedentary classification, not precise step counting.

### Background Limitations

The Sensor API only works while the page is in the foreground. For background activity tracking, you need either:
- A native wrapper (Capacitor with background mode plugin)
- Cloud API from a wearable that does its own tracking

### Google Fit REST API

```javascript
// Fetch step count from Google Fit (after OAuth)
const response = await fetch(
  'https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate',
  {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      aggregateBy: [{ dataTypeName: 'com.google.step_count.delta' }],
      bucketByTime: { durationMillis: 86400000 },
      startTimeMillis: Date.now() - 86400000,
      endTimeMillis: Date.now()
    })
  }
);
```

---

## 6. Cloud Wearable APIs

This is the **most practical approach** for a PWA to access wearable data across platforms. These are standard REST APIs accessible from any web app.

### Oura Ring API v2
- **URL**: `https://api.ouraring.com/v2/`
- **Auth**: OAuth 2.0
- **Data**: Sleep (stages, efficiency, latency), Readiness score, Activity (steps, calories, movement), Heart rate (5-min averages), HRV (nightly), SpO2, Skin temperature
- **Rate limit**: 5000 requests/day
- **Privacy**: Data stored on Oura cloud; user controls access
- **Ideal for microdosing**: Oura's "readiness score" correlates well with the kind of holistic wellness tracking microdosers want
- **Docs**: https://cloud.ouraring.com/v2/docs

### Fitbit Web API
- **URL**: `https://api.fitbit.com/1.2/`
- **Auth**: OAuth 2.0
- **Data**: Sleep stages, Heart rate (intraday 1-sec resolution), HRV, SpO2, Activity, Breathing rate, Skin temperature
- **Rate limit**: 150 requests/hour per user
- **Note**: Google acquired Fitbit; API still supported but long-term future uncertain
- **Docs**: https://dev.fitbit.com/build/reference/web-api/

### Whoop Developer API
- **URL**: `https://api.prod.whoop.com/developer/v1/`
- **Auth**: OAuth 2.0
- **Data**: Recovery score, Strain score, Sleep performance, Heart rate, HRV, Respiratory rate, SpO2, Skin temp
- **Note**: Newer API, rapidly improving
- **Docs**: https://developer.whoop.com/

### Garmin Health API
- **Auth**: OAuth 1.0a (older standard, more complex)
- **Data**: Sleep, Steps, Heart rate, Stress, Body Battery, Pulse Ox, Respiration
- **Access**: Requires partnership application — not open to individual devs
- **Alternative**: Users can export FIT files manually

### Apple Health
- **No web API exists**
- Must use native code (HealthKit framework) or workarounds (see Section 4)

### Samsung Health
- **No public API for third-party web apps**
- Samsung Health SDK is Android-native only
- Privileged partnership required

---

## 7. Unified Aggregation Services

Rather than integrating 5+ wearable APIs individually, aggregation services provide a single API:

### Terra API
- **What**: Unified API for 200+ wearables and health apps
- **Connects**: Garmin, Fitbit, Whoop, Polar, Oura, Apple Health (via mobile SDK), Samsung (privileged), Google Fit, Peloton, Eight Sleep, Dexcom CGM, and more
- **Data**: Activity, sleep, body metrics, heart rate, HRV, nutrition, workouts
- **Real-time**: Live BLE streaming for heart rate and GPS
- **Health Scores**: Computed recovery, strain, stress, immunity scores from raw data
- **SDKs**: iOS, Android, React Native, Flutter, **Capacitor** (important for PWA hybrid)
- **Compliance**: HIPAA, GDPR, SOC 2 Type II
- **Pricing**: Starts at $399/month (annual) with 100K credits. Free tier available for development
- **Website**: https://tryterra.co/
- **Docs**: https://docs.tryterra.co/

### Vital
- **What**: Similar unified health data API
- **Connects**: Fitbit, Garmin, Oura, Whoop, Apple Health, Google Fit, Dexcom, Abbott (Libre)
- **Focus**: More clinical/health-tech focused
- **Pricing**: Free tier (up to 50 users), then usage-based
- **Website**: https://tryvital.io/

### Comparison

| Feature | Terra | Vital |
|---------|-------|-------|
| Device coverage | 200+ | 100+ |
| Apple Health | Via mobile SDK | Via mobile SDK |
| Samsung | Privileged access | Standard |
| BLE real-time | ✅ | ❌ |
| Health scores | ✅ | ❌ |
| Free tier | Dev only | 50 users |
| HIPAA | ✅ | ✅ |
| Capacitor SDK | ✅ | ✅ |

**Privacy concern**: Both services route health data through their cloud. For a privacy-first app, this may be a dealbreaker. Consider whether the convenience of unified integration justifies the data routing.

---

## 8. Architecture Patterns

### Pattern 1: Pure PWA + Cloud APIs

```
[User's Wearable] → [Wearable Cloud] → [OAuth] → [Your PWA]
     (Oura, Fitbit, etc.)                         (fetches via REST)
```

**Pros**: Works on all browsers, no native code, simplest to build
**Cons**: No real-time sensor data, no Apple Health, requires wearable to sync to cloud first, user's data transits third-party clouds
**Best for**: Phase 1 — daily/weekly wellness correlations

### Pattern 2: PWA + Web Bluetooth (Direct BLE)

```
[BLE Sensor] → [Web Bluetooth API] → [Your PWA]
  (HR monitor, Muse)                    (processes in-browser)
```

**Pros**: Real-time data, no cloud dependency, true privacy (data never leaves device)
**Cons**: Chrome/Android only, requires compatible BLE device, foreground-only, manual reconnection
**Best for**: Meditation sessions with EEG, pre/post dose heart rate checks

### Pattern 3: PWA + Capacitor Hybrid

```
[Your SvelteKit PWA]
    ├── Browser: Standard PWA experience
    └── Capacitor wrapper:
        ├── iOS: HealthKit plugin → Apple Health data
        ├── Android: Health Connect plugin → Google Health data
        ├── BLE plugin → Background sensor connections
        └── Background fetch → Periodic data sync
```

**Pros**: Best of both worlds — PWA for web, native when needed. Single codebase.
**Cons**: Two deployment targets (web + app stores), more complex build pipeline
**Best for**: Phase 2+ when you need Apple Health and background collection

### Pattern 4: Camera rPPG (Zero-Hardware)

```
[Phone Camera] → [getUserMedia] → [Canvas pixel analysis] → [PWA]
                                      (green channel FFT)
```

**Pros**: Works on ALL browsers/platforms, zero additional hardware, "wow factor"
**Cons**: Accuracy ±5 BPM, no HRV, affected by lighting/motion/skin tone, requires 30-60 seconds of stillness
**Best for**: Onboarding/demo, casual check-ins when user has no wearable

### Recommended Architecture: Layered Approach

```
┌─────────────────────────────────────────────────┐
│                  Your PWA (SvelteKit)            │
├─────────────────────────────────────────────────┤
│  Sensor Abstraction Layer                        │
│  ┌──────────┐ ┌──────────┐ ┌──────────────────┐ │
│  │ Cloud API│ │ Web BLE  │ │ Capacitor Native │ │
│  │ Provider │ │ Provider │ │ Provider         │ │
│  └────┬─────┘ └────┬─────┘ └───────┬──────────┘ │
│       │             │               │            │
│  Oura/Fitbit   Polar H10      HealthKit/        │
│  /Whoop REST   Muse EEG       Health Connect    │
│                                                  │
│  ┌──────────────────────────────────────────┐   │
│  │         Local Storage (IndexedDB)         │   │
│  │    All biometric data stored on-device    │   │
│  │    Encrypted with user's passphrase       │   │
│  └──────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
```

The key insight: **design a sensor abstraction layer** so the app doesn't care where data comes from. Whether it's a BLE heart rate monitor, Oura's cloud API, or Apple HealthKit via Capacitor — the app sees the same data structure.

---

## 9. Privacy & Security

### Where Does Biometric Data Live?

| Pattern | Data Location | Privacy Level |
|---------|--------------|---------------|
| Cloud API (Oura, Fitbit) | Wearable vendor's cloud → your PWA → IndexedDB | Medium — data already in vendor cloud |
| Web Bluetooth direct | Sensor → browser → IndexedDB | **High** — data never leaves device |
| Terra/Vital aggregator | Sensor → vendor cloud → aggregator cloud → your PWA | Low — two third parties see data |
| Capacitor + HealthKit | OS health store → your app → IndexedDB | **High** — data stays on device |

### Encryption

- **IndexedDB encryption**: Use Web Crypto API to encrypt all biometric data at rest with a user-derived key (PBKDF2 from passphrase)
- **In-transit**: HTTPS is required for all Web APIs (enforced by browsers)
- **Key management**: User's encryption key never leaves the device

```javascript
// Derive encryption key from user passphrase
const keyMaterial = await crypto.subtle.importKey(
  'raw',
  new TextEncoder().encode(passphrase),
  'PBKDF2', false, ['deriveKey']
);
const key = await crypto.subtle.deriveKey(
  { name: 'PBKDF2', salt, iterations: 100000, hash: 'SHA-256' },
  keyMaterial,
  { name: 'AES-GCM', length: 256 },
  false,
  ['encrypt', 'decrypt']
);
```

### Regulatory Considerations

- **HIPAA**: Applies if you're a "covered entity" or "business associate." A personal wellness app used by individuals likely doesn't trigger HIPAA. But if healthcare providers use it, it does.
- **GDPR**: Biometric data is "special category" data requiring explicit consent and data minimization. User must be able to export and delete all their data.
- **State laws**: Illinois BIPA, Texas CUBI, Washington My Health My Data Act — various state-level biometric privacy laws exist.
- **Best practice**: Keep all data on-device. If cloud sync is added later, make it opt-in and end-to-end encrypted.

---

## 10. What Works Today vs. What Doesn't

### ✅ Works Today in a Pure PWA

| Capability | How | Browser Support |
|------------|-----|-----------------|
| Heart rate from BLE chest strap | Web Bluetooth + HR Profile | Chrome, Edge, Samsung Internet |
| HRV from BLE chest strap | Web Bluetooth + RR intervals | Same |
| EEG from Muse headband | Web Bluetooth + muse-js | Same |
| Heart rate from camera | getUserMedia + canvas analysis | All browsers |
| Sleep data from Oura | Oura REST API + OAuth | All browsers |
| Sleep data from Fitbit | Fitbit REST API + OAuth | All browsers |
| Activity from Whoop | Whoop REST API + OAuth | All browsers |
| HRV from Oura | Oura REST API + OAuth | All browsers |
| Motion/activity sensing | Generic Sensor API | Chrome, Edge |
| NFC tag for dose logging | Web NFC | Chrome Android |

### ⚠️ Requires Workaround

| Capability | Workaround | Complexity |
|------------|-----------|------------|
| Apple Health data | Capacitor + HealthKit plugin | Medium |
| Background BLE collection | Capacitor + BLE background plugin | Medium |
| Always-on activity tracking | Capacitor + background mode | Medium |
| Samsung Health | Terra API privileged access | Medium |
| Garmin detailed data | Garmin partnership application | Medium |

### ❌ Not Possible Without Native Code

| Capability | Why |
|------------|-----|
| Apple Watch companion app | Requires watchOS native development |
| Wear OS tile/complication | Requires Wear OS native development |
| Continuous background HR logging | OS kills background web processes |
| Push notifications when heart rate spikes | Requires always-on monitoring (native) |
| HealthKit write access | Native only |

---

## 11. Recommended Phased Approach

### Phase 1: PWA Core (No Sensors)
- Manual mood/energy/focus tracking (journal entries)
- Dose logging with protocol scheduling
- Data visualization and correlation
- **No sensor hardware required — lowest barrier to entry**

### Phase 2: Cloud API Integrations
- Oura Ring API (sleep, HRV, readiness — huge overlap with microdosing metrics)
- Fitbit API (sleep, HR, activity)
- Whoop API (recovery, strain)
- User sees correlations: "Your Oura readiness score averaged 82 on microdose days vs 71 on off days"
- **All standard REST — works on every browser**

### Phase 3: Direct BLE Sensors
- Web Bluetooth heart rate during meditation/check-ins
- Muse EEG integration for meditation quality tracking
- Camera-based rPPG as zero-hardware fallback
- **Chrome/Android users get real-time biometrics**

### Phase 4: Capacitor Hybrid (Optional)
- Wrap PWA in Capacitor for iOS App Store / Google Play
- Add HealthKit + Health Connect integration
- Background data collection
- Native push notifications for reminders
- **Same codebase, expanded capabilities**

### Why This Order?

1. **Phase 1 serves 100% of users** with zero hardware requirements
2. **Phase 2 serves the biohacker crowd** (Oura/Whoop users) who are most likely your early adopters
3. **Phase 3 adds impressive real-time features** for engaged users
4. **Phase 4 solves the iOS gap** only when user base justifies app store presence

---

## Key Takeaways

1. **A PWA can do far more than expected** — Web Bluetooth enables real-time HR, HRV, and even EEG in Chrome
2. **The iOS gap is real but manageable** — Cloud APIs work everywhere; Capacitor is the escape hatch
3. **Cloud wearable APIs are the pragmatic first step** — Oura and Fitbit cover most biohacker users
4. **Privacy-first is achievable** — Direct BLE + on-device storage means biometric data never leaves the phone
5. **The sensor abstraction layer is the key architectural decision** — Design it early so you can add data sources without refactoring
6. **Camera rPPG is a cool demo but not clinically useful** — Good for onboarding, not for tracking
7. **Muse + Web Bluetooth is the sleeper hit** — Real EEG in a browser is genuinely powerful for a mindfulness/microdosing app
8. **Terra/Vital are tempting but conflict with privacy-first** — They route data through their cloud
9. **Start simple, layer complexity** — Most users will never connect a sensor; don't gate the core experience on hardware

---

## Sources

- [MDN Web Bluetooth API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Bluetooth_API)
- [Chrome Web Bluetooth Samples](https://googlechrome.github.io/samples/web-bluetooth/)
- [muse-js GitHub](https://github.com/urish/muse-js)
- [Oura API Docs](https://cloud.ouraring.com/v2/docs)
- [Fitbit Web API Reference](https://dev.fitbit.com/build/reference/web-api/)
- [Whoop Developer API](https://developer.whoop.com/)
- [Terra API Docs](https://docs.tryterra.co/)
- [Vital API Docs](https://docs.tryvital.io/)
- [Generic Sensor API](https://developer.mozilla.org/en-US/docs/Web/API/Sensor_APIs)
- [Emotiv Cortex API](https://emotiv.gitbook.io/cortex-api/)
- [Neurosity SDK](https://docs.neurosity.co/)
- [Web Crypto API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Crypto_API)
- [Capacitor HealthKit Plugin](https://github.com/nicepkg/capacitor-healthkit)
- [Bluetooth Heart Rate Profile Spec](https://www.bluetooth.com/specifications/specs/heart-rate-profile-1-0/)
