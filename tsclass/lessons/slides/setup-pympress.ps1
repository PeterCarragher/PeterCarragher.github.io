# setup-pympress.ps1
# Run this once from PowerShell to install Pympress on Windows.
# Right-click → "Run with PowerShell", or open PowerShell and run:
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#   .\setup-pympress.ps1

Write-Host "`nPympress setup for Trust & Safety Class slides" -ForegroundColor Cyan
Write-Host "===============================================`n"

# 1. Check Python
try {
    $pyver = python --version 2>&1
    Write-Host "[OK] Found $pyver" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Python not found. Install Python 3 from https://python.org then re-run this script." -ForegroundColor Red
    exit 1
}

# 2. Install / upgrade pympress
Write-Host "`nInstalling pympress..." -ForegroundColor Yellow
pip install --upgrade pympress

# 3. Test whether GTK runtime is present (required on Windows)
$gtkok = python -c "import gi; gi.require_version('Gtk','3.0'); from gi.repository import Gtk; print('GTK OK')" 2>&1
if ($gtkok -match "GTK OK") {
    Write-Host "[OK] GTK3 runtime found — Pympress is ready." -ForegroundColor Green
} else {
    Write-Host "`n[WARNING] GTK3 runtime not found." -ForegroundColor Yellow
    Write-Host "Pympress requires GTK3 on Windows. Two options:`n"
    Write-Host "  Option A (easiest): Download the all-in-one Pympress Windows installer"
    Write-Host "  which bundles GTK3 — no separate install needed:"
    Write-Host "  https://github.com/Cimbali/pympress/releases/latest`n"
    Write-Host "  Option B: Install GTK3 runtime manually via MSYS2:"
    Write-Host "  https://www.msys2.org  →  pacman -S mingw-w64-x86_64-gtk3`n"
    Write-Host "  After installing GTK3, run this script again to verify." -ForegroundColor Cyan
}

Write-Host "`nDone. Use present.bat to launch a slide deck." -ForegroundColor Cyan
