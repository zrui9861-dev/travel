@echo off
REM ===========================================================================
REM  TerraPortal - one-click launcher for Windows
REM
REM  Double-click this file. It starts a local server and opens your browser.
REM  Close the window (or press Ctrl+C) to stop it.
REM
REM  Each runtime is tested by actually running it, not just by finding a name:
REM  "python" on PATH is very often the Microsoft Store stub, which opens the
REM  Store instead of serving anything.
REM ===========================================================================
setlocal
cd /d "%~dp0"

set PORT=%1
if "%PORT%"=="" set PORT=8731

REM --- 1. Node ---------------------------------------------------------------
node --version >nul 2>nul
if %errorlevel%==0 (
    echo   TerraPortal: starting with Node...
    node serve.js %PORT% %2 %3
    goto :done
)

REM --- 2. Python 3 launcher --------------------------------------------------
py -3 -c "import sys" >nul 2>nul
if %errorlevel%==0 (
    echo   TerraPortal: starting with Python...
    start "" cmd /c "ping -n 3 127.0.0.1 >nul & start "" http://127.0.0.1:%PORT%/"
    py -3 -m http.server %PORT% --bind 127.0.0.1
    goto :done
)

REM --- 3. python on PATH, if it is a real interpreter -----------------------
python -c "import sys" >nul 2>nul
if %errorlevel%==0 (
    echo   TerraPortal: starting with Python...
    start "" cmd /c "ping -n 3 127.0.0.1 >nul & start "" http://127.0.0.1:%PORT%/"
    python -m http.server %PORT% --bind 127.0.0.1
    goto :done
)

REM --- 4. Nothing installed: open the page directly -------------------------
echo.
echo   Neither Node.js nor Python is available.
echo   Opening index.html directly. It works, but some browsers restrict
echo   local file access - installing Node.js gives the full experience.
echo.
start "" "index.html"
ping -n 9 127.0.0.1 >nul

:done
