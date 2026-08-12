#!/bin/bash

# A simple script to easily update and run either service

COMMAND=$1

if [ "$COMMAND" == "backend" ]; then
    echo "==================================="
    echo "🚀 Updating and Starting Backend..."
    echo "==================================="
    cd packages/backend
    
    # Create virtual env if it doesn't exist using Python 3.12
    if [ ! -d "venv" ]; then
        uv venv --python 3.12 venv
    fi
    
    # Install requirements using uv
    uv pip install --python venv -r requirements.txt
    
    # Handle Windows vs Linux/Mac executable paths
    if [ -d "venv/Scripts" ]; then
        VENV_PYTHON="./venv/Scripts/python"
    else
        VENV_PYTHON="./venv/bin/python"
    fi
    
    # Run the Flask app
    $VENV_PYTHON run.py

elif [ "$COMMAND" == "frontend" ]; then
    echo "==================================="
    echo "📱 Updating and Starting Frontend..."
    echo "==================================="
    cd packages/frontend
    
    # Get latest flutter packages
    flutter pub get
    
    # Run flutter (make sure your Android emulator is open!)
    flutter run

else
    echo "❌ Invalid command!"
    echo "Usage:"
    echo "  ./run.sh backend   (To update and run the Flask API)"
    echo "  ./run.sh frontend  (To update and run the Flutter App)"
fi
