# Microdosing Journal App — Feasibility Research & Deep Analysis

> **Date:** March 2026
> **Author:** Research compiled for Bhavpreet Singh
> **Status:** Feasibility Study / Pre-Development

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [What is Microdosing & Why Track It?](#2-what-is-microdosing--why-track-it)
3. [How a Journal App Helps Real People](#3-how-a-journal-app-helps-real-people)
4. [Existing Apps & Competitive Landscape](#4-existing-apps--competitive-landscape)
5. [What Users Want — Gaps & Unmet Needs](#5-what-users-want--gaps--unmet-needs)
6. [Clinical Trials & Research Applications](#6-clinical-trials--research-applications)
7. [Legal & Regulatory Landscape](#7-legal--regulatory-landscape)
8. [The Chakra Framework — A Unique Differentiator](#8-the-chakra-framework--a-unique-differentiator)
9. [Native App vs. PWA vs. Website](#9-native-app-vs-pwa-vs-website)
10. [Technology Considerations (Elm & Beyond)](#10-technology-considerations-elm--beyond)
11. [Proposed Feature Set](#11-proposed-feature-set)
12. [Open Questions for the Creator](#12-open-questions-for-the-creator)
13. [Sources & References](#13-sources--references)

---

## 1. Executive Summary

A microdosing journal app is **highly feasible and fills a genuine gap** in the current market. While several apps exist (Houston, Deliqs, MicroTracker, Microdose.me), they each have significant limitations that users vocally complain about. No existing app combines:

- Deep, customizable wellness tracking with user-defined parameters
- A meaningful spiritual/holistic framework (like the Chakra system)
- Privacy-first, local-only data storage
- Both quantitative tracking AND qualitative journaling
- Retroactive entry, baseline measurement, and smart insights
- An open, research-friendly architecture

The growing legal acceptance of psilocybin (Oregon, Colorado, Australia, and 36+ state-level bills in 2025 alone) means the addressable market is expanding rapidly. The convergence of psychedelic decriminalization, rising mental health awareness, and the "quantified self" movement makes **now an ideal time** to build this.

**Market size is massive and growing:** A [RAND Corporation study (January 2026)](https://www.rand.org/news/press/2026/01/millions-of-us-adults-microdosing-psychedelics.html) — the first nationally representative survey — estimated that **approximately 10 million U.S. adults microdosed psilocybin, LSD, or MDMA in 2025**. Among past-year psilocybin users, roughly two-thirds reported microdosing at least once.

**Our recommendation: Build a Progressive Web App (PWA)** — it avoids app store gatekeeping risks, works cross-platform, supports offline use, and aligns perfectly with the privacy-first philosophy. The Chakra framework is not just a visual theme but a genuine differentiator that bridges Eastern wisdom with modern self-tracking in a way no competitor does.

---

## 2. What is Microdosing & Why Track It?

### 2.1 The Practice

Microdosing involves taking **sub-perceptual doses** (typically 1/10th to 1/20th of a recreational dose) of psychedelic substances — most commonly psilocybin mushrooms or LSD — on a structured schedule. The intent is not to "trip" but to experience subtle improvements in mood, focus, creativity, and emotional regulation over time.

### 2.2 Common Substances

| Substance | Typical Microdose | Notes |
|-----------|------------------|-------|
| Psilocybin mushrooms | 0.05–0.3g dried | Most popular (85% of microdosers per Microdose.me study) |
| LSD | 5–20 μg | Second most common |
| 1P-LSD / analogues | 5–20 μg | Legal grey area in some jurisdictions |
| Mescaline (San Pedro) | 10–50 mg | Less common |
| DMT | Varies | Emerging interest |

### 2.3 Popular Protocols

- **Fadiman Protocol** (Dr. James Fadiman): Dose on Day 1, rest Days 2–3, repeat. The most widely used.
- **Stamets Stack** (Paul Stamets): Psilocybin + Lion's Mane mushroom + niacin, 4 days on / 3 days off. The Microdose.me study found this stack showed ~40% improvement in psychomotor performance in adults over 55.
- **Every Other Day:** Simpler schedule, dose every 2nd day.
- **Intuitive Microdosing:** Dose when you feel it's needed — requires excellent self-awareness.

### 2.4 Conditions People Address

Research and self-reports indicate microdosing is used for (with prevalence from survey data):

- **Depression** — 72.7% of microdosers had a diagnosis; 21.3% primary motivation
- **Anxiety** — 55.6% of microdosers had a diagnosis
- **ADHD** — 37.3% of microdosers had a diagnosis; many reported trying it as an Adderall substitute
- **PTSD** — significant subset; rodent research shows microdosing may facilitate extinction learning
- **Chronic pain** — cluster headaches, fibromyalgia, migraines. [Cavarra et al. (2024)](https://onlinelibrary.wiley.com/doi/full/10.1002/ejp.2171) found psychedelics led to better self-reported pain relief than conventional medication
- **Addiction** — microdosers reported reduced use of caffeine (44.2%), alcohol (42.3%), cannabis (30.3%), tobacco (21.0%), and psychiatric medications (16.9%)
- **Creativity & productivity** — 14.8% primarily motivated by cognitive enhancement
- **Spiritual growth** — deepened meditation practice, expanded consciousness
- **General wellbeing** — 30% primary motivation; 69% including secondary

### 2.5 Why Tracking Matters

Microdosing is **deeply personal and variable**. Unlike conventional medication with standardized dosing, microdosing requires self-experimentation:

- Natural psilocybin content varies from mushroom to mushroom
- Optimal dose varies by individual (body weight, sensitivity, tolerance)
- Effects are subtle and accumulate over weeks
- Without tracking, it's impossible to distinguish real effects from placebo, mood fluctuations, or external life events

**The Microdosing Institute emphasizes**: "Tracking provides a baseline when comparing your wellbeing, mental state, or other variables before, during, and after following a microdosing protocol."

---

## 3. How a Journal App Helps Real People

### 3.1 Finding the "Sweet Spot"

Reddit users frequently report: *"I find that the perfect dose tends to vary by day. Sometimes it's too much and sometimes it's perfect and sometimes it feels like it didn't do anything."* A journal app that correlates dose amounts with reported effects over time can help users hone in on their ideal dose.

### 3.2 The Therapeutic Power of Self-Tracking

Independent of microdosing, research shows that **mood tracking and journaling have measurable therapeutic benefits**:

- **Increased self-awareness** — noticing patterns you'd otherwise miss
- **Emotional regulation** — the act of labeling emotions reduces their intensity (affect labeling)
- **Mindfulness cultivation** — daily check-ins create a natural mindfulness practice
- **Accountability** — structured tracking improves adherence to protocols
- **Communication with healthcare providers** — data-backed conversations with therapists or doctors

### 3.3 Becoming Part of the Daily Routine

The most successful wellness apps become **rituals**, not chores. The app should feel like:

- A morning intention-setting practice
- An evening reflection ritual
- A trusted companion on the microdosing journey
- A mirror that helps you see yourself more clearly

This aligns beautifully with the Chakra framework — checking in with your energy centers daily IS a meaningful spiritual practice, not just data entry.

---

## 4. Existing Apps & Competitive Landscape

### 4.1 Current Players

| App | Platform | Key Strength | Key Weakness |
|-----|----------|-------------|--------------|
| **Houston** | iOS only | Beautiful UX, intention setting, community feed, dose-day radio | iOS only, can't log past days, no custom schedules, limited tracking parameters |
| **Deliqs (Dose)** | iOS | AI chatbot for emotional support, clean UI | Limited customization, new & small user base |
| **MicroTracker** | Android | Privacy-first (no cloud), PDF reports for doctors, custom protocols | Android only, basic UI, limited data visualization |
| **Microdose.me** | iOS (Quantified Citizen) | Citizen science research (19,000+ participants), Paul Stamets backing | Very buggy UX, locks users out, not a true journal, research-focused only |
| **Trip** (Field Trip) | iOS/Android | Guided journey support, music integration | Focused on full-dose trips, not daily microdosing tracking |

### 4.2 What None of Them Do

- No app offers a **holistic spiritual framework** (like Chakras) for understanding wellness
- No app provides **truly customizable parameters** — users resort to Notion templates
- No app works well on **both platforms** with consistent quality
- No app offers **baseline period tracking** before starting a protocol
- No app provides **smart correlations** (e.g., "Your mood scores are 23% higher on dose days vs. rest days")
- No app successfully combines **quantitative metrics + free-form journaling**
- No app has **retroactive entry** that works well (users of Houston and Microdose.me cite this as a major frustration)

---

## 5. What Users Want — Gaps & Unmet Needs

Based on app store reviews, Reddit discussions (r/microdosing), and academic analysis of the microdosing community, here are the **top unmet needs**, ranked by frequency of mention:

### Critical Gaps (Mentioned Repeatedly)

1. **Retroactive logging** — "I need to be able to go back to enter days I forgot to open this app" (Houston App Store review)
2. **Custom dosing schedules** — "There is also no option to create your own schedule" — users don't all follow preset protocols
3. **Reliable, bug-free experience** — Microdose.me described as "very buggy, which will bias results"
4. **Custom trackable variables** — Users want to define their own parameters, not just preset ones
5. **Privacy & anonymity** — Given legal status, many users won't use apps that require accounts or cloud storage

### Important Gaps

6. **Baseline measurement** — Ability to track for a period BEFORE starting microdosing to establish a comparison point
7. **Combined journaling + tracking** — Both quantitative sliders AND free-text reflections in one place
8. **Meaningful data visualization** — Graphs, trends, correlations over time
9. **Dose optimization tools** — Help finding the personal "sweet spot"
10. **Intention setting & reflection** — Integrated into the daily flow, not an afterthought

### Nice-to-Haves

11. **PDF/export reports** — For sharing with therapists, doctors, or integration circles (MicroTracker offers this — users love it)
12. **AI-powered insights** — Pattern recognition, gentle coaching (Deliqs has early version of this)
13. **Cross-platform availability** — Most apps are iOS-only, leaving Android users underserved
14. **Reminders** — Configurable notifications for dose days and check-in times

---

## 6. Clinical Trials & Research Applications

### 6.1 The Microdose.me Landmark Study

The largest microdosing study ever conducted used a mobile app (Quantified Citizen) to collect data from **19,000+ participants worldwide**. Key results published in *Nature: Scientific Reports*:

- **First paper (2021):** Microdosers (n=4,050) exhibited lower levels of depression, anxiety, and stress compared to non-microdosers (n=4,653). Psilocybin was the most common substance (85%). "Stacking" (psilocybin + Lion's Mane + niacin) was a prevalent practice.
- **Second paper (2022):** Psilocybin microdosing was associated with improvements in mood and mental health. Adults **over 55** showed the greatest improvements, with the Stamets Stack producing ~40% increases in psychomotor performance.
- **Limitation:** As an observational study, it cannot rule out placebo effects. However, the psychomotor (Finger Tap Task) improvements add robustness beyond pure self-report.

### 6.2 Double-Blind Controlled Trials (2024–2025) — The Placebo Question

More rigorous trials have produced **mixed results**, which actually strengthen the case for a journal app:

- Two double-blind, placebo-controlled trials found that microdosing psilocybin truffles **did not significantly affect behavioral or subjective measures compared to placebo** after correcting for multiple comparisons.
- The first RCT of microdosing for a psychiatric condition — [Mueller et al. (2025) in *JAMA Psychiatry*](https://jamanetwork.com/journals/jamapsychiatry/fullarticle/2831639) — gave 53 adults with ADHD either LSD (20μg) or placebo twice weekly for 6 weeks. Result: **no difference between groups**. Both improved significantly, highlighting a powerful placebo response.
- The [Imperial College self-blinding study](https://elifesciences.org/articles/62878) found no significant between-group differences between microdose and placebo — both groups showed improvements.
- A critical review of 57 human studies found: "Observational studies tend to report more benefits, while experimental trials yield more null findings."
- However, [Polito (2024)](https://pmc.ncbi.nlm.nih.gov/articles/PMC11311906/) argues there are 8 reasons why dismissing microdosing as placebo is premature, including small sample sizes and the fact that only non-clinical populations have been studied.

**Why this matters for the app:** This suggests the **journaling/tracking component itself may be therapeutically valuable** — the ritual of daily self-reflection, intention-setting, and mindfulness practice may be as important as the substance. A meta-analysis of 20 RCTs found that journaling alone produces a **5% reduction in mental health symptom scores** (9% for anxiety, 6% for PTSD). The app becomes valuable regardless of whether microdosing "works" pharmacologically.

### 6.3 How Our App Could Serve Research

A well-designed journal app could contribute to research in several ways:

1. **Opt-in anonymized data sharing** — Users could voluntarily contribute de-identified data to research databases
2. **Standardized assessment instruments** — Include validated scales (PHQ-9 for depression, GAD-7 for anxiety) alongside custom tracking
3. **Controlled comparison** — Built-in baseline periods and the ability to track placebo controls
4. **FHIR-compatible data export** — Healthcare data interoperability standard, enabling clinical integration
5. **Longitudinal data** — Apps capture daily data over months/years, which is difficult and expensive in traditional research settings

### 6.4 The OPTIMIZE Study & Fabla App — The Cutting Edge

The [OPTIMIZE Study (NCT06512194)](https://news.emory.edu/stories/2025/03/hs_psychedelic_therapy_fabla_voice_diary_app_25-03-2025/story.html) — a Phase 2 psilocybin trial at Emory/UCSF/UCLA — uses **Fabla**, a novel smartphone voice diary app that captures speech biomarkers (tone, pitch, word choice) as indicators of mental health changes. Participants record daily spoken reflections before and after treatment. This represents one of the most sophisticated uses of a mobile app in psychedelic clinical research (enrolled first participant June 2025).

### 6.5 The Digital Phenotyping Frontier

Imperial College London's Centre for Psychedelic Research is pioneering **precision psychedelic medicine** using wearable physiological data and digital phenotyping. Beckley Psytech has partnered with Empatica to conduct one of the world's first psychedelic trials incorporating wearable digital tools. A journal app that integrates with wearables (sleep trackers, heart rate monitors) could become a valuable tool in this emerging field.

### 6.6 FDA January 2026 Guidance — Favorable for Wellness Apps

On January 6, 2026, the FDA released updated guidance significantly loosening oversight of wellness apps. General wellness products may now "display values, ranges, trends, baselines, or longitudinal summaries" without being classified as medical devices. A mood/wellness journaling app **does not require FDA approval** as long as it does not claim to diagnose or treat conditions.

---

## 7. Legal & Regulatory Landscape

### 7.1 Where Psilocybin is Legal/Decriminalized (as of early 2026)

**Fully Regulated Therapeutic/Supervised Access:**
- **Oregon, USA** — Licensed service centers since 2023 (Measure 109)
- **Colorado, USA** — First healing center licenses issued March 2025 (Proposition 122)
- **New Mexico, USA** — Medical psilocybin access pathway established 2025
- **Australia** — Psychiatrists can prescribe for treatment-resistant depression since July 2023 (Schedule 8)

**Decriminalized (reduced/no criminal penalties for possession):**
- Denver, Oakland, Santa Cruz, Seattle, Washington D.C., Cambridge, Somerville, Northampton (USA)
- Portugal, Spain (broader drug decriminalization)

**Therapeutic/Research Access:**
- Canada, Switzerland, Germany, New Zealand, Czechia (various medical/research frameworks)

**Trend:** 36+ psychedelic-related bills were introduced across U.S. states in 2025. Projections based on marijuana legalization patterns suggest a majority of U.S. states may legalize by 2033–2037.

### 7.2 App Store Risks

**Apple Guideline 1.4.3:** "Apps that encourage consumption of... illegal drugs... are not permitted."

However, existing microdosing apps survive on app stores by:
- Framing as **wellness/supplement trackers** (Houston tracks "functional mushrooms, Lion's Mane, cordyceps, B vitamins")
- Positioning as **research platforms** (Microdose.me explicitly states it does not provide substances)
- Using **careful language** — never encouraging use, only tracking
- Not providing **sourcing information** for controlled substances

**Risk assessment:** Moderate. Apps could be removed at Apple/Google's discretion. This is a **strong argument for PWA** — a web app cannot be removed by any app store.

### 7.3 Health App Regulations

A pure mood/wellness journaling app does **not** require FDA approval or HIPAA compliance as long as:
- It does not claim to diagnose or treat medical conditions
- It does not integrate with medical devices
- It does not store Protected Health Information (PHI) in a clinical context

If the app were used in clinical trials, additional compliance (IRB approval, data handling protocols) would be the responsibility of the research institution, not the app itself.

---

## 8. The Chakra Framework — A Unique Differentiator

### 8.1 The Seven Chakras Mapped to Tracking Parameters

This is where our app can truly stand apart. The Chakra system provides a **meaningful, beautiful, and intuitive framework** for organizing wellness parameters — far more engaging than a generic list of sliders.

| Chakra | Sanskrit | Color | Location | Wellness Parameters | Balanced State | Imbalanced State |
|--------|----------|-------|----------|-------------------|----------------|-----------------|
| **Root** | Muladhara | 🔴 Red | Base of spine | Safety, security, stability, groundedness, physical energy | Confident, stable, grounded | Anxious, fearful, insecure |
| **Sacral** | Svadhishthana | 🟠 Orange | Below navel | Creativity, pleasure, sexuality, emotional flow, adaptability | Creative, joyful, passionate | Emotionally numb, guilty, rigid |
| **Solar Plexus** | Manipura | 🟡 Yellow | Upper abdomen | Self-esteem, willpower, confidence, personal power, motivation | Confident, decisive, empowered | Angry, controlling, low self-worth |
| **Heart** | Anahata | 💚 Green | Center of chest | Love, compassion, forgiveness, empathy, connection, harmony | Loving, compassionate, peaceful | Jealous, bitter, isolated |
| **Throat** | Vishuddha | 🔵 Blue | Throat | Communication, self-expression, truth, authenticity, clarity | Expressive, honest, clear | Suppressed, unable to speak truth |
| **Third Eye** | Ajna | 🟣 Indigo | Forehead center | Intuition, insight, awareness, focus, imagination, wisdom | Intuitive, perceptive, focused | Confused, disconnected, overthinking |
| **Crown** | Sahasrara | 👑 Violet/White | Top of head | Spirituality, consciousness, mindfulness, transcendence, purpose | Connected, enlightened, at peace | Depressed, disconnected, purposeless |

### 8.2 How Psilocybin Relates to Chakras

There is a **rich tradition** connecting psychedelic experiences to chakra activation:

- Psilocybin is known for opening the **Heart Chakra** (love, compassion, emotional healing) and **Crown Chakra** (spiritual awareness, higher consciousness)
- Users report **Kundalini-like energy experiences** during psilocybin use — "immense energy bursting out of my chakras, especially the upper chakras"
- Guided psilocybin ceremonies often include **chakra alignment** as a preparation practice
- A systematic review in *Current Psychology* found that psychedelic use is linked with "stronger perceived connections with the divine, a greater sense of meaning, and increased spiritual faith" — all Crown Chakra qualities
- Microdosing, with its subtlety, aligns with the practice of **gradually opening and balancing** chakras rather than forcing them open

### 8.3 UX Vision: The Chakra Journal

**Daily Check-In Flow:**
1. User opens the app → sees a **body silhouette with 7 chakra points**, colored according to yesterday's self-assessment
2. User taps each chakra → rates 2-3 parameters associated with it (e.g., Heart Chakra: "How connected do you feel to others today?" / "How forgiving do you feel?")
3. Overall "energy balance" visualization shows which chakras are strong vs. need attention
4. Optional free-form journaling prompted by: "What does your [weakest chakra] need today?"

**Over Time:**
- Beautiful **heat map / body visualization** showing chakra balance trends over weeks and months
- Correlations between dosing days and chakra activation patterns
- "Your Heart Chakra has been consistently strong this month — your compassion and connection scores are up 30%"

**Why This Works:**
- It transforms data entry into a **meaningful spiritual practice**
- The color system provides **instant visual feedback** (a screen full of vibrant colors = balanced; faded/grey = attention needed)
- It creates a **language** for talking about inner states that is richer than "mood: 7/10"
- It connects users to **thousands of years of wisdom** about inner harmony
- It makes the app **culturally distinctive** and impossible for competitors to replicate as an afterthought

### 8.4 Chakras Map to Modern Psychology

The chakra system is not just mystical — it maps remarkably well onto established psychological frameworks:

| Chakra | Maslow's Hierarchy | Erikson's Stage | Modern Therapy Parallel |
|--------|-------------------|-----------------|------------------------|
| Root | Physiological + Safety needs | Trust vs. Mistrust | Attachment theory, core beliefs about safety |
| Sacral | Safety/Belonging transition | Autonomy vs. Shame | Emotional regulation, creativity, intimacy |
| Solar Plexus | Esteem needs | Initiative vs. Guilt | Self-efficacy (Bandura), locus of control |
| Heart | Love & Belonging | Intimacy vs. Isolation | Compassion-focused therapy, emotional intelligence |
| Throat | Esteem (others' respect) | Identity vs. Role Confusion | Assertiveness training, narrative therapy |
| Third Eye | Self-Actualization | Generativity vs. Stagnation | Metacognition, insight-oriented therapy |
| Crown | Self-Transcendence | Ego Integrity vs. Despair | Transpersonal psychology, logotherapy (Frankl) |

The **endocrine gland correspondence** provides a biological bridge: Root→Adrenals (stress hormones), Sacral→Gonads (sex hormones), Solar Plexus→Pancreas (energy metabolism), Heart→Thymus (immune function), Throat→Thyroid (metabolism), Third Eye→Pituitary (master gland), Crown→Pineal (melatonin, consciousness). The vagus nerve — central to polyvagal theory — physically connects all seven chakra locations.

A peer-reviewed paper in [PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC6106753/) successfully mapped chakra nodes to personality archetypes using the 5-Phase Theory, identifying 14 archetypal patterns. [Routledge](https://www.routledge.com/Chakra-Organized-Acceptance-and-Commitment-Therapy-Treating-Psychosomatic-Conditions/Hale/p/book/9781032169828) has published a book integrating the chakra model with ACT (Acceptance and Commitment Therapy) for treating psychosomatic disorders.

### 8.5 User-Defined Parameters Beyond Chakras

While Chakras provide the framework, users should be able to:
- **Add custom parameters** under any chakra (e.g., "Chronic pain level" under Root Chakra)
- **Create parameters outside the chakra system** (for users who prefer a secular approach)
- **Choose their view** — Chakra visualization OR simple list/slider view
- **Define their own rating scales** (1-5, 1-10, emoji-based, etc.)

---

## 9. Native App vs. PWA vs. Website

### 9.1 The Recommendation: PWA (Progressive Web App)

For this specific project, a **PWA is strongly recommended** as the primary platform. Here's why:

| Factor | PWA | Native App | Simple Website |
|--------|-----|-----------|----------------|
| **App store risk** | ✅ None — cannot be removed | ❌ HIGH — Apple/Google can reject or remove drug-related apps at any time | ✅ None |
| **Privacy** | ✅ All data local (IndexedDB, localStorage) | ✅ Local storage possible | ⚠️ Typically server-based |
| **Cross-platform** | ✅ Works everywhere (iOS, Android, Desktop) | ❌ Need separate iOS + Android builds | ✅ Works everywhere |
| **Offline support** | ✅ Service workers enable full offline use | ✅ Native offline | ❌ Requires connection |
| **Daily habit UX** | ✅ Installable on home screen, feels like an app | ✅ Best native feel | ❌ Must open browser, find URL |
| **Push notifications** | ⚠️ Supported on Android; iOS support improving (added in iOS 16.4+) | ✅ Full support | ❌ Very limited |
| **Development cost** | ✅ Single codebase | ❌ 2-3x cost (iOS + Android) | ✅ Lowest cost |
| **Updates** | ✅ Instant — no app store review | ❌ Days of review for each update | ✅ Instant |
| **Discoverability** | ⚠️ SEO-indexable but not in app stores | ✅ App store browsing | ✅ SEO-indexable |
| **Sensor access** | ❌ Limited (no HealthKit/Google Fit) | ✅ Full hardware access | ❌ Very limited |

### 9.2 Why Not a Native App?

The **single biggest risk** is app store rejection. Apple's Guideline 1.4.3 prohibits apps that "encourage consumption of illegal drugs." Apple [rejected/removed 1.9 million apps in 2024](https://www.macrumors.com/2025/05/30/app-store-2024-transparency-report/) and banned 146,000 developer accounts. One policy change could wipe out your entire distribution channel overnight.

**The privacy argument is decisive.** A microdosing journal contains **self-incriminating evidence**:

| Factor | Native App | PWA |
|--------|-----------|-----|
| Purchase history | Permanently in Apple/Google account | None |
| iCloud/Google backup | App data may be auto-backed up to cloud | PWA data in IndexedDB is NOT included in iCloud backups |
| Device management | Visible in installed apps list, MDM profiles | Indistinguishable from a bookmark |
| Removal trace | Uninstall logged; purchase history permanent | Remove icon + clear browser data = no trace |
| Code auditability | Binary, users cannot inspect | JavaScript source can be inspected |

Additionally:
- A PWA with **local-only data storage + AES-256-GCM encryption** perfectly meets privacy needs
- The app is primarily **text and data entry** — no need for native hardware features
- Building for iOS + Android doubles development and maintenance cost
- **49% of potential mental wellness app users hesitate due to data privacy concerns** — for a microdosing app, this number would be much higher

### 9.3 PWA Capabilities in 2026

Modern PWAs can:
- **Install on home screen** with app icon (looks and feels like a native app)
- **Work fully offline** via Service Workers
- **Send push notifications** on Android and iOS (16.4+)
- **Store significant data locally** via IndexedDB
- **Access camera** (for photo journaling if desired)
- **Share data** via Web Share API
- **Handle background sync** when connection is restored

### 9.4 The Staged Approach

1. **Phase 1: PWA** — Core journaling, tracking, Chakra visualization, local storage
2. **Phase 2: Optional cloud sync** — End-to-end encrypted, for users who want cross-device sync
3. **Phase 3: Native wrapper** (via Capacitor/PWABuilder) — IF app store policies become favorable AND users request native features

---

## 10. Technology Considerations (Elm & Beyond)

### 10.1 The Case for Elm

The project was initialized with Elm in mind. Elm has genuine strengths that are **particularly well-suited** for this specific project:

- **Zero runtime exceptions** — critical for a personal journal where reliability builds trust. Users cannot lose data to crashes.
- **Extreme stability** — last release was 0.19.1 (October 2019), but this is a feature: an Elm app written today will work identically in 5 years with zero maintenance. No dependency churn.
- **Small, auditable output** — compiles to a single optimized JS file (~30-50KB). For a privacy-sensitive app, having a small, inspectable codebase is invaluable.
- **Enforced architecture (TEA)** — The Elm Architecture naturally produces well-structured apps with clear data flow, ideal for a CRUD journaling app.
- **Immutable data** — prevents accidental data corruption of journal entries.
- **Proven PWA capability** — [dwyl/elm-pwa-example](https://github.com/dwyl/elm-pwa-example) achieves a 100% Lighthouse Score. [elm-starter](https://lucamug.medium.com/elm-starter-a-tool-for-the-modern-web-786dbbeed7a1) converts Elm SPAs into statically generated PWAs.

### 10.2 Elm Limitations to Consider

- **Stalled development** — last release October 2019. For a small, focused app this is fine; for a large commercial project, it's a concern.
- **Smaller ecosystem** — fewer libraries and community resources than React/Vue/Svelte
- **JavaScript interop via Ports** — cannot directly call Web Crypto API, IndexedDB, or Notification API; needs message-passing through ports (a well-established pattern)
- **Hiring/collaboration** — fewer developers know Elm; harder to find contributors
- **No mobile-native story** — Elm targets the web only (but PWA IS the intended platform)

### 10.3 Alternative Consideration

If the Elm ecosystem feels too constraining, consider:

- **Elm for core app logic + JavaScript/TypeScript for PWA infrastructure** — a hybrid approach that leverages Elm's strengths while using JS for service workers, IndexedDB management, and push notifications
- **Svelte/SvelteKit** — Lightweight, compiler-based (similar philosophy to Elm), excellent PWA support, larger ecosystem
- **Solid.js** — Reactive, performant, small bundle, good developer experience

**Recommendation:** Start with Elm for the core application. Use JavaScript through Elm's ports system for PWA-specific features (service workers, IndexedDB, Web Crypto API encryption, notifications). This keeps the benefits of Elm's type safety for the core journal logic while leveraging the JS ecosystem where needed.

### 10.4 Proposed Architecture

```
┌─────────────────────────────────────┐
│           Elm Application           │
│  (UI, State, Data Model, Routing)   │
│                                     │
│  ┌───────────┐  ┌───────────────┐   │
│  │ Chakra UI  │  │ Journal Logic │   │
│  │ Components │  │ & Validation  │   │
│  └───────────┘  └───────────────┘   │
│           │  Ports  │               │
├───────────┼─────────┼───────────────┤
│           ▼         ▼               │
│     JavaScript Interop Layer        │
│  ┌──────────┐ ┌──────────────────┐  │
│  │Web Crypto │ │    IndexedDB     │  │
│  │AES-256-GCM│ │ (Encrypted Data) │  │
│  └──────────┘ └──────────────────┘  │
│  ┌──────────┐ ┌──────────────────┐  │
│  │  Service  │ │  Notification    │  │
│  │  Worker   │ │  API             │  │
│  └──────────┘ └──────────────────┘  │
└─────────────────────────────────────┘
         Zero Network Calls
         After Initial Load
```

---

## 11. Proposed Feature Set

### Phase 1 — MVP (Core Journal)

- [ ] **Daily check-in** with Chakra-based parameter tracking
- [ ] **Custom parameters** — user can add/remove tracking variables
- [ ] **Free-form journaling** — text entries alongside quantitative data
- [ ] **Dose logging** — substance, amount, time, protocol
- [ ] **Retroactive entry** — log past days you missed
- [ ] **Baseline period** — track for 1-2 weeks before starting protocol
- [ ] **Basic visualization** — weekly/monthly charts, chakra body map
- [ ] **Local-only storage** — all data in browser (IndexedDB)
- [ ] **PWA installable** — home screen install, offline support
- [ ] **Privacy-first** — no accounts, no cloud, no tracking

### Phase 2 — Insights & Depth

- [ ] **Smart correlations** — "Your mood is X% higher on dose days"
- [ ] **Trend analysis** — long-term patterns across all parameters
- [ ] **Intention setting & reflection** — morning/evening prompts
- [ ] **Protocol templates** — Fadiman, Stamets, custom
- [ ] **PDF export** — monthly reports for therapists/doctors
- [ ] **Data export** — JSON/CSV for personal use or research contribution
- [ ] **Reminders** — configurable push notifications

### Phase 3 — Community & Research

- [ ] **Optional encrypted cloud sync** — for cross-device use
- [ ] **Opt-in research contribution** — anonymized, aggregated data
- [ ] **Validated assessment scales** — PHQ-9, GAD-7, PSS (with proper licensing)
- [ ] **Integration with wearables** — sleep data, heart rate (if native wrapper added)
- [ ] **Community features** — anonymous sharing, protocol recommendations

---

## 12. Open Questions for the Creator

As we move from research to implementation, these questions will shape key decisions:

### Product Direction
1. **Primary audience** — Is this for experienced microdosers optimizing their practice, or beginners just starting out? (This affects onboarding, guidance level, and tone.)
2. **Spiritual vs. secular positioning** — Should the Chakra framework be the default experience, or an opt-in "lens"? Some users may prefer a clinical/minimal aesthetic.
3. **Scope of "medication"** — You mentioned this could work for any medication. Should V1 support general medication tracking, or focus purely on microdosing? (Focus usually wins for MVPs.)
4. **Language & tone** — Clinical and neutral? Warm and spiritual? Science-forward? This affects everything from button labels to onboarding copy.

### Technical Direction
5. **Commitment to Elm** — Are you committed to Elm specifically, or open to alternatives if they better serve the product? Elm is excellent but niche.
6. **Solo developer or team?** — If solo, Elm's safety is a huge asset. If planning to grow a team, broader frameworks may be more practical.
7. **Data model flexibility** — How important is it that users can define completely custom parameters vs. choosing from a curated list?

### Business & Distribution
8. **Monetization** — Free with premium features? Donation-based? Completely free/open source?
9. **Research partnerships** — Is partnering with research institutions (like the Microdose.me model) a goal? This affects data architecture significantly.
10. **Geographic focus** — Global from day one, or focused on regions where psilocybin is legal/decriminalized?

---

## 13. Sources & References

### Existing Apps
- [Houston: For Inner Space — App Store](https://apps.apple.com/us/app/houston-for-inner-space/id1582469884)
- [Deliqs — Dose App](https://www.deliqs.com/)
- [MicroTracker](https://microtracker.soft112.com/)
- [Microdose.me](https://microdose.me/index.html)
- [Quantified Citizen — App Store](https://apps.apple.com/us/app/quantified-citizen/id1485884140)

### Research & Clinical Trials
- [Adults who microdose psychedelics report lower levels of anxiety and depression — Nature Scientific Reports (2021)](https://www.nature.com/articles/s41598-021-01811-4)
- [Psilocybin microdosing improved mental health and psychomotor performance in over 55s — Quantified Citizen / Nature (2022)](https://blog.quantifiedcitizen.com/latest-psilocybin-microdosing-study-finds-improved-mental-health-and-psychomotor-performance-in-those-over-55-years-of-age.html)
- [Cognitive and subjective effects of psilocybin microdosing: double-blind placebo-controlled trials (2025)](https://www.sciencedirect.com/science/article/abs/pii/S0028390825004307)
- [Between enhancement and risk: A critical review of psychedelic microdosing (2025)](https://www.sciencedirect.com/science/article/pii/S2352250X25001423)
- [Less is more? A review of psilocybin microdosing — Savides & Outhoff (2024)](https://journals.sagepub.com/doi/abs/10.1177/02698811241278769)
- [Psychedelic microdosing benefits and challenges: empirical codebook — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC6617883/)
- [Psychedelic Microdosing: A Subreddit Analysis — Journal of Psychoactive Drugs](https://www.tandfonline.com/doi/full/10.1080/02791072.2019.1683260)
- [Psychedelic experiences and long-term spiritual growth: systematic review — Current Psychology (2024)](https://link.springer.com/article/10.1007/s12144-024-06272-2)
- [ClinicalTrials.gov — Psilocybin Microdose (NCT07063862)](https://clinicaltrials.gov/study/NCT07063862)
- [ClinicalTrials.gov — Microdosing Psychedelics to Improve Mood (NCT05259943)](https://clinicaltrials.gov/study/NCT05259943)
- [U.S. Psychedelic Use and Microdosing in 2025 — RAND Corporation](https://www.rand.org/pubs/research_reports/RRA4334-1.html)
- [Precision psychedelic addiction medicine — Frontiers in Psychiatry (2025)](https://www.frontiersin.org/journals/psychiatry/articles/10.3389/fpsyt.2025.1681795/full)

### Chakra System
- [7 Chakras Guide — Arhanta Yoga](https://www.arhantayoga.org/blog/7-chakras-introduction-energy-centers-effect/)
- [7 Chakra Colors: Meanings & Functions](https://www.7chakracolors.com/)
- [The Geometry of Emotions: Using Chakra Acupuncture — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC6106753/)
- [What Are the Seven Chakras? — WebMD](https://www.webmd.com/balance/what-are-chakras)
- [Beginner's Guide to the 7 Chakras — Healthline](https://www.healthline.com/health/fitness-exercise/7-chakras)

### Psychedelics & Spirituality/Chakras
- [Psilocybin Kundalini and Sexual Healing — Meehl Foundation](https://meehlfoundation.org/psilocybin-kundalini-and-sexual-healing/)
- [Psilocybin-occasioned mystical experience with meditation — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC5772431/)
- [Psychedelic experiences and chakras — Medium/Cabbanis](https://medium.com/cabbanis/your-chakra-may-be-blocked-psychedelics-can-help-8c85d004ac6a)

### Legal Landscape
- [Psychedelics Legalization & Decriminalization Tracker — Psychedelic Alpha](https://psychedelicalpha.com/data/psychedelic-laws)
- [Psilocybin Legal Status by State 2025](https://recovered.org/hallucinogens/psilocybin/psilocybin-legal-status)
- [Psilocybin Legalization Map: 2026 Trends](https://pnwspore.com/psilocybin-legality-2026-trends/)
- [State psychedelics legalization roundup — June 2025](https://reason.org/commentary/state-psychedelics-legalization-and-policy-roundup-june-2025/)
- [Australia legalizes psychedelics for therapy — Nature (2023)](https://www.nature.com/articles/d41586-023-02093-8)
- [Australia psilocybin regulatory challenges (2026)](https://journals.sagepub.com/doi/10.1177/00048674251398677)
- [Where is Psilocybin Therapy Legal in 2026?](https://mycomeditations.com/blog/psychedelic-information/where-is-psilocybin-therapy-legal-2026/)

### App Store & Platform
- [Apple App Store Review Guidelines — 1.4.3](https://developer.apple.com/app-store/review/guidelines/)
- [Microdosing Apps — HealingMaps](https://healingmaps.com/microdosing-apps-to-help-you-track/)
- [Microdosing Tracking — Microdosing Institute](https://microdosinginstitute.com/how-to/microdose-tracking/)
- [PWA vs Native App — 2025 Comparison](https://progressier.com/pwa-vs-native-app-comparison-table)
- [PWA vs Native App in 2025 — Wezom](https://wezom.com/blog/progressive-web-apps-vs-native-apps-in-2025)

### Microdosing Community & Tracking Guidance
- [Psychedelic Apps — Psychedelic Spotlight](https://psychedelicspotlight.com/psychedelic-apps/)
- [Apps for Psychedelic Trips Guide — WholeCelium](https://www.wholecelium.com/blog/the-apps-deigned-for-psychedelic-trips/)
- [Microdose Pro — Power of Tracking and Journaling](https://www.microdose-pro.com/tracking-journaling/)

---

### Prevalence & Efficacy Studies
- [RAND Corporation: ~10 Million US Adults Microdosing (January 2026)](https://www.rand.org/news/press/2026/01/millions-of-us-adults-microdosing-psychedelics.html)
- [Mueller et al. (2025) — First ADHD Microdosing RCT, JAMA Psychiatry](https://jamanetwork.com/journals/jamapsychiatry/fullarticle/2831639)
- [Polito & Liknaitzky (2024) — Is Microdosing a Placebo? — J. Psychopharmacology](https://pmc.ncbi.nlm.nih.gov/articles/PMC11311906/)
- [Imperial College Self-Blinding Study — eLife (2021)](https://elifesciences.org/articles/62878)
- [Lea et al. (2020) — Perceived Outcomes of Microdosing — Psychopharmacology](https://link.springer.com/article/10.1007/s00213-020-05477-0)
- [Cavarra et al. (2024) — Psychedelics for Chronic Pain — European Journal of Pain](https://onlinelibrary.wiley.com/doi/full/10.1002/ejp.2171)

### Clinical Trials & Digital Tools
- [OPTIMIZE Study / Fabla Voice Diary App — Emory University (2025)](https://news.emory.edu/stories/2025/03/hs_psychedelic_therapy_fabla_voice_diary_app_25-03-2025/story.html)
- [Johns Hopkins Microdose Program](https://www.hopkinspsychedelic.org/microdose)
- [FDA January 2026 Guidance on Wellness Apps](https://www.arnoldporter.com/en/perspectives/advisories/2026/01/fda-cuts-red-tape-on-clinical-decision-support-software)

### Journaling Therapeutic Value
- [Journaling Meta-Analysis (20 RCTs) — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC8935176/)
- [Positive Affect Journaling RCT — JMIR Mental Health](https://pmc.ncbi.nlm.nih.gov/articles/PMC6305886/)
- [Mindful Journaling — Mindful.org](https://www.mindful.org/how-mindful-journaling-can-help-your-daily-practice/)

### Chakra-Psychology Integration
- [Psychology Today: Maslow's Hierarchy vs. 7 Chakras](https://www.psychologytoday.com/us/blog/the-resilient-brain/201804/maslows-hierarchy-vs-the-7-chakras-interestingly-similar)
- [Chakra-Organized ACT — Routledge](https://www.routledge.com/Chakra-Organized-Acceptance-and-Commitment-Therapy-Treating-Psychosomatic-Conditions/Hale/p/book/9781032169828)
- [Psychological Significance of the Chakras — ResearchGate](https://www.researchgate.net/publication/338895528_Psychological_Significance_of_the_Chakras)
- [Chakra as Bio-Socio-Psycho-Spiritual Model — J. Applied Consciousness Studies](https://journals.lww.com/joacs/fulltext/2013/01010/the_chakra_system_as_a_bio_socio_psycho_spiritual.5.aspx)

### Elm & PWA Technical
- [dwyl/elm-pwa-example — 100% Lighthouse Score](https://github.com/dwyl/elm-pwa-example)
- [elm-starter — Static PWA Generator](https://lucamug.medium.com/elm-starter-a-tool-for-the-modern-web-786dbbeed7a1)
- [Bendyworks — Capacitor + Elm](https://bendyworks.com/blog/capacitor-elm/)
- [Using Elm in 2025 — Engage Software](https://engagesoftware.com/posts/using-elm-in-2025/)

---

*This document is a living research artifact. It will be updated as new information emerges and as product decisions are made.*
