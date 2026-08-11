# Medithon Project Setup

This is a monorepo setup for a Flutter Frontend and Flask Backend using PostgreSQL (Neon).

## Directory Structure
- `packages/backend/`: Contains the Flask API backend.
- `packages/frontend/`: Contains the Flutter application.

## Prerequisites
- Docker & Docker Compose
- Python 3.11+ (for local backend development)
- Flutter SDK (for local frontend development)

## 1. Setting up the Backend

1. Navigate to the backend directory:
   ```bash
   cd packages/backend
   ```
2. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```
3. Update `.env` with your Neon PostgreSQL connection string and a secure `SECRET_KEY`.

4. Local Development:
   - Create a virtual environment: `python -m venv venv`
   - Activate it: `source venv/bin/activate` (Linux/Mac) or `venv\Scripts\activate` (Windows)
   - Install dependencies: `pip install -r requirements.txt`
   - Run the server: `python run.py`

## 2. Setting up the Frontend

Since Flutter is typically generated on your local machine:
1. Navigate to the `packages` directory:
   ```bash
   cd packages
   ```
2. Create the Flutter project (if not already created) inside the `frontend` directory:
   ```bash
   flutter create frontend
   ```
3. Run the Flutter app:
   ```bash
   cd frontend
   flutter run -d chrome
   ```

## 3. Running with Docker Compose

You can spin up both the backend and frontend using Docker Compose.

1. In the root directory of the project, run:
   ```bash
   docker-compose up --build
   ```

2. Access the services:
   - **Frontend**: http://localhost:8080
   - **Backend API**: http://localhost:5000
