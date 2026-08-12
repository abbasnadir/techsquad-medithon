# Medithon Project Setup

This is a monorepo setup for a Flutter Frontend and Flask Backend using PostgreSQL (Neon).

## Directory Structure
- `packages/backend/`: Contains the Flask API backend.
- `packages/frontend/`: Contains the Flutter application.
- `run.sh`: Bash script to easily boot the frontend or backend.

## Prerequisites
- `uv` (Lightning-fast Python package manager)
- Python 3.12+ (for local backend development)
- Flutter SDK (for local frontend development)

## 1. Running the Project (Fast Way)
We have provided a bash script to handle all dependencies and boot the servers automatically.

1. **Backend**:
   ```bash
   ./run.sh backend
   ```
2. **Frontend**:
   ```bash
   ./run.sh frontend
   ```

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
