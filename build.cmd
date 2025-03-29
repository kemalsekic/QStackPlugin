@echo off
REM filepath: c:\SBSDEV\Kemal\qs_scraps\QS_SCRAPS\Main\QStackPlugin\build.cmd
cls
echo.
echo ===========================================
echo             QStackPlugin Build Process             
echo ===========================================
echo.

echo Step 1: Checking for modules...
echo =========================
echo.
powershell -ExecutionPolicy Bypass -Command "if (-not (Get-Module -ListAvailable -Name PS2EXE)) { Write-Host 'PS2EXE module not found. Installing...' -ForegroundColor Yellow; Install-Module -Name PS2EXE -Scope CurrentUser -Force -AllowClobber; Write-Host 'PS2EXE module installed successfully!' -ForegroundColor Green } else { Write-Host 'Modules already installed.' -ForegroundColor Green }"

if %ERRORLEVEL% NEQ 0 (
    echo Failed to check or install the PS2EXE module. Please run PowerShell as administrator and try again.
    exit /b %ERRORLEVEL%
)

echo.
echo Step 2: Creating the installer...
echo =========================
echo.
powershell -ExecutionPolicy Bypass -File ".\Setup\createInstaller.ps1"

echo.
if %ERRORLEVEL% NEQ 0 (
    echo Conversion failed. Build process stopped.
    exit /b %ERRORLEVEL%
)

echo Step 3: Packaging QstackPlugin...
echo =========================
echo.
powershell -ExecutionPolicy Bypass -File ".\Setup\zipPlugin.ps1"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Build completed successfully!
) else (
    echo.
    echo Build failed at the zipping stage.
)

echo.