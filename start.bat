@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo ==================================================
echo Starting Hotel Management System...
echo ==================================================

REM Step 1: Check Python installation
echo Checking Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo [ERROR] Python is not installed or not added to PATH.
    echo Please install Python 3.8+ from https://www.python.org/
    echo Make sure to check Add Python to PATH during installation.
    echo.
    pause
    exit /b 1
)

REM Step 2: Create Virtual Environment (.venv) if missing
if not exist ".venv" (
    echo Creating virtual environment .venv...
    python -m venv .venv
    if errorlevel 1 (
        echo [ERROR] Failed to create virtual environment.
        pause
        exit /b 1
    )
)

REM Step 3: Install dependencies
echo Installing dependencies...
if exist "requirements.txt" (
    ".venv\Scripts\python.exe" -m pip install -q -r requirements.txt
) else if exist "backend\requirements.txt" (
    ".venv\Scripts\python.exe" -m pip install -q -r backend\requirements.txt
)

REM Step 4: Start Flask Backend Server in a new window
echo Starting backend on port 5000...
start "Hotel Management System - Flask Backend" cmd /k ""%~dp0.venv\Scripts\python.exe" "%~dp0backend\app.py""

REM Step 5: Start Frontend HTTP Server on port 8000
echo Starting frontend server on port 8000...
start "Hotel Management System - Frontend" cmd /k ""%~dp0.venv\Scripts\python.exe" -m http.server 8000"

REM Step 6: Wait for servers to initialize
ping 127.0.0.1 -n 4 >nul

REM Step 7: Open Frontend application in browser
echo Opening application...
start http://localhost:8000/index.html

echo.
echo ==================================================
echo   Hotel Management System is running!
echo   - Backend API : http://127.0.0.1:5000
echo   - Frontend App: http://localhost:8000/index.html
echo ==================================================
echo.
