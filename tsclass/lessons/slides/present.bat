@echo off
setlocal enabledelayedexpansion

set "SLIDES_DIR=%~dp0"

echo.
echo  Trust and Safety Class -- Slide Launcher
echo  ==========================================
echo.

if not "%~1"=="" (
    set "PDF=%~1"
    goto launch
)

echo   1.  Large Scale Trust and Safety Systems
echo   2.  Introduction to Trust and Safety
echo   3.  Content Moderation
echo   4.  Metrics and Measurement
echo   5.  Government Regulation
echo   6.  Harassment and Hate Speech
echo   7.  Terrorism, Radicalization and Extremism
echo   8.  Information Environment
echo   9.  Emerging Trust and Safety Topics
echo.
set /p choice="  Enter number (1-9): "

if "%choice%"=="1" set "PDF=01. Large Scale Trust & Safety Systems.pdf"
if "%choice%"=="2" set "PDF=Consortium_Introduction_to_Trust_and_Safety.pdf"
if "%choice%"=="3" set "PDF=Consortium_Content_Moderation.pdf"
if "%choice%"=="4" set "PDF=Consortium_Metrics_and_Measurement.pdf"
if "%choice%"=="5" set "PDF=Consortium_Government_Regulation.pdf"
if "%choice%"=="6" set "PDF=Consortium_Harassment_and_Hate_Speech.pdf"
if "%choice%"=="7" set "PDF=Consortium_Terrorism_Radicalization_and_Extremism.pdf"
if "%choice%"=="8" set "PDF=Consortium_Information_Environment.pdf"
if "%choice%"=="9" set "PDF=Consortium_Emerging-Trust_And_Safety_Topics.pdf"

if not defined PDF (
    echo  Invalid choice.
    pause
    exit /b 1
)

:launch
set "FULL_PATH=%SLIDES_DIR%%PDF%"
echo.
echo  Path: %FULL_PATH%
echo.

:: Check the file actually exists
if not exist "%FULL_PATH%" (
    echo  ERROR: File not found: %FULL_PATH%
    pause
    exit /b 1
)

:: Try pympress on PATH
where pympress >nul 2>&1
if %errorlevel%==0 (
    echo  Running: pympress
    pympress "%FULL_PATH%"
    goto done
)

:: Fall back to python -m pympress
echo  pympress not on PATH, trying: python -m pympress
python -m pympress "%FULL_PATH%"

:done
if errorlevel 1 (
    echo.
    echo  Launch failed. Check that Pympress installed correctly by running:
    echo    python -m pympress --version
    echo.
    pause
)
