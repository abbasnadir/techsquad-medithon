# Medithon: Clubfoot AI Care System

Medithon is an offline-first, machine-learning-powered digital ecosystem designed to standardize the capture, scoring, and trajectory prediction of CTEV (Clubfoot) treatment. 

## 🚀 Getting Started
We have provided a streamlined `run.sh` script to effortlessly boot both the backend and frontend.

### To run the Backend API (Flask):
```bash
./run.sh backend
```
*This automatically creates a Python virtual environment using `uv`, installs dependencies, and runs the Flask server on port 5000.*

### To run the Frontend App (Flutter):
```bash
./run.sh frontend
```
*This fetches all Dart packages and launches the Flutter application on your emulator/device.*

## 🏗️ Architecture (Hackathon POV)
Our solution is designed specifically for rural healthcare workers (ANMs) operating in low-connectivity areas (PHCs).

- **Frontend (Flutter)**: A fully self-contained offline-first mobile app using SQLite for local storage and `google_mlkit_pose_detection` for on-device machine learning.
- **Backend (Flask + Python 3.12)**: Serves as the sync hub and machine learning engine for trajectory prediction, powered by Neon (PostgreSQL) and managed rapidly using `uv`.
- **Hardware Integration**: We integrate a 3D-Printed Foot Cradle embedded with ArUco fiducial markers to provide standardized scale and orientation.

## ✨ Core & Unique Features

### 1. Active Capture-Guidance & Mock 3D Reconstruction
The camera UI isn't just a shutter button. We integrated Google ML Kit Pose Detection directly on-device to actively map foot geometry across **3 strict views** (Medial, Lateral, Posterior). 
* **Hackathon Fallback Demo**: We built a highly dynamic fallback mode that generates simulated keypoints and a spinning **3D Wireframe Reconstruction** if real-ML fails under demo conditions, simulating a perfect Pirani score calculation!

### 2. Role-Based Clinical Dashboards
- **Healthcare Worker (Doctor/ANM)**: Features a Patient Directory tracking Pirani Scores, treatment phases, and ML alerts for predicted tenotomies.
- **Patient/Parent Dashboard**: Gives parents an empowering view of their child's care plan.

### 3. Patient FAB (Brace) Tracker
Treatment extends beyond the clinic! We built an interactive FAB (Foot Abduction Brace) tracker allowing parents to log their daily 23-hour brace compliance and visually track progress against a dynamic progress bar.

### 4. Tele-Consultation Portal
If a parent notices swelling or pain from the brace, they can instantly open a Tele-Consultation ticket in the app, preventing unneeded clinic visits or critical drops in brace compliance.

### 5. The "Data Flywheel" (Crowdsourcing)
Because open-source infant clubfoot ML data doesn't exist, our app includes a post-scan Consent Flow. Parents opt-in to securely upload anonymized 3-view scans, directly solving the training data scarcity problem for future YOLO models!
