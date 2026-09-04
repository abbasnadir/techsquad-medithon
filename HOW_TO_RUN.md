# SureStep — How to Run & Test Guide 🚀

This document provides step-by-step instructions on how to start, test, and interact with the **SureStep** Clubfoot Care & Assessment application.

---

## ⚡ 1. Fastest Way (All-in-One Command)

From the project root directory, run:

```bash
./run.sh app
```

This single command will:
1. Start the **Flask Backend API** on `http://127.0.0.1:5050`
2. Start the **Flutter Frontend** on `http://localhost:3000`
3. Automatically launch the **SureStep Standalone App Window** (with mobile app framing)

---

## 🖥️ 2. Starting Services Individually

If you prefer running services in separate terminal tabs:

### Terminal 1: Backend API
```bash
./run.sh backend
```
*Backend runs on `http://127.0.0.1:5050`.*

### Terminal 2: Frontend Server
```bash
./run.sh frontend
```
*Frontend runs on `http://localhost:3000`.*

### Terminal 3 (or browser): Open as Standalone Desktop App
```bash
./run.sh desktop
```
*Or open Google Chrome in app mode:*
```bash
open -na "Google Chrome" --args --app="http://localhost:3000" --window-size=440,900
```

---

## 🔑 3. Demo Test Accounts

You can test both user roles immediately using the prototype credentials:

| Role | Username | Password | Dashboard Features |
| :--- | :--- | :--- | :--- |
| **Clinician / Nurse** | `nurse` | `nurse123` | • AI 3-View CTEV Scan flow<br>• Interactive anatomical landmark adjustment<br>• Indian Patient Directory & search<br>• Link Parent email invitations |
| **Patient / Parent** | `patient` | `patient123` | • Daily Foot Abduction Brace (FAB) compliance tracker<br>• Treatment progress graph (Pirani history)<br>• Tele-Consultation ticket creation with photo attachment |

---

## 📱 4. Key App Workflows to Test

### 1. Healthcare Worker Mode (`nurse` / `nurse123`)
- **Scan Patient Foot (CTEV)**:
  - Supports 3 anatomical views: *Medial*, *Lateral*, and *Posterior*.
  - Upload an image or use camera capture.
  - **Interactive Landmark Tuning**: Drag keypoint markers (*Ankle*, *Heel*, *Toes*, *Calf*) directly onto the foot anatomy.
  - **3D Wireframe Reconstruction**: View simulated multi-view point cloud and automated Pirani score calculation (4.5).
  - Data collection consent dialog.
- **Indian Patient Directory**:
  - Live search across authentic Indian patient records (e.g. *Baby Aarav Sharma*, *Baby Ananya Iyer*, *Baby Vihaan Patel*, etc.).
  - Tap any card to open the Indian clinical bottom sheet with quick contact and full history.
- **Link Patient Email**:
  - Send secure onboarding invitation to parent.

### 2. Patient & Parent Mode (`patient` / `patient123`)
- **Brace Compliance Tracker**:
  - Track 23-hour daily brace wear goal.
  - Tap `Log +1 Hour` to log active compliance.
- **Tele-Consultation**:
  - Report pain, redness, or brace fit issues to the hospital with photo attachments.
- **Progress Graph**:
  - Visual weekly Pirani score reduction graph (Week 1 to Week 4).

---

## 🎨 5. Color Theme Palette ("Serenity")

- **Ming (`#3F7373`)**: Primary brand header & main buttons
- **Palm Leaf (`#768C45`)**: Success badges & compliance indicators
- **Columbia Blue (`#C5D7D9`)**: Border accents & card highlights
- **Opal (`#A8BDBF`)**: Subtle icon containers & secondary badges
- **Anti-Flash White (`#F2F1F0`)**: Clean scaffold background
- **Pure White (`#FFFFFF`)**: High-contrast card surfaces

---

## 🛠️ 6. Troubleshooting

- **Port 5000 busy (macOS AirPlay)**: The backend is configured to use port `5050` by default to avoid macOS Control Center / AirPlay conflicts.
- **Hot Reloading / Restarting**: In the Flutter terminal, press `r` for hot reload or `R` for hot restart.
- **Chrome App Window not opening?**: You can navigate to `http://localhost:3000` in any web browser.
