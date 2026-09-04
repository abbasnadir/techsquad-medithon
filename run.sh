#!/bin/bash

# ==========================================================
# SureStep - Quick Launch & Development Script
# ==========================================================

COMMAND=${1:-"help"}

export PATH="/opt/homebrew/bin:$PATH"

if [ "$COMMAND" == "app" ]; then
    echo "=================================================="
    echo "🚀 Starting SureStep Full Stack (Backend + App)..."
    echo "=================================================="
    
    # Start Backend in background
    cd packages/backend
    if [ ! -d "venv" ]; then
        python3 -m venv venv
    fi
    ./venv/bin/pip install -r requirements.txt -q
    ./venv/bin/python run.py &
    BACKEND_PID=$!
    cd ../..
    
    echo "✅ Backend API running on http://127.0.0.1:5050 (PID: $BACKEND_PID)"
    
    # Start Frontend Web Server
    cd packages/frontend
    flutter pub get
    flutter run -d web-server --web-port=3000 &
    FRONTEND_PID=$!
    cd ../..
    
    echo "⏳ Waiting for Flutter server to initialize..."
    sleep 6
    
    # Launch Standalone App Window
    open -na "Google Chrome" --args --app="http://localhost:3000" --window-size=440,900
    echo "✨ SureStep Desktop App launched!"
    
    # Trap Ctrl+C to stop background services
    trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit" INT TERM
    wait $FRONTEND_PID

elif [ "$COMMAND" == "backend" ]; then
    echo "==================================="
    echo "🚀 Starting SureStep Backend API..."
    echo "==================================="
    cd packages/backend
    
    if [ ! -d "venv" ]; then
        if command -v uv &> /dev/null; then
            uv venv --python 3.12 venv || uv venv venv
        else
            python3 -m venv venv
        fi
    fi
    
    if [ -d "venv/Scripts" ]; then
        VENV_PYTHON="./venv/Scripts/python"
        VENV_PIP="./venv/Scripts/pip"
    else
        VENV_PYTHON="./venv/bin/python"
        VENV_PIP="./venv/bin/pip"
    fi

    if command -v uv &> /dev/null; then
        uv pip install --python venv -r requirements.txt
    else
        $VENV_PIP install -r requirements.txt
    fi
    
    $VENV_PYTHON run.py

elif [ "$COMMAND" == "frontend" ]; then
    echo "==================================="
    echo "📱 Starting SureStep Frontend..."
    echo "==================================="
    cd packages/frontend
    flutter pub get
    flutter run -d web-server --web-port=3000

elif [ "$COMMAND" == "desktop" ]; then
    echo "🖥️  Opening SureStep Standalone App Window..."
    open -na "Google Chrome" --args --app="http://localhost:3000" --window-size=440,900

else
    echo "=========================================="
    echo "✨ SureStep Development Commands"
    echo "=========================================="
    echo "Usage:"
    echo "  ./run.sh app       (Starts full stack and launches standalone desktop app)"
    echo "  ./run.sh backend   (Starts Flask API server on http://localhost:5050)"
    echo "  ./run.sh frontend  (Starts Flutter Web server on http://localhost:3000)"
    echo "  ./run.sh desktop   (Opens Chrome in standalone mobile-frame app mode)"
    echo "=========================================="
fi
