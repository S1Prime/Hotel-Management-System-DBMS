@echo off
setlocal enabledelayedexpansion

REM Set project root to batch file's own directory
cd /d "%~dp0"

echo ==================================================
echo Hotel Management System - First-Time Setup
echo ==================================================

REM Step 1: Check Python
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

REM Step 2: Create Virtual Environment (.venv)
if not exist ".venv" (
    echo Creating virtual environment .venv...
    python -m venv .venv
    if errorlevel 1 (
        echo [ERROR] Failed to create virtual environment.
        pause
        exit /b 1
    )
)

REM Step 3: Install Dependencies
echo Installing dependencies from backend\requirements.txt...
".venv\Scripts\python.exe" -m pip install -r backend\requirements.txt
if errorlevel 1 (
    echo [ERROR] Failed to install required Python packages.
    pause
    exit /b 1
)

REM Step 4: Initialize PostgreSQL Database
echo Initializing PostgreSQL Database...
".venv\Scripts\python.exe" backend\init_db.py

echo.
echo ==================================================
echo   First-Time Setup Complete!
echo   You can now launch the application anytime by
echo   double-clicking 'start.bat'.
echo ==================================================
echo.
pause
