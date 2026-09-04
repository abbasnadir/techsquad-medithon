# SureStep — Setup & Execution Guide

This is a monorepo setup for the **SureStep** Clubfoot Care & Assessment platform (Flutter Frontend + Flask Backend with SQLite/PostgreSQL).

## 🚀 1. Quick Launch (Recommended)
You can boot the full stack and launch the standalone desktop app window with a single command:

```bash
./run.sh app
```

For complete instructions, demo credentials, and features, see [HOW_TO_RUN.md](file:///Users/nidhiii/Clubfoot/techsquad-medithon/HOW_TO_RUN.md).

## 📁 Directory Structure
- `packages/backend/`: Flask API backend (runs on port `5050`).
- `packages/frontend/`: Flutter web/mobile application (runs on port `3000`).
- `run.sh`: Master CLI tool for booting services.
- `HOW_TO_RUN.md`: Detailed testing and user flow guide.

## 2. Individual Commands
- **Start Backend**: `./run.sh backend`
- **Start Frontend**: `./run.sh frontend`
- **Open Desktop App Window**: `./run.sh desktop`


## 2. Setting up the Backend (Manual)

1. Navigate to the backend directory:
   ```bash
   cd packages/backend
   ```
2. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```
3. Update `.env` with your Neon PostgreSQL connection string and a secure `SECRET_KEY`.

4. Local Development using `uv`:
   - Create a virtual environment: `uv venv --python 3.12 venv`
   - Activate it: `source venv/bin/activate` (Linux/Mac) or `venv\Scripts\activate` (Windows)
   - Install dependencies: `uv pip install -r requirements.txt`
   - Run the server: `python run.py`

## 3. Setting up the Frontend (Manual)

1. Navigate to the frontend directory:
   ```bash
   cd packages/frontend
   ```
2. Run the Flutter app:
   ```bash
   flutter pub get
   flutter run
   ```
